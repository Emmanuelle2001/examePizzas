from flask_wtf import FlaskForm
from wtforms import StringField, IntegerField, RadioField, BooleanField, SubmitField, HiddenField
from wtforms.validators import DataRequired, Length, NumberRange

class ClienteForm(FlaskForm):
    nombre = StringField('Nombre', validators=[DataRequired(), Length(max=100)])
    direccion = StringField('Dirección', validators=[DataRequired(), Length(max=200)])
    telefono = StringField('Teléfono', validators=[DataRequired(), Length(max=20)])
    form_type = HiddenField(default='cliente')
    submit = SubmitField('Guardar Cliente')

class PizzaForm(FlaskForm):
    tamano = RadioField('Tamaño Pizza',
                       choices=[('chica', 'Chica $40'),
                               ('mediana', 'Mediana $80'),
                               ('grande', 'Grande $120')],
                       validators=[DataRequired()])
    jamon = BooleanField('Jamón (+$10)')
    pina = BooleanField('Piña (+$10)')
    champinones = BooleanField('Champiñones (+$10)')
    numero = IntegerField('Número de Pizzas',
                         validators=[DataRequired(), NumberRange(min=1, max=100)],
                         default=1)
    form_type = HiddenField(default='pizza')
    agregar = SubmitField('Agregar Pizza')

class QuitarForm(FlaskForm):
    quitar = SubmitField('Quitar')