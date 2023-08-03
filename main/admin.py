from django.contrib import admin
from django.utils.html import format_html

# Register your models here.
from .models import Student, Faculty, Course, Department, Assignment, Announcement
from .forms import StudentChangeForm, FacultyChangeForm

# admin.site.register(Student)
# admin.site.register(Faculty)
admin.site.register(Course)
admin.site.register(Department)
admin.site.register(Assignment)
admin.site.register(Announcement)


@admin.register(Student)
class StudentAdmin(admin.ModelAdmin):
    form = StudentChangeForm
    list_display = ('image_tag', 'student_id', 'name', 'email', 'department')
    search_fields = ('name', 'email')

    def display_circular_photo(self, obj):
        return format_html('<div style="width: 50px; height: 50px; border-radius: 50%; overflow: hidden;"><img src="{}" style="width: 100%; height: 100%;" /></div>', obj.photo.url)

    display_circular_photo.short_description = 'Photo'


@admin.register(Faculty)
class FacultyAdmin(admin.ModelAdmin):
    form = FacultyChangeForm
    list_display = ('image_tag', 'faculty_id', 'name', 'email', 'role')
    search_fields = ('name', 'email')

    def display_circular_photo(self, obj):
        return format_html('<div style="width: 50px; height: 50px; border-radius: 50%; overflow: hidden; display: flex; justify-content: center; align-items: center;"><img src="{}" style="width: 100%; height: 100%; object-fit: cover;" /></div>', obj.photo.url)

    display_circular_photo.short_description = 'Photo'
