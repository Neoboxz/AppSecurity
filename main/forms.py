from django import forms
from froala_editor.widgets import FroalaEditor
from .models import Announcement, Assignment, Material, Student, Faculty


# Read passwords in symbols only
class PasswordSpecialCharactersWidget(forms.PasswordInput):
    def get_context(self, name, value, attrs):
        context = super().get_context(name, value, attrs)
        if value:
            masked_value = '*' * len(value)
            context['widget']['value'] = masked_value
        return context


class StudentChangeForm(forms.ModelForm):
    password = forms.CharField(widget=PasswordSpecialCharactersWidget, required=False,
                               help_text='Passwords are hashed and stored')

    class Meta:
        model = Student
        fields = '__all__'

    def save(self, commit=True):
        student = super().save(commit=False)
        raw_password = self.cleaned_data.get('password')
        if raw_password:
            student.set_password(raw_password)
        if commit:
            student.save()
        return student


class FacultyChangeForm(forms.ModelForm):
    password = forms.CharField(widget=PasswordSpecialCharactersWidget, required=False
                               ,help_text='Passwords are hashed and stored')

    class Meta:
        model = Faculty
        fields = '__all__'

    def save(self, commit=True):
        faculty = super().save(commit=False)
        raw_password = self.cleaned_data.get('password')
        if raw_password:
            faculty.set_password(raw_password)
        if commit:
            faculty.save()
        return faculty


class PasswordResetForm(forms.Form):
    email = forms.EmailField()


class AnnouncementForm(forms.ModelForm):
    def __init__(self, *args, **kwargs):
        super(AnnouncementForm, self).__init__(*args, **kwargs)
        self.fields['description'].required = True
        self.fields['description'].label = ''

    class Meta:
        model = Announcement
        fields = ['description']
        widgets = {
            'description': FroalaEditor(),
        }


class AssignmentForm(forms.ModelForm):
    def __init__(self, *args, **kwargs):
        super(AssignmentForm, self).__init__(*args, **kwargs)
        for field in self.fields.values():
            field.required = True
            field.label = ''
        self.fields['file'].required = False

    class Meta:
        model = Assignment
        fields = ('title', 'description', 'deadline', 'marks', 'file')
        widgets = {
            'description': FroalaEditor(),
            'title': forms.TextInput(attrs={'class': 'form-control mt-1', 'id': 'title', 'name': 'title', 'placeholder': 'Title'}),
            'deadline': forms.DateTimeInput(attrs={'class': 'form-control mt-1', 'id': 'deadline', 'name': 'deadline', 'type': 'datetime-local'}),
            'marks': forms.NumberInput(attrs={'class': 'form-control mt-1', 'id': 'marks', 'name': 'marks', 'placeholder': 'Marks'}),
            'file': forms.FileInput(attrs={'class': 'form-control mt-1', 'id': 'file', 'name': 'file', 'aria-describedby': 'file', 'aria-label': 'Upload'}),
        }


class MaterialForm(forms.ModelForm):
    def __init__(self, *args, **kwargs):
        super(MaterialForm, self).__init__(*args, **kwargs)
        for field in self.fields.values():
            field.required = True
            field.label = ""
        self.fields['file'].required = False

    class Meta:
        model = Material
        fields = ('description', 'file')
        widgets = {
            'description': FroalaEditor(),
            'file': forms.FileInput(attrs={'class': 'form-control', 'id': 'file', 'name': 'file', 'aria-describedby': 'file', 'aria-label': 'Upload'}),
        }