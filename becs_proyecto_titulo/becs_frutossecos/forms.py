
from django import forms
from django.forms import ModelForm
from .models import Producto, Categoria
from django.contrib.auth.forms import UserCreationForm, AuthenticationForm
from django.contrib.auth.models import User
from django.core.validators import RegexValidator, MinLengthValidator, EmailValidator
from django.core.exceptions import ValidationError
import re #importar expresiones regulares (d para buscar numeros)


validate_only_letters = RegexValidator( #no va con def porque no es un meteodo si no, un objeto de regexvalidator que se utiliza para validar campos de formulario
    r'^[a-zA-Z\s]*$',  # Expresión regular: solo letras y espacios
    'Este campo solo puede contener letras y espacios.',
    'invalid')

class CustomAuthenticationForm(forms.Form):
    username = forms.CharField(max_length=150)
    password = forms.CharField(widget=forms.PasswordInput)
# definición de los campos del formulario con widgets y atributos requeridos para inicias sesion/registrar
class CustomAuthenticationForm(AuthenticationForm):
    username = forms.CharField(label="Nombre de Usuario",widget=forms.TextInput(attrs={
        'class': 'form-control',
        'placeholder': 'Nombre de Usuario' #esto es lo que se ve como en plomo a la hora de ingresar un dato en el formulario
    }))
    password = forms.CharField(label="Contraseña", widget=forms.PasswordInput(attrs={
        'class': 'form-control',
        'placeholder': 'Contraseña'
    }))
class RegistroUserForm(UserCreationForm):
    username = forms.CharField(label="Nombre de Usuario", widget=forms.TextInput(attrs={
        'class': 'form-control',
        'placeholder': 'Nombre de Usuario'
    }))
    first_name = forms.CharField(label="Nombre",validators=[validate_only_letters], widget=forms.TextInput(attrs={
        'class': 'form-control',
        'placeholder': 'Nombre'
    }))
    last_name = forms.CharField(label="Apellido",validators=[validate_only_letters], widget=forms.TextInput(attrs={
        'class': 'form-control',
        'placeholder': 'Apellido'
    }))
    email = forms.CharField(label="Email", widget=forms.EmailInput(attrs={
        'class': 'form-control',
        'placeholder': 'Email'
    }))
    password1 = forms.CharField(label="Contraseña", widget=forms.PasswordInput(attrs={
        'class': 'form-control',
        'placeholder': 'Contraseña'
    }))
    password2 = forms.CharField(label="Repetir contraseña", widget=forms.PasswordInput(attrs={
        'class': 'form-control',
        'placeholder': 'Repetir contraseña'
    }))
#validacion de que las contraseñas sean iguales
    def clean(self):
        cleaned_data = super().clean() #se llama el metodo clean de la clase base para obtener los datos sin nada(limpios)
        password1 = cleaned_data.get("password1") #acá obtiene el valor de la password1
        password2 = cleaned_data.get("password2")#acá obtiene el valor de la password2

        if password1 and password2: #si los dos campos tienen valores
            if password1 != password2: # si password1 es diferente a password2 entonces:
                self.add_error('password2', 'Las contraseñas no coinciden') # se manda un mensaje de error que diga que las contraseñas no coinciden

#validacion para ver si el usuario ya esta registrado o no
    def clean_username(self):
        username = self.cleaned_data.get('username') #se obtiene el valor limpio (el campo)
        if User.objects.filter(username=username).exists():# si ya existe un usuario con ese correo electronico entonces:
            raise ValidationError("Este nombre de usuario ya está tomado") #si existe, se manda con un mensaje de q ya esta tomado
        return username # y se retorna el campo limpio

#validacion para comprobar si el correo ya esta registrado o no
    def clean_email(self): 
        email = self.cleaned_data.get('email')#se obtiene el campo limpio
        if User.objects.filter(email=email).exists(): # si ya existe un usuario con ese correo entonces:
            raise ValidationError("Este correo electrónico ya está registrado.") #se manda el mensaje de error q diga que ya esta asociado
        return email #se retorna el campo limpio

    class Meta:
        model = User
        fields = [ 'username', 'first_name', 'last_name', 'email', 'password1', 'password2']


        
