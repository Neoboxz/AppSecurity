from django.db import models
from froala_editor.fields import FroalaField
import random
import string
# Create your models here.
from datetime import datetime
from django.contrib.auth.models import User
from django.contrib.auth.hashers import make_password
from django.utils.html import mark_safe
from django.db.models.signals import post_save
from django.dispatch import receiver
import os
from django.core.exceptions import ValidationError
from django.db import models

# Signal to create Profile for each User
class Profile(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE)
    reset_otp = models.CharField(max_length=6, null=True, blank=True)


@receiver(post_save, sender=User)
def create_user_profile(sender, instance, created, **kwargs):
    if created:
        Profile.objects.create(user=instance)


class Student(models.Model):
    student_id = models.IntegerField(primary_key=True)
    name = models.CharField(max_length=100, null=False)
    email = models.EmailField(max_length=100, null=True, blank=True)
    password = models.CharField(max_length=255, null=False)
    role = models.CharField(
        default="Student", max_length=100, null=False, blank=True)
    course = models.ManyToManyField(
        'Course', related_name='students', blank=True)
    photo = models.ImageField(upload_to='profile_pics', blank=True,
                              null=False, default='profile_pics/default_student.png')
    department = models.ForeignKey(
        'Department', on_delete=models.CASCADE, null=False, blank=False, related_name='students')

    def set_password(self, raw_password):
        self.password = make_password(raw_password)

    def image_tag(self):
        if self.photo:
            return mark_safe('<img src="%s" height="50" />' % self.photo.url)
        else:
            return mark_safe('<img src="%s" height="50" />' % self._meta.get_field('photo').get_default())

    # def image_tag(self):
    #     return mark_safe('<img src="%s" height="50"/>' % self.photo.url)

    image_tag.short_description = 'Photo'

    def delete(self, *args, **kwargs):
        if self.photo != 'profile_pics/default_student.png':
            self.photo.delete()
        super().delete(*args, **kwargs)

    class Meta:
        verbose_name_plural = 'Students'

    def __str__(self):
        return self.name


class Faculty(models.Model):
    faculty_id = models.IntegerField(primary_key=True)
    name = models.CharField(max_length=100, null=False)
    email = models.EmailField(max_length=100, null=True, blank=True)
    password = models.CharField(max_length=255, null=False)
    department = models.ForeignKey(
        'Department', on_delete=models.CASCADE, null=False, related_name='faculty')
    role = models.CharField(
        default="Faculty", max_length=100, null=False, blank=True)
    photo = models.ImageField(upload_to='profile_pics', blank=True,
                              null=False, default='profile_pics/default_faculty.png')

    def set_password(self, raw_password):
        self.password = make_password(raw_password)

    # def image_tag(self):
    #     return mark_safe('<img src="%s" height="50"/>' % self.photo.url)

    def image_tag(self):
        if self.photo:
            return mark_safe('<img src="%s" height="50" />' % self.photo.url)
        else:
            return mark_safe('<img src="%s" height="50" />' % self._meta.get_field('photo').get_default())

    image_tag.short_description = 'Photo'

    def delete(self, *args, **kwargs):
        if self.photo != 'profile_pics/default_faculty.png':
            self.photo.delete()
        super().delete(*args, **kwargs)

    class Meta:
        verbose_name_plural = 'Faculty'

    def __str__(self):
        return self.name


class Department(models.Model):
    department_id = models.IntegerField(primary_key=True)
    name = models.CharField(max_length=100, null=False)
    description = models.TextField(null=True, blank=True)

    class Meta:
        verbose_name_plural = 'Departments'

    def __str__(self):
        return self.name

    def student_count(self):
        return self.students.count()

    def faculty_count(self):
        return self.faculty.count()

    def course_count(self):
        return self.courses.count()


class Course(models.Model):
    code = models.IntegerField(primary_key=True)
    name = models.CharField(max_length=255, null=False, unique=True)
    department = models.ForeignKey(
        Department, on_delete=models.CASCADE, null=False, related_name='courses')
    faculty = models.ForeignKey(
        Faculty, on_delete=models.SET_NULL, null=True, blank=True)
    studentKey = models.IntegerField(null=False, unique=True)
    facultyKey = models.IntegerField(null=False, unique=True)

    class Meta:
        unique_together = ('code', 'department', 'name')
        verbose_name_plural = "Courses"

    def __str__(self):
        return self.name


class Announcement(models.Model):
    course_code = models.ForeignKey(
        Course, on_delete=models.CASCADE, null=False)
    datetime = models.DateTimeField(auto_now_add=True, null=False)
    description = FroalaField()

    post_date = models.DateTimeField(auto_now_add=True)

    class Meta:
        verbose_name_plural = "Announcements"
        ordering = ['-datetime']

    def __str__(self):
        return self.datetime.strftime("%d-%b-%y, %I:%M %p")
        # return self.datetime.strptime("%d-%b-%y, %I:%M %p")

    def post_date(self):
        return self.datetime.strftime("%d-%b-%y, %I:%M %p")
        # return self.datetime.strptime("%d-%b-%y, %I:%M %p")


class Assignment(models.Model):
    course_code = models.ForeignKey(
        Course, on_delete=models.CASCADE, null=False)
    title = models.CharField(max_length=255, null=False)
    description = models.TextField(null=False)
    datetime = models.DateTimeField(auto_now_add=True, null=False)
    deadline = models.DateTimeField(null=False)
    file = models.FileField(upload_to='assignments/', null=True, blank=True)
    marks = models.DecimalField(max_digits=6, decimal_places=2, null=False)

    class Meta:
        verbose_name_plural = "Assignments"
        ordering = ['-datetime']

    def __str__(self):
        return self.title

    def delete(self, *args, **kwargs):
        self.file.delete()
        super().delete(*args, **kwargs)

    def post_date(self):
        return self.datetime.strftime("%d-%b-%y, %I:%M %p")

    def due_date(self):
        return self.deadline.strftime("%d-%b-%y, %I:%M %p")


class Submission(models.Model):
    def validate_file_extension(value):
        valid_extensions = ['.pdf', '.doc', '.docx', '.png', '.xlsx', '.xls']
        ext = os.path.splitext(value.file_name())[1]
        if ext.lower() not in valid_extensions:
            raise ValidationError("Invalid file type. Only PDF, DOC, and DOCX files are allowed.")
    assignment = models.ForeignKey(
        Assignment, on_delete=models.CASCADE, null=False)
    student = models.ForeignKey(Student, on_delete=models.CASCADE, null=False)
    file = models.FileField(upload_to='submissions/', null=True, validators=[validate_file_extension])
    datetime = models.DateTimeField(auto_now_add=True, null=False)
    marks = models.DecimalField(
        max_digits=6, decimal_places=2, null=True, blank=True)
    status = models.CharField(max_length=100, null=True, blank=True)

    def file_name(self):
        return self.file.name.split('/')[-1]

    def time_difference(self):
        difference = self.assignment.deadline - self.datetime
        days = difference.days
        hours = difference.seconds//3600
        minutes = (difference.seconds//60) % 60
        seconds = difference.seconds % 60

        if days == 0:
            if hours == 0:
                if minutes == 0:
                    return str(seconds) + " seconds"
                else:
                    return str(minutes) + " minutes " + str(seconds) + " seconds"
            else:
                return str(hours) + " hours " + str(minutes) + " minutes " + str(seconds) + " seconds"
        else:
            return str(days) + " days " + str(hours) + " hours " + str(minutes) + " minutes " + str(seconds) + " seconds"

    def submission_date(self):
        return self.datetime.strftime("%d-%b-%y, %I:%M %p")

    def delete(self, *args, **kwargs):
        self.file.delete()
        super().delete(*args, **kwargs)

    def __str__(self):
        return self.student.name + " - " + self.assignment.title

    class Meta:
        unique_together = ('assignment', 'student')
        verbose_name_plural = "Submissions"
        ordering = ['datetime']


class Material(models.Model):
    course_code = models.ForeignKey(
        Course, on_delete=models.CASCADE, null=False)
    description = models.TextField(max_length=2000, null=False)
    datetime = models.DateTimeField(auto_now_add=True, null=False)
    file = models.FileField(upload_to='materials/', null=True, blank=True)

    class Meta:
        verbose_name_plural = "Materials"
        ordering = ['-datetime']

    def __str__(self):
        return self.title

    def delete(self, *args, **kwargs):
        self.file.delete()
        super().delete(*args, **kwargs)

    def post_date(self):
        return self.datetime.strftime("%d-%b-%y, %I:%M %p")