#from django import forms
#from django.forms import ModelForm
#from .models import Producto, Categoria
#from django.contrib.auth.forms import UserCreationForm, AuthenticationForm
#from django.core.validators import RegexValidator, MinLengthValidator, EmailValidator
#from django.core.exceptions import ValidationError
#import re #importar expresiones regulares (d para buscar numeros)
#from .models import CustomUser
#from django import forms
#from .models import Cliente
#from django.contrib.auth.forms import UserCreationForm
#from django.core.exceptions import ValidationError
#from django.contrib.auth.hashers import make_password

"""
class ClienteForm(UserCreationForm):
    apellido  = forms.CharField(
    label='Apellido',
    widget=forms.TextInput(attrs={'class': 'form-control', 'placeholder': 'Apellido'})
    )
    password1 = forms.CharField(
        label='Contraseña',
        widget=forms.PasswordInput(attrs={'class': 'form-control', 'placeholder': 'Contraseña'})
    )
    password2 = forms.CharField(
        label='Confirmar Contraseña',
        widget=forms.PasswordInput(attrs={'class': 'form-control', 'placeholder': 'Confirmar contraseña'})
    )

    class Meta:
        model = Cliente
        fields = ['nombre', 'email']
        widgets = {
            'nombre': forms.TextInput(attrs={'class': 'form-control', 'placeholder': 'Nombre'}),
            'email': forms.EmailInput(attrs={'class': 'form-control', 'placeholder': 'Correo electrónico'}),
        }

    def clean(self):
        cleaned_data = super().clean()
        p1 = cleaned_data.get("contraseña")
        p2 = cleaned_data.get("contraseña2")
        if p1 and p2 and p1 != p2:
            raise ValidationError("Las contraseñas no coinciden.")
        return cleaned_data

    def save(self, commit=True):
        cliente = super().save(commit=False)
        cliente.contraseña = make_password(self.cleaned_data['password1'])
        if commit:
            cliente.save()
        return cliente
"""

#validate_only_letters = RegexValidator( #no va con def porque no es un meteodo si no, un objeto de regexvalidator que se utiliza para validar campos de formulario
#    r'^[a-zA-Z\s]*$',  # Expresión regular: solo letras y espacios
#    'Este campo solo puede contener letras y espacios.',
#    'invalid')

#class CustomAuthenticationForm(forms.Form):
#    email = forms.CharField(max_length=150)
#    password = forms.CharField(widget=forms.PasswordInput)
# definición de los campos del formulario con widgets y atributos requeridos para inicias sesion/registrar
#class CustomAuthenticationForm(AuthenticationForm):
#    password = forms.CharField(label="Contraseña", widget=forms.PasswordInput(attrs={
#        'class': 'form-control',
#        'placeholder': 'Contraseña'
#    }))
#class RegistroUserForm(UserCreationForm):
#    first_name = forms.CharField(label="Nombre",validators=[validate_only_letters], widget=forms.TextInput(attrs={
#        'class': 'form-control',
#        'placeholder': 'Nombre'
#    }))
#    last_name = forms.CharField(label="Apellido",validators=[validate_only_letters], widget=forms.TextInput(attrs={
#        'class': 'form-control',
#        'placeholder': 'Apellido'
#    }))
#   email = forms.CharField(label="Email", widget=forms.EmailInput(attrs={
#        'class': 'form-control',
#        'placeholder': 'Email'
#    }))
#    password1 = forms.CharField(label="Contraseña", widget=forms.PasswordInput(attrs={
#        'class': 'form-control',
#        'placeholder': 'Contraseña'
#    }))
#   password2 = forms.CharField(label="Repetir contraseña", widget=forms.PasswordInput(attrs={
#       'class': 'form-control',
#       'placeholder': 'Repetir contraseña'
#   }))
#validacion de que las contraseñas sean iguales
#   def clean(self):
#       cleaned_data = super().clean() #se llama el metodo clean de la clase base para obtener los datos sin nada(limpios)
#       password1 = cleaned_data.get("password1") #acá obtiene el valor de la password1
#       password2 = cleaned_data.get("password2")#acá obtiene el valor de la password2
#
#        if password1 and password2: #si los dos campos tienen valores
#            if password1 != password2: # si password1 es diferente a password2 entonces:
#                self.add_error('password2', 'Las contraseñas no coinciden') # se manda un mensaje de error que diga que las contraseñas no coinciden

#validacion para comprobar si el correo ya esta registrado o no
#    def clean_email(self): 
#        email = self.cleaned_data.get('email')#se obtiene el campo limpio
#        if CustomUser.objects.filter(email=email).exists(): # si ya existe un usuario con ese correo entonces:
#            raise ValidationError("Este correo electrónico ya está registrado.") #se manda el mensaje de error q diga que ya esta asociado
#        return email #se retorna el campo limpio

#   class Meta:
#        model = CustomUser
#        fields = [ 'first_name', 'last_name', 'email', 'password1', 'password2']