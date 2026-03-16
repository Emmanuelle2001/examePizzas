from flask import Flask, render_template, request, redirect, url_for, flash, session
from models import db, Pizza, Cliente, Pedido, DetallePedido
from forms import ClienteForm, PizzaForm, QuitarForm
from config import DevelopmentConfig
from flask_wtf.csrf import CSRFProtect
import datetime
import os

app = Flask(__name__)
app.config.from_object(DevelopmentConfig)
db.init_app(app)
csrf = CSRFProtect(app)

PRECIOS_TAMANIO = {'pequena': 40, 'mediana': 80, 'grande': 120}
PRECIO_ADICIONAL = 10
INGREDIENTES_DISPONIBLES = {'jamon': 'Jamón', 'pina': 'Piña', 'champinones': 'Champiñones'}

@app.errorhandler(404)
def error_no_encontrado(e):
    return render_template("404.html"), 404

@app.route("/", methods=['GET', 'POST'])
def inicio():
    if 'carrito' not in session:
        session['carrito'] = []
    if 'datos_cliente' not in session:
        session['datos_cliente'] = {}
    if 'ultimo_tamanio' not in session:
        session['ultimo_tamanio'] = 'pequena'

    formulario_pizza = PizzaForm()
    formulario_eliminar = QuitarForm()

    if request.method == 'POST':
        if request.form.get('tipo_formulario') == 'pizza':
            session['datos_cliente'] = {
                'nombre': request.form.get('nombre', ''),
                'direccion': request.form.get('direccion', ''),
                'telefono': request.form.get('telefono', '')
            }
            
            if formulario_pizza.validate_on_submit():
                tamanio = formulario_pizza.tamano.data
                session['ultimo_tamanio'] = tamanio
                
                ingredientes_activos = obtener_ingredientes_activos(formulario_pizza)
                cantidad = formulario_pizza.numero.data
                subtotal = calcular_precio_parcial(tamanio, ingredientes_activos, cantidad)

                articulo = {
                    'tamanio': tamanio,
                    'ingredientes': ', '.join(ingredientes_activos),
                    'cantidad': cantidad,
                    'subtotal': subtotal
                }
                session['carrito'].append(articulo)
                session.modified = True
                flash('Producto añadido correctamente', 'success')
                return redirect(url_for('inicio'))
    
    if not formulario_pizza.tamano.data:
        formulario_pizza.tamano.data = session.get('ultimo_tamanio', 'pequena')
    
    ventas_dia, total_hoy = obtener_ventas_hoy()
    return render_template('ventas.html',
                       pizza_form=formulario_pizza,
                       quitar_form=formulario_eliminar,
                       cart=session['carrito'],
                       ventas_hoy=ventas_dia,
                       total_hoy=total_hoy,
                       PRECIOS_TAMANIO=PRECIOS_TAMANIO,
                       PRECIO_ADICIONAL=PRECIO_ADICIONAL)

@app.route("/eliminar/<int:indice>", methods=['POST'])
def eliminar_pizza(indice):
    formulario_eliminar = QuitarForm()
    if formulario_eliminar.validate_on_submit():
        if 0 <= indice < len(session['carrito']):
            session['carrito'].pop(indice)
            session.modified = True
            flash('Producto removido del pedido', 'info')
        else:
            flash('Índice inválido', 'error')
    return redirect(url_for('inicio'))

@app.route("/finalizar", methods=['POST'])
def finalizar_pedido():
    if not session.get('datos_cliente') or not session.get('carrito'):
        flash('Complete los datos del cliente y añada al menos un producto', 'error')
        return redirect(url_for('inicio'))

    info_cliente = session['datos_cliente']
    carrito = session['carrito']

    try:
        cliente_nuevo = Cliente(
            nombre=info_cliente['nombre'],
            direccion=info_cliente['direccion'],
            telefono=info_cliente['telefono']
        )
        db.session.add(cliente_nuevo)
        db.session.flush()
        
        total_venta = sum(item['subtotal'] for item in carrito)
        pedido_nuevo = Pedido(
            id_cliente=cliente_nuevo.id_cliente,
            fecha=datetime.date.today(),
            total=total_venta
        )
        db.session.add(pedido_nuevo)
        db.session.flush()
        
        for item in carrito:
            tamanio = item['tamanio']
            ingredientes = item['ingredientes']
            cantidad = item['cantidad']
            subtotal = item['subtotal']
            precio_unitario = subtotal / cantidad
            
            pizza_existente = Pizza.query.filter_by(tamano=tamanio, ingredientes=ingredientes, precio=precio_unitario).first()
            if not pizza_existente:
                pizza_existente = Pizza(
                    tamano=tamanio,
                    ingredientes=ingredientes,
                    precio=precio_unitario
                )
                db.session.add(pizza_existente)
                db.session.flush()
            
            detalle = DetallePedido(
                id_pedido=pedido_nuevo.id_pedido,
                id_pizza=pizza_existente.id_pizza,
                cantidad=cantidad,
                subtotal=subtotal
            )
            db.session.add(detalle)
        
        db.session.commit()
        session.pop('datos_cliente', None)
        session.pop('carrito', None)
        flash(f'Venta registrada exitosamente. Total: ${total_venta:.2f}', 'success')
    
    except Exception as error:
        db.session.rollback()
        flash(f'Error al procesar la venta: {str(error)}', 'error')
    
    return redirect(url_for('inicio'))

@app.route("/reportes", methods=['GET', 'POST'])
def reportes():
    resultados = None
    suma_total = 0
    filtro_aplicado = None
    
    filtro_seleccionado = request.form.get('tipo_reporte', 'dia')
    dia_seleccionado = request.form.get('dia', '')
    mes_seleccionado = request.form.get('mes', '')
    fecha_inicio_seleccionada = request.form.get('fecha_inicio', '')
    fecha_fin_seleccionada = request.form.get('fecha_fin', '')

    if request.method == 'POST':
        tipo_reporte = request.form.get('tipo_reporte')
        
        if request.form.get('cambiar_filtro'):
            filtro_seleccionado = tipo_reporte
            dia_seleccionado = request.form.get('dia', '')
            mes_seleccionado = request.form.get('mes', '')
            fecha_inicio_seleccionada = request.form.get('fecha_inicio', '')
            fecha_fin_seleccionada = request.form.get('fecha_fin', '')
            
        elif request.form.get('generar_reporte'):
            consulta = db.session.query(Pedido, Cliente.nombre).join(Cliente)

            if tipo_reporte == 'dia':
                valor_dia = request.form.get('dia')
                if valor_dia:
                    from sqlalchemy import func
                    consulta = consulta.filter(func.dayofweek(Pedido.fecha) == int(valor_dia))
                    nombre_dia = request.form.get('dia_nombre', '')
                    filtro_aplicado = f"Día: {nombre_dia}"
                    filtro_seleccionado = 'dia'
                    dia_seleccionado = valor_dia

            elif tipo_reporte == 'mes':
                valor_mes = request.form.get('mes')
                if valor_mes:
                    from sqlalchemy import extract
                    consulta = consulta.filter(extract('month', Pedido.fecha) == int(valor_mes))
                    nombre_mes = request.form.get('mes_nombre', '')
                    filtro_aplicado = f"Mes: {nombre_mes}"
                    filtro_seleccionado = 'mes'
                    mes_seleccionado = valor_mes

            elif tipo_reporte == 'rango':
                fecha_ini = request.form.get('fecha_inicio')
                fecha_fin = request.form.get('fecha_fin')
                if fecha_ini:
                    consulta = consulta.filter(Pedido.fecha >= datetime.datetime.strptime(fecha_ini, '%Y-%m-%d').date())
                if fecha_fin:
                    consulta = consulta.filter(Pedido.fecha <= datetime.datetime.strptime(fecha_fin, '%Y-%m-%d').date())
                if fecha_ini or fecha_fin:
                    filtro_aplicado = f"Período: {fecha_ini or 'inicio'} a {fecha_fin or 'fin'}"
                    filtro_seleccionado = 'rango'
                    fecha_inicio_seleccionada = fecha_ini
                    fecha_fin_seleccionada = fecha_fin

            if filtro_aplicado:
                resultados = consulta.all()
                suma_total = sum(r.Pedido.total for r in resultados)
            else:
                flash('Seleccione un valor para el filtro', 'error')

    return render_template('consultas.html',
                           resultados=resultados,
                           total_acumulado=suma_total,
                           filtro_aplicado=filtro_aplicado,
                           selected_tipo=filtro_seleccionado,
                           selected_dia=dia_seleccionado,
                           selected_mes=mes_seleccionado,
                           selected_fecha_inicio=fecha_inicio_seleccionada,
                           selected_fecha_fin=fecha_fin_seleccionada)

@app.route("/ver_venta/<int:id_pedido>")
def ver_detalle_venta(id_pedido):
    pedido = Pedido.query.get_or_404(id_pedido)
    detalles = db.session.query(DetallePedido, Pizza).join(Pizza).filter(DetallePedido.id_pedido == id_pedido).all()
    articulos = []
    for detalle, pizza in detalles:
        articulos.append({
            'tamano': pizza.tamano,
            'ingredientes': pizza.ingredientes,
            'cantidad': detalle.cantidad,
            'subtotal': detalle.subtotal
        })
    return render_template('detalle_venta.html', pedido=pedido, items=articulos)

def obtener_ingredientes_activos(formulario):
    """Devuelve lista de ingredientes seleccionados a partir del formulario"""
    seleccionados = []
    if formulario.jamon.data:
        seleccionados.append('Jamón')
    if formulario.pina.data:
        seleccionados.append('Piña')
    if formulario.champinones.data:
        seleccionados.append('Champiñones')
    return seleccionados

def calcular_precio_parcial(tamanio, ingredientes_extra, unidades):
    """Calcula subtotal para una pizza"""
    costo_base = PRECIOS_TAMANIO[tamanio]
    costo_extra = len(ingredientes_extra) * PRECIO_ADICIONAL
    return (costo_base + costo_extra) * unidades

def obtener_ventas_hoy():
    """Devuelve lista de ventas de hoy y total acumulado"""
    fecha_actual = datetime.date.today()
    pedidos_realizados = (db.session.query(Pedido, Cliente.nombre)
               .join(Cliente)
               .filter(Pedido.fecha == fecha_actual)
               .all())
    lista_ventas = [{'nombre': nombre, 'total': pedido.total} for pedido, nombre in pedidos_realizados]
    suma_diaria = sum(v['total'] for v in lista_ventas)
    return lista_ventas, suma_diaria

if __name__ == '__main__':
    with app.app_context():
        db.create_all()
    app.run(debug=True)