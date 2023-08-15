from django.shortcuts import *
from django.contrib import messages
from discussion.models import FacultyDiscussion, StudentDiscussion
from main.models import Student, Faculty, Course
from main.views import is_faculty_authorised, is_student_authorised
from itertools import chain
from .forms import StudentDiscussionForm, FacultyDiscussionForm
from django.utils import timezone
import re

# Create your views here.


''' We have two different user models.
    That's why we are filtering the discussions based on the user type and then combining them.'''


def context_list(course):
    try:
        studentDis = StudentDiscussion.objects.filter(course=course)
        facultyDis = FacultyDiscussion.objects.filter(course=course)
        discussions = list(chain(studentDis, facultyDis))
        discussions.sort(key=lambda x: x.sent_at, reverse=True)

        for dis in discussions:
            if dis.__class__.__name__ == 'StudentDiscussion':
                dis.author = Student.objects.get(student_id=dis.sent_by_id)
            else:
                dis.author = Faculty.objects.get(faculty_id=dis.sent_by_id)
    except:

        discussions = []

    return discussions


def discussion(request, code):
    if is_student_authorised(request, code):
        course = Course.objects.get(code=code)
        student = Student.objects.get(student_id=request.session['student_id'])
        discussions = context_list(course)
        form = StudentDiscussionForm()
        context = {
            'course': course,
            'student': student,
            'discussions': discussions,
            'form': form,
        }
        return render(request, 'discussion/discussion.html', context)

    elif is_faculty_authorised(request, code):
        course = Course.objects.get(code=code)
        faculty = Faculty.objects.get(faculty_id=request.session['faculty_id'])
        discussions = context_list(course)
        form = FacultyDiscussionForm()
        context = {
            'course': course,
            'faculty': faculty,
            'discussions': discussions,
            'form': form,
        }
        return render(request, 'discussion/discussion.html', context)
    else:
        return redirect('std_login')


def send(request, code, std_id):
    if is_student_authorised(request, code):
        if request.method == 'POST':
            form = StudentDiscussionForm(request.POST)
            if form.is_valid():
                content = form.cleaned_data['content']
                print(content)
                if validate_text(content):
                    course = Course.objects.get(code=code)
                    try:
                        student = Student.objects.get(student_id=std_id)
                    except:
                        return redirect('discussion', code=code)
                    StudentDiscussion.objects.create(
                        content=content, course=course, sent_by=student)
                    return redirect('discussion', code=code)
                else:
                    messages.error(request, 'That word is not appropriate!')
                    return redirect('discussion', code=code)
            else:
                return redirect('discussion', code=code)
        else:
            return redirect('discussion', code=code)
    else:
        return render(request, 'std_login.html')


def send_fac(request, code, fac_id):
    if is_faculty_authorised(request, code):
        if request.method == 'POST':
            form = FacultyDiscussionForm(request.POST)
            if form.is_valid():
                if spam_prevention(request):
                    content = form.cleaned_data['content']
                    # print(content)
                    if validate_text(content):
                        course = Course.objects.get(code=code)
                        try:
                            faculty = Faculty.objects.get(faculty_id=fac_id)
                        except:
                            return redirect('discussion', code=code)
                        FacultyDiscussion.objects.create(
                            content=content, course=course, sent_by=faculty)
                        return redirect('discussion', code=code)
                    else:
                        return redirect('discussion', {'error': 'Your message may contains vulgar or malicious language!'}, code=code)
                else:
                    return redirect('discussion', {'error': 'slow down there!'}, code=code)
            else:
                return redirect('discussion', code=code)
        else:
            return redirect('discussion', code=code)
    else:
        return render(request, 'std_login.html')


def validate_text(content):
    txt = content.lower()
    banned_words = ['dummy_word1', 'dummy_word2', 'nest_dummy']
    result = True
    for i in range(len(banned_words)):
        if banned_words[i] in txt:
            result = False
    return result


def spam_prevention(request):
    last_refresh_time = request.session.get('last_refresh_time')
    result = False
    if not last_refresh_time:
        request.session['last_refresh_time'] = timezone.now().timestamp()
        result = True
    return result

