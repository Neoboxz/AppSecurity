USE aspjdb;

START TRANSACTION;

-- Disable foreign key checks
SET FOREIGN_KEY_CHECKS = 0;

-- Your import commands here
-- For example:
-- INSERT statements, CREATE TABLE statements, etc.

CREATE TABLE IF NOT EXISTS django_migrations (
	id	integer NOT NULL AUTO_INCREMENT,
	app	varchar(255) NOT NULL,
	name	varchar(255) NOT NULL,
	applied	datetime NOT NULL,
	PRIMARY KEY(id)
);
CREATE TABLE IF NOT EXISTS django_content_type (
    id integer NOT NULL AUTO_INCREMENT,
    app_label varchar(100) NOT NULL,
    model varchar(100) NOT NULL,
    PRIMARY KEY (id)
);
CREATE TABLE IF NOT EXISTS auth_permission (
    id integer NOT NULL AUTO_INCREMENT,
    content_type_id integer NOT NULL,
    codename varchar(100) NOT NULL,
    name varchar(255) NOT NULL,
    FOREIGN KEY (content_type_id) REFERENCES django_content_type (id),
    PRIMARY KEY (id)
);
CREATE TABLE IF NOT EXISTS auth_group (
    id integer NOT NULL AUTO_INCREMENT,
    name varchar(150) NOT NULL UNIQUE,
    PRIMARY KEY (id)
);
CREATE TABLE IF NOT EXISTS auth_user (
    id integer NOT NULL AUTO_INCREMENT,
    password varchar(128) NOT NULL,
    last_login datetime,
    is_superuser bool NOT NULL,
    username varchar(150) NOT NULL UNIQUE,
    last_name varchar(150) NOT NULL,
    email varchar(254) NOT NULL,
    is_staff bool NOT NULL,
    is_active bool NOT NULL,
    date_joined datetime NOT NULL,
    first_name varchar(150) NOT NULL,
    PRIMARY KEY (id)
);
CREATE TABLE IF NOT EXISTS auth_group_permissions (
	id integer NOT NULL AUTO_INCREMENT,
	group_id integer NOT NULL,
	permission_id integer NOT NULL,
	PRIMARY KEY (id),
	FOREIGN KEY (permission_id) REFERENCES auth_permission (id),
	FOREIGN KEY (group_id) REFERENCES auth_group (id)
);
CREATE TABLE IF NOT EXISTS auth_user_groups (
	id	integer NOT NULL AUTO_INCREMENT,
	user_id	integer NOT NULL,
	group_id	integer NOT NULL,
	FOREIGN KEY(group_id) REFERENCES auth_group (id),
	FOREIGN KEY(user_id) REFERENCES auth_user (id),
	PRIMARY KEY(id)
);
CREATE TABLE IF NOT EXISTS auth_user_user_permissions (
	id	integer NOT NULL AUTO_INCREMENT,
	user_id	integer NOT NULL,
	permission_id	integer NOT NULL,
	FOREIGN KEY(permission_id) REFERENCES auth_permission (id),
	FOREIGN KEY(user_id) REFERENCES auth_user (id),
	PRIMARY KEY(id)
);
CREATE TABLE IF NOT EXISTS django_admin_log (
	id	integer NOT NULL AUTO_INCREMENT,
	action_time	datetime NOT NULL,
	object_id	text,
	object_repr	varchar(200) NOT NULL,
	change_message	text NOT NULL,
	content_type_id	integer,
	user_id	integer NOT NULL,
	action_flag	smallint unsigned NOT NULL CHECK(action_flag >= 0),
	FOREIGN KEY (user_id) REFERENCES auth_user (id),
	FOREIGN KEY (content_type_id) REFERENCES django_content_type (id),
	PRIMARY KEY (id)
);
CREATE TABLE IF NOT EXISTS main_department (
	department_id	integer NOT NULL,
	name	varchar(100) NOT NULL,
	description	text,
	PRIMARY KEY (department_id)
);
CREATE TABLE IF NOT EXISTS main_student (
	student_id	integer NOT NULL,
	name	varchar(100) NOT NULL,
	email	varchar(100),
	password	varchar(255) NOT NULL,
	role	varchar(100) NOT NULL,
	photo	varchar(100) NOT NULL,
	department_id	integer NOT NULL,
	FOREIGN KEY (department_id) REFERENCES main_department (department_id),
	PRIMARY KEY (student_id)
);
CREATE TABLE IF NOT EXISTS main_faculty (
    faculty_id integer NOT NULL,
    name varchar(100) NOT NULL,
    email varchar(100),
    password varchar(255) NOT NULL,
    role varchar(100) NOT NULL,
    photo varchar(100) NOT NULL,
    department_id integer NOT NULL,
    FOREIGN KEY (department_id) REFERENCES main_department (department_id),
    PRIMARY KEY (faculty_id)
);
CREATE TABLE IF NOT EXISTS main_course (
    code integer NOT NULL,
    name varchar(255) NOT NULL UNIQUE,
    studentKey integer NOT NULL UNIQUE,
    facultyKey integer NOT NULL UNIQUE,
    department_id integer NOT NULL,
    faculty_id integer,
    FOREIGN KEY (faculty_id) REFERENCES main_faculty (faculty_id),
    FOREIGN KEY (department_id) REFERENCES main_department (department_id),
    PRIMARY KEY (code)
);
CREATE TABLE IF NOT EXISTS main_student_course (
    id integer NOT NULL AUTO_INCREMENT,
    student_id integer NOT NULL,
    course_id integer NOT NULL,
    FOREIGN KEY (student_id) REFERENCES main_student (student_id),
    FOREIGN KEY (course_id) REFERENCES main_course (code),
    PRIMARY KEY (id)
);
CREATE TABLE IF NOT EXISTS main_material (
    id integer NOT NULL AUTO_INCREMENT,
    description text NOT NULL,
    datetime datetime NOT NULL,
    file varchar(100),
    course_code_id integer NOT NULL,
    FOREIGN KEY (course_code_id) REFERENCES main_course (code),
    PRIMARY KEY (id)
);
CREATE TABLE IF NOT EXISTS main_assignment (
    id integer NOT NULL AUTO_INCREMENT,
    title varchar(255) NOT NULL,
    description text NOT NULL,
    datetime datetime NOT NULL,
    deadline datetime NOT NULL,
    file varchar(100),
    marks decimal NOT NULL,
    course_code_id integer NOT NULL,
    FOREIGN KEY (course_code_id) REFERENCES main_course (code),
    PRIMARY KEY (id)
);
CREATE TABLE IF NOT EXISTS main_announcement (
    id integer NOT NULL AUTO_INCREMENT,
    datetime datetime NOT NULL,
    description text NOT NULL,
    course_code_id integer NOT NULL,
    FOREIGN KEY (course_code_id) REFERENCES main_course (code),
    PRIMARY KEY (id)
);
CREATE TABLE IF NOT EXISTS main_submission (
    id integer NOT NULL AUTO_INCREMENT,
    file varchar(100),
    datetime datetime NOT NULL,
    marks decimal,
    status varchar(100),
--    assignment_id bigint NOT NULL,
    assignment_id integer NOT NULL,
    student_id integer NOT NULL,
    FOREIGN KEY (student_id) REFERENCES main_student (student_id),
    FOREIGN KEY (assignment_id) REFERENCES main_assignment (id),
    PRIMARY KEY (id)
);
CREATE TABLE IF NOT EXISTS attendance_attendance (
    id integer NOT NULL AUTO_INCREMENT,
    date date NOT NULL,
    status bool NOT NULL,
    created_at datetime NOT NULL,
    updated_at datetime NOT NULL,
    course_id integer NOT NULL,
    student_id integer NOT NULL,
    FOREIGN KEY (course_id) REFERENCES main_course (code),
    FOREIGN KEY (student_id) REFERENCES main_student (student_id),
    PRIMARY KEY (id)
);
CREATE TABLE IF NOT EXISTS discussion_studentdiscussion (
    id integer NOT NULL AUTO_INCREMENT,
    content text NOT NULL,
    sent_at datetime NOT NULL,
    course_id integer NOT NULL,
    sent_by_id integer NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (course_id) REFERENCES main_course (code),
    FOREIGN KEY (sent_by_id) REFERENCES main_student (student_id)
);
CREATE TABLE IF NOT EXISTS discussion_facultydiscussion (
    id integer NOT NULL AUTO_INCREMENT,
    content text NOT NULL,
    sent_at datetime NOT NULL,
    course_id integer NOT NULL,
    sent_by_id integer NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (sent_by_id) REFERENCES main_faculty (faculty_id),
    FOREIGN KEY (course_id) REFERENCES main_course (code)
);
CREATE TABLE IF NOT EXISTS quiz_quiz (
    id integer NOT NULL AUTO_INCREMENT,
    title varchar(100) NOT NULL,
    description text,
    start datetime NOT NULL,
    end datetime NOT NULL,
    created_at datetime NOT NULL,
    updated_at datetime NOT NULL,
    publish_status bool,
    started bool,
    course_id integer NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (course_id) REFERENCES main_course (code)
);
CREATE TABLE IF NOT EXISTS quiz_question (
    id integer NOT NULL AUTO_INCREMENT,
    question text NOT NULL,
    marks integer NOT NULL,
    option1 text NOT NULL,
    option2 text NOT NULL,
    option3 text NOT NULL,
    option4 text NOT NULL,
    answer varchar(1) NOT NULL,
    explanation text,
--    quiz_id bigint NOT NULL,
    quiz_id integer NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (quiz_id) REFERENCES quiz_quiz (id)
);
CREATE TABLE IF NOT EXISTS quiz_studentanswer (
    id integer NOT NULL AUTO_INCREMENT,
    answer varchar(1),
    marks integer,
    created_at datetime,
    question_id integer NOT NULL,
    quiz_id integer NOT NULL,
    student_id integer NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (question_id) REFERENCES quiz_question (id),
    FOREIGN KEY (quiz_id) REFERENCES quiz_quiz (id),
    FOREIGN KEY (student_id) REFERENCES main_student (student_id)
);
CREATE TABLE IF NOT EXISTS django_session (
    session_key varchar(40) NOT NULL,
    session_data text NOT NULL,
    expire_date datetime NOT NULL,
    PRIMARY KEY (session_key)
);
INSERT IGNORE INTO django_migrations (id,app,name,applied) VALUES (1,'contenttypes','0001_initial','2023-05-12 09:51:45.956207'),
 (2,'auth','0001_initial','2023-05-12 09:51:45.972227'),
 (3,'admin','0001_initial','2023-05-12 09:51:45.988279'),
 (4,'admin','0002_logentry_remove_auto_add','2023-05-12 09:51:45.996276'),
 (5,'admin','0003_logentry_add_action_flag_choices','2023-05-12 09:51:46.012563'),
 (6,'main','0001_initial','2023-05-12 09:51:46.070715'),
 (7,'attendance','0001_initial','2023-05-12 09:51:46.085521'),
 (8,'contenttypes','0002_remove_content_type_name','2023-05-12 09:51:46.128477'),
 (9,'auth','0002_alter_permission_name_max_length','2023-05-12 09:51:46.142684'),
 (10,'auth','0003_alter_user_email_max_length','2023-05-12 09:51:46.150698'),
 (11,'auth','0004_alter_user_username_opts','2023-05-12 09:51:46.166871'),
 (12,'auth','0005_alter_user_last_login_null','2023-05-12 09:51:46.175038'),
 (13,'auth','0006_require_contenttypes_0002','2023-05-12 09:51:46.183041'),
 (14,'auth','0007_alter_validators_add_error_messages','2023-05-12 09:51:46.191123'),
 (15,'auth','0008_alter_user_username_max_length','2023-05-12 09:51:46.207036'),
 (16,'auth','0009_alter_user_last_name_max_length','2023-05-12 09:51:46.215032'),
 (17,'auth','0010_alter_group_name_max_length','2023-05-12 09:51:46.231023'),
 (18,'auth','0011_update_proxy_permissions','2023-05-12 09:51:46.239102'),
 (19,'auth','0012_alter_user_first_name_max_length','2023-05-12 09:51:46.247097'),
 (20,'discussion','0001_initial','2023-05-12 09:51:46.270618'),
 (21,'quiz','0001_initial','2023-05-12 09:51:46.302970'),
 (22,'sessions','0001_initial','2023-05-12 09:51:46.311071');
INSERT IGNORE INTO auth_group_permissions (id,group_id,permission_id) VALUES (4,2,5),
 (5,2,6),
 (6,2,7),
 (7,2,8),
 (8,2,9),
 (9,2,10),
 (10,2,11),
 (11,2,12),
 (12,2,13),
 (13,2,14),
 (14,2,15),
 (15,2,16),
 (16,2,17),
 (17,2,18),
 (18,2,19),
 (19,2,20),
 (20,2,21),
 (21,2,22),
 (22,2,23),
 (23,2,24),
 (24,2,25),
 (25,2,26),
 (26,2,27),
 (27,2,28),
 (28,2,29),
 (29,2,30),
 (30,2,31),
 (31,2,32),
 (32,2,33),
 (33,2,34),
 (34,2,35),
 (35,2,36),
 (36,2,37),
 (37,2,38),
 (38,2,39),
 (39,2,40),
 (40,2,41),
 (41,2,42),
 (42,2,43),
 (43,2,44),
 (44,2,45),
 (45,2,46),
 (46,2,47),
 (47,2,48),
 (48,2,49),
 (49,2,50),
 (50,2,51),
 (51,2,52),
 (52,2,53),
 (53,2,54),
 (54,2,55),
 (55,2,56),
 (56,2,57),
 (57,2,58),
 (58,2,59),
 (59,2,60),
 (60,2,61),
 (61,2,62),
 (62,2,63),
 (63,2,64),
 (64,2,65),
 (65,2,66),
 (66,2,67),
 (67,2,68),
 (68,2,69),
 (69,2,70),
 (70,2,71),
 (71,2,72),
 (72,2,73),
 (73,2,74),
 (74,2,75),
 (75,2,76),
 (76,2,77),
 (77,2,78),
 (78,2,79),
 (79,2,80);
INSERT IGNORE INTO auth_user_groups (id,user_id,group_id) VALUES (2,4,2);
INSERT IGNORE INTO django_admin_log (id,action_time,object_id,object_repr,change_message,content_type_id,user_id,action_flag) VALUES (1,'2023-05-12 09:57:21.640923','1','Environmental Science','[{"added": {}}]',8,1,1),
 (2,'2023-05-12 09:58:20.173454','1','John','[{"added": {}}]',11,1,1),
 (3,'2023-05-12 09:58:53.642209','1','Environmental sustanability fundamentals','[{"added": {}}]',7,1,1),
 (4,'2023-05-12 09:59:32.098153','1','Mary','[{"added": {}}]',9,1,1),
 (5,'2023-05-12 10:00:11.947104','1','12-May-23, 10:00 AM','[{"added": {}}]',13,1,1),
 (6,'2023-05-12 10:01:19.591144','1','Assignment 1','[{"added": {}}]',12,1,1),
 (7,'2023-05-12 10:02:17.338463','1','Simple quiz about Environment','[{"added": {}}]',18,1,1),
 (8,'2023-05-12 10:03:00.328947','1','Testing','[{"added": {}}]',19,1,1),
 (9,'2023-05-12 18:50:24.525095','10','Mary','[{"changed": {"fields": ["Student id", "Password"]}}]',9,1,2),
 (10,'2023-05-12 18:50:42.228113','10','Mary','',9,1,3),
 (11,'2023-05-12 18:50:55.883954','10','Mary','[{"changed": {"fields": ["Student id", "Password"]}}]',9,1,2),
 (12,'2023-05-12 18:51:22.536407','1','Mary','',9,1,3),
 (13,'2023-05-12 18:58:35.746903','10','Mary','[]',9,1,2),
 (14,'2023-05-12 18:58:46.082264','10','Mary','[]',9,1,2),
 (15,'2023-05-12 19:03:42.257082','1','John','[]',11,1,2),
 (16,'2023-05-12 19:04:31.631955','1','12-May-23, 10:00 AM','[]',13,1,2),
 (17,'2023-05-12 19:04:51.201692','1','Assignment 1','[]',12,1,2),
 (18,'2023-05-13 10:13:17.651028','1','Testing','[]',19,1,2),
 (19,'2023-05-13 10:13:28.832152','2','Importance of Environment','',18,1,3),
 (20,'2023-05-15 21:47:54.604687','10','Mary','[]',9,1,2),
 (21,'2023-05-18 21:14:50.623396','1','Module Lead','[{"added": {}}]',3,1,1),
 (22,'2023-05-18 21:15:26.794435','1','Module Lead','',3,1,3),
 (23,'2023-05-18 21:21:05.533006','2','18-May-23, 09:21 PM','[{"added": {}}]',13,1,1),
 (24,'2023-05-18 21:21:53.910270','2','18-May-23, 09:21 PM','[{"changed": {"fields": ["Description"]}}]',13,1,2),
 (25,'2023-05-18 21:22:37.253532','2','18-May-23, 09:21 PM','[{"changed": {"fields": ["Description"]}}]',13,1,2),
 (26,'2023-05-25 17:11:15.054153','11','Dom Torrento','[{"added": {}}]',9,1,1),
 (27,'2023-05-25 17:12:17.509716','11','Dom Torrento','[{"changed": {"fields": ["Course"]}}]',9,1,2),
 (28,'2023-05-25 17:26:09.005128','5','Waste Management ','',18,1,3),
 (29,'2023-05-25 17:27:28.708948','2','Tom','[{"added": {}}]',4,1,1),
 (30,'2023-05-25 17:29:59.818236','2','Tom','[{"changed": {"fields": ["First name", "Last name", "Email address", "Staff status", "User permissions", "Last login"]}}]',4,1,2),
 (31,'2023-05-25 17:30:37.570720','1','John','[]',11,1,2),
 (32,'2023-05-25 17:30:44.634467','2','Tom','[]',4,1,2),
 (33,'2023-05-25 17:32:13.855211','2','Tom','[]',4,1,2),
 (35,'2023-05-25 17:34:17.143949','2','Tom','',4,1,3),
 (36,'2023-05-25 17:35:35.741436','2','Module Lead','[{"added": {}}]',3,1,1),
 (37,'2023-05-25 17:35:42.568095','2','Module Lead','[]',3,1,2),
 (38,'2023-05-25 17:36:42.027867','3','Tom','[{"added": {}}]',4,1,1),
 (39,'2023-05-25 17:37:30.919587','3','Tom','[{"changed": {"fields": ["First name", "Last name", "Email address", "Groups"]}}]',4,1,2),
 (40,'2023-05-25 17:38:00.168663','3','Tom','[{"changed": {"fields": ["Staff status"]}}]',4,1,2),
 (41,'2023-05-25 17:38:13.053409','1','Admin','[]',4,1,2),
 (42,'2023-05-25 17:39:13.110081','3','Tom','',4,1,3),
 (43,'2023-05-25 17:39:20.416674','1','Admin','[]',4,1,2),
 (44,'2023-05-26 10:44:21.685897','4','Tom','[{"added": {}}]',4,1,1),
 (45,'2023-05-26 10:45:06.466926','4','Tom','[{"changed": {"fields": ["First name", "Last name", "Email address", "Staff status", "Groups"]}}]',4,1,2),
 (46,'2023-05-26 10:45:22.750814','4','Tom','[{"changed": {"fields": ["Active"]}}]',4,1,2),
 (47,'2023-05-26 10:45:37.504087','4','Tom','[{"changed": {"fields": ["Staff status"]}}]',4,1,2),
 (48,'2023-05-30 09:53:08.130362','10','Mary','[{"changed": {"fields": ["Password"]}}]',9,1,2);
INSERT IGNORE INTO main_department (department_id,name,description) VALUES (1,'Environmental Science','This is a place where we can learn more about enviromental sustanablity');
INSERT IGNORE INTO main_student (student_id,name,email,password,role,photo,department_id) VALUES (10,'Mary','Mary@gmail.com','Mary@123','Student','profile_pics/jonas-kakaroto-mjRwhvqEC0U-unsplash.jpg',1),
 (11,'Dom Torrento','FamilyForever@example.com','Family','Student','profile_pics/Dom_screenshot.JPG',1);
INSERT IGNORE INTO main_student_course (id,student_id,course_id) VALUES (3,10,1),
 (4,11,1);
INSERT IGNORE INTO main_material (id,description,datetime,file,course_code_id) VALUES (1,'<p>Topic 1</p>','2023-05-16 13:10:57.789988','materials/__xid-49693158_1.pdf',1),
 (2,'<p>Topic 2</p>','2023-05-18 21:05:18.361285','materials/__xid-49244994_1.pptx',1);
INSERT IGNORE INTO main_faculty (faculty_id,name,email,password,role,photo,department_id) VALUES (1,'John','John@gmail.com','John','Faculty','profile_pics/Infosec_Zombie.png',1);
INSERT IGNORE INTO main_course (code,name,studentKey,facultyKey,department_id,faculty_id) VALUES (1,'Environmental sustanability fundamentals',1,1,1,1);
INSERT IGNORE INTO main_assignment (id,title,description,datetime,deadline,file,marks,course_code_id) VALUES (1,'Assignment 1','Please submit assignment in pdf format.','2023-05-12 10:01:19.583147','2023-05-19 08:00:57','assignments/Assignment_1.jpg',20,1);
INSERT IGNORE INTO main_announcement (id,datetime,description,course_code_id) VALUES (1,'2023-05-12 10:00:11.940089','<p>Please do assignment 1 which is worth <strong>15%</strong> of your grade for this course!</p>',1),
 (3,'2023-05-25 17:01:49.830303','<p><span id="isPasted" style="color: rgb(33, 37, 41); font-family: Inter, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;">Please refer to this video as a briefing for the next assignment that is worth&nbsp;</span><strong style="box-sizing: border-box; font-family: Inter, sans-serif; font-weight: bolder; color: rgb(33, 37, 41); font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;">25%</strong><span style="color: rgb(33, 37, 41); font-family: Inter, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;">&nbsp;of your grade for your module.</span>&nbsp;</p><p><span class="fr-video fr-deletable fr-fvc fr-dvb fr-draggable" contenteditable="false" draggable="true"><iframe width="640" height="360" src="https://www.youtube.com/embed/5lrn4CDQZzo?&pp=ygUpZW52aXJvbm1lbnRhbCBzdXN0YWluYWJpbGl0eSBwcmVzZW50YXRpb24%3D&wmode=opaque&rel=0" frameborder="0" allowfullscreen="" class="fr-draggable"></iframe></span><br></p>',1);
INSERT IGNORE INTO main_submission (id,file,datetime,marks,status,assignment_id,student_id) VALUES (1,'submissions/Screenshot_2023-05-01_192833.png','2023-05-15 21:43:23.771283',18,'Submitted',1,10);
INSERT IGNORE INTO attendance_attendance (id,date,status,created_at,updated_at,course_id,student_id) VALUES (1,'2023-05-15',1,'2023-05-15 21:45:30.154215','2023-05-16 13:12:01.285614',1,10),
 (2,'2023-05-16',1,'2023-05-16 13:12:07.902247','2023-05-16 13:12:21.393213',1,10);
INSERT IGNORE INTO django_content_type (id,app_label,model) VALUES (1,'admin','logentry'),
 (2,'auth','permission'),
 (3,'auth','group'),
 (4,'auth','user'),
 (5,'contenttypes','contenttype'),
 (6,'sessions','session'),
 (7,'main','course'),
 (8,'main','department'),
 (9,'main','student'),
 (10,'main','material'),
 (11,'main','faculty'),
 (12,'main','assignment'),
 (13,'main','announcement'),
 (14,'main','submission'),
 (15,'discussion','studentdiscussion'),
 (16,'discussion','facultydiscussion'),
 (17,'attendance','attendance'),
 (18,'quiz','quiz'),
 (19,'quiz','question'),
 (20,'quiz','studentanswer');
INSERT IGNORE INTO auth_permission (id,content_type_id,codename,name) VALUES (1,1,'add_logentry','Can add log entry'),
 (2,1,'change_logentry','Can change log entry'),
 (3,1,'delete_logentry','Can delete log entry'),
 (4,1,'view_logentry','Can view log entry'),
 (5,2,'add_permission','Can add permission'),
 (6,2,'change_permission','Can change permission'),
 (7,2,'delete_permission','Can delete permission'),
 (8,2,'view_permission','Can view permission'),
 (9,3,'add_group','Can add group'),
 (10,3,'change_group','Can change group'),
 (11,3,'delete_group','Can delete group'),
 (12,3,'view_group','Can view group'),
 (13,4,'add_user','Can add user'),
 (14,4,'change_user','Can change user'),
 (15,4,'delete_user','Can delete user'),
 (16,4,'view_user','Can view user'),
 (17,5,'add_contenttype','Can add content type'),
 (18,5,'change_contenttype','Can change content type'),
 (19,5,'delete_contenttype','Can delete content type'),
 (20,5,'view_contenttype','Can view content type'),
 (21,6,'add_session','Can add session'),
 (22,6,'change_session','Can change session'),
 (23,6,'delete_session','Can delete session'),
 (24,6,'view_session','Can view session'),
 (25,7,'add_course','Can add course'),
 (26,7,'change_course','Can change course'),
 (27,7,'delete_course','Can delete course'),
 (28,7,'view_course','Can view course'),
 (29,8,'add_department','Can add department'),
 (30,8,'change_department','Can change department'),
 (31,8,'delete_department','Can delete department'),
 (32,8,'view_department','Can view department'),
 (33,9,'add_student','Can add student'),
 (34,9,'change_student','Can change student'),
 (35,9,'delete_student','Can delete student'),
 (36,9,'view_student','Can view student'),
 (37,10,'add_material','Can add material'),
 (38,10,'change_material','Can change material'),
 (39,10,'delete_material','Can delete material'),
 (40,10,'view_material','Can view material'),
 (41,11,'add_faculty','Can add faculty'),
 (42,11,'change_faculty','Can change faculty'),
 (43,11,'delete_faculty','Can delete faculty'),
 (44,11,'view_faculty','Can view faculty'),
 (45,12,'add_assignment','Can add assignment'),
 (46,12,'change_assignment','Can change assignment'),
 (47,12,'delete_assignment','Can delete assignment'),
 (48,12,'view_assignment','Can view assignment'),
 (49,13,'add_announcement','Can add announcement'),
 (50,13,'change_announcement','Can change announcement'),
 (51,13,'delete_announcement','Can delete announcement'),
 (52,13,'view_announcement','Can view announcement'),
 (53,14,'add_submission','Can add submission'),
 (54,14,'change_submission','Can change submission'),
 (55,14,'delete_submission','Can delete submission'),
 (56,14,'view_submission','Can view submission'),
 (57,15,'add_studentdiscussion','Can add student discussion'),
 (58,15,'change_studentdiscussion','Can change student discussion'),
 (59,15,'delete_studentdiscussion','Can delete student discussion'),
 (60,15,'view_studentdiscussion','Can view student discussion'),
 (61,16,'add_facultydiscussion','Can add faculty discussion'),
 (62,16,'change_facultydiscussion','Can change faculty discussion'),
 (63,16,'delete_facultydiscussion','Can delete faculty discussion'),
 (64,16,'view_facultydiscussion','Can view faculty discussion'),
 (65,17,'add_attendance','Can add attendance'),
 (66,17,'change_attendance','Can change attendance'),
 (67,17,'delete_attendance','Can delete attendance'),
 (68,17,'view_attendance','Can view attendance'),
 (69,18,'add_quiz','Can add quiz'),
 (70,18,'change_quiz','Can change quiz'),
 (71,18,'delete_quiz','Can delete quiz'),
 (72,18,'view_quiz','Can view quiz'),
 (73,19,'add_question','Can add question'),
 (74,19,'change_question','Can change question'),
 (75,19,'delete_question','Can delete question'),
 (76,19,'view_question','Can view question'),
 (77,20,'add_studentanswer','Can add student answer'),
 (78,20,'change_studentanswer','Can change student answer'),
 (79,20,'delete_studentanswer','Can delete student answer'),
 (80,20,'view_studentanswer','Can view student answer');
INSERT IGNORE INTO auth_group (id,name) VALUES (2,'Module Lead');
INSERT IGNORE INTO auth_user (id,password,last_login,is_superuser,username,last_name,email,is_staff,is_active,date_joined,first_name) VALUES (1,'pbkdf2_sha256$390000$GqDksmOOUE4xukvH2EvCqO$iJc6VgapRR65UpXsnW23mu9bHyg3Pny5ttLNyffDVDw=','2023-06-15 11:58:12.683417',1,'Admin','','Admin@gmail.com',1,1,'2023-05-12 09:52:38',''),
 (4,'pbkdf2_sha256$390000$OnNaDJhkPznIbT09j4ywtQ$8v3bh/qElXe6OcHV3HIAlemoHPFUN0uH/dSXcnDib0w=',NULL,0,'Tom','Benet','Tom08Benet@example.com',0,0,'2023-05-26 10:44:21','Tom');
INSERT IGNORE INTO discussion_studentdiscussion (id,content,sent_at,course_id,sent_by_id) VALUES (1,'School was fine Mr John','2023-05-13 10:14:54.017685',1,10),
 (2,'Sorry guys, I was looking after my family!','2023-05-25 17:14:25.372265',1,11),
 (3,'<script>alert(''Your website is vulnerable'');</script>','2023-05-27 17:45:17.341853',1,11);
INSERT IGNORE INTO discussion_facultydiscussion (id,content,sent_at,course_id,sent_by_id) VALUES (1,'How was school today?','2023-05-13 10:13:53.782954',1,1);
INSERT IGNORE INTO quiz_quiz (id,title,description,start,end,created_at,updated_at,publish_status,started,course_id) VALUES (1,'Simple quiz about Environment','Environmental science pop quiz','2023-05-12 08:02:04','2023-05-19 08:02:12','2023-05-12 10:02:17.330535','2023-05-29 19:52:12.373000',1,1,1),
 (3,'Testing 2','Please finish all the questions','2023-05-15 21:38:00','2023-05-22 12:00:00','2023-05-15 21:38:59.936040','2023-05-29 19:52:12.369445',1,1,1),
 (4,'Sus','Do test ','2023-05-16 13:14:00','2023-05-23 13:14:00','2023-05-16 13:14:43.122588','2023-05-29 19:52:12.364624',1,1,1),
 (6,'Actual Test','Please complete all the 5 questions','2023-05-29 19:49:00','2023-05-30 19:50:00','2023-05-29 19:41:47.545194','2023-05-29 19:52:12.357238',1,1,1);
INSERT IGNORE INTO quiz_question (id,question,marks,option1,option2,option3,option4,answer,explanation,quiz_id) VALUES (1,'Testing',2,'This is correct','This is wrong','This is wrong','This is wrong','A','Testing',1),
 (2,'First Question',2,'Yes','No','No','No','A','A is the correct answer in this case',3),
 (3,'Second Question',2,'No','No','Yes','No','C','C is the correct answer.',3),
 (4,'Third Question',2,'No','Yes','No','No','B','B is the correct answer.',3),
 (5,'Testing',2,'Yes','No','No','No','A','A is the correct answer',4),
 (7,'This is question 1',2,'Yes','No','No','No','A','This is the correct answer',6),
 (8,'This is question 2',2,'No','No','No','Yes','D','This is the correct answer',6),
 (9,'This is question 3',2,'No','No','Yes','No','C','This is the correct answer',6),
 (10,'This is question 4',2,'Yes','No','No','No','A','This is the correct answer',6),
 (11,'This is question 5',2,'No','Yes','No','No','B','This is the correct answer.',6);
INSERT IGNORE INTO quiz_studentanswer (id,answer,marks,created_at,question_id,quiz_id,student_id) VALUES (1,'A',2,'2023-05-12 19:06:32.490709',1,1,10),
 (2,'A',2,'2023-05-15 21:42:22.963936',2,3,10),
 (3,'B',0,'2023-05-15 21:42:22.977811',3,3,10),
 (4,'B',2,'2023-05-15 21:42:22.980801',4,3,10),
 (5,'B',0,'2023-05-16 13:18:10.383798',5,4,10),
 (8,'A',2,'2023-05-29 19:49:26.714594',7,6,11),
 (9,'D',2,'2023-05-29 19:49:26.729733',8,6,11),
 (10,'C',2,'2023-05-29 19:49:26.734015',9,6,11),
 (11,'A',2,'2023-05-29 19:49:26.736422',10,6,11),
 (12,'B',2,'2023-05-29 19:49:26.740684',11,6,11),
 (13,'C',0,'2023-05-29 19:51:44.369239',7,6,10),
 (14,'C',0,'2023-05-29 19:51:44.384159',8,6,10),
 (15,'C',2,'2023-05-29 19:51:44.387159',9,6,10),
 (16,'C',0,'2023-05-29 19:51:44.390158',10,6,10),
 (17,'C',0,'2023-05-29 19:51:44.393158',11,6,10);
-- CREATE UNIQUE INDEX IF NOT EXISTS auth_group_permissions_group_id_permission_id_0cd325b0_uniq ON auth_group_permissions (
--	group_id,
--	permission_id
--  );

-- Check if the index exists
SELECT COUNT(*) INTO @index_exists FROM information_schema.statistics
WHERE table_schema = 'aspjdb'
AND table_name = 'auth_group_permissions'
AND index_name = 'auth_group_permissions_group_id_permission_id_0cd325b0_uniq';

-- Create the index only if it doesn't exist
SET @sql = IF(@index_exists > 0, '', 'CREATE UNIQUE INDEX auth_group_permissions_group_id_permission_id_0cd325b0_uniq ON auth_group_permissions (group_id, permission_id)');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Check if the index exists
SELECT COUNT(*) INTO @index_exists FROM information_schema.statistics
WHERE table_schema = 'aspjdb'
AND table_name = 'auth_group_permissions'
AND index_name = 'auth_group_permissions_group_id_b120cbf9';

-- Create the index only if it doesn't exist
SET @sql = IF(@index_exists > 0, '', 'CREATE INDEX auth_group_permissions_group_id_b120cbf9 ON auth_group_permissions (group_id)');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Check if the index exists
SELECT COUNT(*) INTO @index_exists FROM information_schema.statistics
WHERE table_schema = 'aspjdb'
AND table_name = 'auth_group_permissions'
AND index_name = 'auth_group_permissions_permission_id_84c5c92e';

-- Create the index only if it doesn't exist
SET @sql = IF(@index_exists > 0, '', 'CREATE INDEX auth_group_permissions_permission_id_84c5c92e ON auth_group_permissions (permission_id)');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Check if the index exists
SELECT COUNT(*) INTO @index_exists FROM information_schema.statistics
WHERE table_schema = 'aspjdb'
AND table_name = 'auth_user_groups'
AND index_name = 'auth_user_groups_user_id_group_id_94350c0c_uniq';

-- Create the index only if it doesn't exist
SET @sql = IF(@index_exists > 0, '', 'CREATE UNIQUE INDEX auth_user_groups_user_id_group_id_94350c0c_uniq ON auth_user_groups (user_id, group_id)');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Check if the index auth_user_groups_user_id_6a12ed8b exists
SELECT COUNT(*) INTO @index_exists FROM information_schema.statistics
WHERE table_schema = 'aspjdb'
AND table_name = 'auth_user_groups'
AND index_name = 'auth_user_groups_user_id_6a12ed8b';

-- Create the index auth_user_groups_user_id_6a12ed8b only if it doesn't exist
SET @sql = IF(@index_exists > 0, '', 'CREATE INDEX auth_user_groups_user_id_6a12ed8b ON auth_user_groups (user_id)');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Check if the index auth_user_groups_group_id_97559544 exists
SELECT COUNT(*) INTO @index_exists FROM information_schema.statistics
WHERE table_schema = 'aspjdb'
AND table_name = 'auth_user_groups'
AND index_name = 'auth_user_groups_group_id_97559544';

-- Create the index auth_user_groups_group_id_97559544 only if it doesn't exist
SET @sql = IF(@index_exists > 0, '', 'CREATE INDEX auth_user_groups_group_id_97559544 ON auth_user_groups (group_id)');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Check if the index auth_user_user_permissions_user_id_permission_id_14a6b632_uniq exists
SELECT COUNT(*) INTO @index_exists FROM information_schema.statistics
WHERE table_schema = 'aspjdb'
AND table_name = 'auth_user_user_permissions'
AND index_name = 'auth_user_user_permissions_user_id_permission_id_14a6b632_uniq';

-- Create the index auth_user_user_permissions_user_id_permission_id_14a6b632_uniq only if it doesn't exist
SET @sql = IF(@index_exists > 0, '', 'CREATE UNIQUE INDEX auth_user_user_permissions_user_id_permission_id_14a6b632_uniq ON auth_user_user_permissions (user_id, permission_id)');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Check if the index auth_user_user_permissions_user_id_a95ead1b exists
SELECT COUNT(*) INTO @index_exists FROM information_schema.statistics
WHERE table_schema = 'aspjdb'
AND table_name = 'auth_user_user_permissions'
AND index_name = 'auth_user_user_permissions_user_id_a95ead1b';

-- Create the index auth_user_user_permissions_user_id_a95ead1b only if it doesn't exist
SET @sql = IF(@index_exists > 0, '', 'CREATE INDEX auth_user_user_permissions_user_id_a95ead1b ON auth_user_user_permissions (user_id)');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Check if the index auth_user_user_permissions_permission_id_1fbb5f2c exists
SELECT COUNT(*) INTO @index_exists FROM information_schema.statistics
WHERE table_schema = 'aspjdb'
AND table_name = 'auth_user_user_permissions'
AND index_name = 'auth_user_user_permissions_permission_id_1fbb5f2c';

-- Create the index auth_user_user_permissions_permission_id_1fbb5f2c only if it doesn't exist
SET @sql = IF(@index_exists > 0, '', 'CREATE INDEX auth_user_user_permissions_permission_id_1fbb5f2c ON auth_user_user_permissions (permission_id)');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Check if the index django_admin_log_content_type_id_c4bce8eb exists
SELECT COUNT(*) INTO @index_exists FROM information_schema.statistics
WHERE table_schema = 'aspjdb'
AND table_name = 'django_admin_log'
AND index_name = 'django_admin_log_content_type_id_c4bce8eb';

-- Create the index django_admin_log_content_type_id_c4bce8eb only if it doesn't exist
SET @sql = IF(@index_exists > 0, '', 'CREATE INDEX django_admin_log_content_type_id_c4bce8eb ON django_admin_log (content_type_id)');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Check if the index django_admin_log_user_id_c564eba6 exists
SELECT COUNT(*) INTO @index_exists FROM information_schema.statistics
WHERE table_schema = 'aspjdb'
AND table_name = 'django_admin_log'
AND index_name = 'django_admin_log_user_id_c564eba6';

-- Create the index django_admin_log_user_id_c564eba6 only if it doesn't exist
SET @sql = IF(@index_exists > 0, '', 'CREATE INDEX django_admin_log_user_id_c564eba6 ON django_admin_log (user_id)');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Check if the index main_student_department_id_94f07529 exists
SELECT COUNT(*) INTO @index_exists FROM information_schema.statistics
WHERE table_schema = 'aspjdb'
AND table_name = 'main_student'
AND index_name = 'main_student_department_id_94f07529';

-- Create the index main_student_department_id_94f07529 only if it doesn't exist
SET @sql = IF(@index_exists > 0, '', 'CREATE INDEX main_student_department_id_94f07529 ON main_student (department_id)');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Check if the index main_student_course_student_id_course_id_8daf50dc_uniq exists
SELECT COUNT(*) INTO @index_exists FROM information_schema.statistics
WHERE table_schema = 'aspjdb'
AND table_name = 'main_student_course'
AND index_name = 'main_student_course_student_id_course_id_8daf50dc_uniq';

-- Create the index main_student_course_student_id_course_id_8daf50dc_uniq only if it doesn't exist
SET @sql = IF(@index_exists > 0, '', 'CREATE UNIQUE INDEX main_student_course_student_id_course_id_8daf50dc_uniq ON main_student_course (student_id, course_id)');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Check if the index main_student_course_student_id_9da32d28 exists
SELECT COUNT(*) INTO @index_exists FROM information_schema.statistics
WHERE table_schema = 'aspjdb'
AND table_name = 'main_student_course'
AND index_name = 'main_student_course_student_id_9da32d28';

-- Create the index main_student_course_student_id_9da32d28 only if it doesn't exist
SET @sql = IF(@index_exists > 0, '', 'CREATE INDEX main_student_course_student_id_9da32d28 ON main_student_course (student_id)');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Check if the index main_student_course_course_id_872fc03c exists
SELECT COUNT(*) INTO @index_exists FROM information_schema.statistics
WHERE table_schema = 'aspjdb'
AND table_name = 'main_student_course'
AND index_name = 'main_student_course_course_id_872fc03c';

-- Create the index main_student_course_course_id_872fc03c only if it doesn't exist
SET @sql = IF(@index_exists > 0, '', 'CREATE INDEX main_student_course_course_id_872fc03c ON main_student_course (course_id)');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Check if the index main_material_course_code_id_2aed10c8 exists
SELECT COUNT(*) INTO @index_exists FROM information_schema.statistics
WHERE table_schema = 'aspjdb'
AND table_name = 'main_material'
AND index_name = 'main_material_course_code_id_2aed10c8';

-- Create the index main_material_course_code_id_2aed10c8 only if it doesn't exist
SET @sql = IF(@index_exists > 0, '', 'CREATE INDEX main_material_course_code_id_2aed10c8 ON main_material (course_code_id)');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Check if the index main_faculty_department_id_123b9ec7 exists
SELECT COUNT(*) INTO @index_exists FROM information_schema.statistics
WHERE table_schema = 'aspjdb'
AND table_name = 'main_faculty'
AND index_name = 'main_faculty_department_id_123b9ec7';

-- Create the index main_faculty_department_id_123b9ec7 only if it doesn't exist
SET @sql = IF(@index_exists > 0, '', 'CREATE INDEX main_faculty_department_id_123b9ec7 ON main_faculty (department_id)');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Check if the index main_course_department_id_bd662e7c exists
SELECT COUNT(*) INTO @index_exists FROM information_schema.statistics
WHERE table_schema = 'aspjdb'
AND table_name = 'main_course'
AND index_name = 'main_course_department_id_bd662e7c';

-- Create the index main_course_department_id_bd662e7c only if it doesn't exist
SET @sql = IF(@index_exists > 0, '', 'CREATE INDEX main_course_department_id_bd662e7c ON main_course (department_id)');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Check if the index main_course_faculty_id_86dcf2b3 exists
SELECT COUNT(*) INTO @index_exists FROM information_schema.statistics
WHERE table_schema = 'aspjdb'
AND table_name = 'main_course'
AND index_name = 'main_course_faculty_id_86dcf2b3';

-- Create the index main_course_faculty_id_86dcf2b3 only if it doesn't exist
SET @sql = IF(@index_exists > 0, '', 'CREATE INDEX main_course_faculty_id_86dcf2b3 ON main_course (faculty_id)');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Check if the index main_course_code_department_id_name_099e0bb4_uniq exists
SELECT COUNT(*) INTO @index_exists FROM information_schema.statistics
WHERE table_schema = 'aspjdb'
AND table_name = 'main_course'
AND index_name = 'main_course_code_department_id_name_099e0bb4_uniq';

-- Create the index main_course_code_department_id_name_099e0bb4_uniq only if it doesn't exist
SET @sql = IF(@index_exists > 0, '', 'CREATE UNIQUE INDEX main_course_code_department_id_name_099e0bb4_uniq ON main_course (code, department_id, name)');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Check if the index main_assignment_course_code_id_3ee9c816 exists
SELECT COUNT(*) INTO @index_exists FROM information_schema.statistics
WHERE table_schema = 'aspjdb'
AND table_name = 'main_assignment'
AND index_name = 'main_assignment_course_code_id_3ee9c816';

-- Create the index main_assignment_course_code_id_3ee9c816 only if it doesn't exist
SET @sql = IF(@index_exists > 0, '', 'CREATE INDEX main_assignment_course_code_id_3ee9c816 ON main_assignment (course_code_id)');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Check if the index main_announcement_course_code_id_fef48428 exists
SELECT COUNT(*) INTO @index_exists FROM information_schema.statistics
WHERE table_schema = 'aspjdb'
AND table_name = 'main_announcement'
AND index_name = 'main_announcement_course_code_id_fef48428';

-- Create the index main_announcement_course_code_id_fef48428 only if it doesn't exist
SET @sql = IF(@index_exists > 0, '', 'CREATE INDEX main_announcement_course_code_id_fef48428 ON main_announcement (course_code_id)');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Check if the index main_submission_assignment_id_student_id_b41b7195_uniq exists
SELECT COUNT(*) INTO @index_exists FROM information_schema.statistics
WHERE table_schema = 'aspjdb'
AND table_name = 'main_submission'
AND index_name = 'main_submission_assignment_id_student_id_b41b7195_uniq';

-- Create the index main_submission_assignment_id_student_id_b41b7195_uniq only if it doesn't exist
SET @sql = IF(@index_exists > 0, '', 'CREATE UNIQUE INDEX main_submission_assignment_id_student_id_b41b7195_uniq ON main_submission (assignment_id, student_id)');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Check if the index main_submission_assignment_id_ddd2348f exists
SELECT COUNT(*) INTO @index_exists FROM information_schema.statistics
WHERE table_schema = 'aspjdb'
AND table_name = 'main_submission'
AND index_name = 'main_submission_assignment_id_ddd2348f';

-- Create the index main_submission_assignment_id_ddd2348f only if it doesn't exist
SET @sql = IF(@index_exists > 0, '', 'CREATE INDEX main_submission_assignment_id_ddd2348f ON main_submission (assignment_id)');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Check if the index main_submission_student_id_49dd63c7 exists
SELECT COUNT(*) INTO @index_exists FROM information_schema.statistics
WHERE table_schema = 'aspjdb'
AND table_name = 'main_submission'
AND index_name = 'main_submission_student_id_49dd63c7';

-- Create the index main_submission_student_id_49dd63c7 only if it doesn't exist
SET @sql = IF(@index_exists > 0, '', 'CREATE INDEX main_submission_student_id_49dd63c7 ON main_submission (student_id)');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Check if the index attendance_attendance_course_id_1d4d6a83 exists
SELECT COUNT(*) INTO @index_exists FROM information_schema.statistics
WHERE table_schema = 'aspjdb'
AND table_name = 'attendance_attendance'
AND index_name = 'attendance_attendance_course_id_1d4d6a83';

-- Create the index attendance_attendance_course_id_1d4d6a83 only if it doesn't exist
SET @sql = IF(@index_exists > 0, '', 'CREATE INDEX attendance_attendance_course_id_1d4d6a83 ON attendance_attendance (course_id)');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Check if the index attendance_attendance_student_id_94863613 exists
SELECT COUNT(*) INTO @index_exists FROM information_schema.statistics
WHERE table_schema = 'aspjdb'
AND table_name = 'attendance_attendance'
AND index_name = 'attendance_attendance_student_id_94863613';

-- Create the index attendance_attendance_student_id_94863613 only if it doesn't exist
SET @sql = IF(@index_exists > 0, '', 'CREATE INDEX attendance_attendance_student_id_94863613 ON attendance_attendance (student_id)');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Check if the index django_content_type_app_label_model_76bd3d3b_uniq exists
SELECT COUNT(*) INTO @index_exists FROM information_schema.statistics
WHERE table_schema = 'aspjdb'
AND table_name = 'django_content_type'
AND index_name = 'django_content_type_app_label_model_76bd3d3b_uniq';

-- Create the index django_content_type_app_label_model_76bd3d3b_uniq only if it doesn't exist
SET @sql = IF(@index_exists > 0, '', 'CREATE UNIQUE INDEX django_content_type_app_label_model_76bd3d3b_uniq ON django_content_type (app_label, model)');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Check if the index auth_permission_content_type_id_codename_01ab375a_uniq exists
SELECT COUNT(*) INTO @index_exists FROM information_schema.statistics
WHERE table_schema = 'aspjdb'
AND table_name = 'auth_permission'
AND index_name = 'auth_permission_content_type_id_codename_01ab375a_uniq';

-- Create the index auth_permission_content_type_id_codename_01ab375a_uniq only if it doesn't exist
SET @sql = IF(@index_exists > 0, '', 'CREATE UNIQUE INDEX auth_permission_content_type_id_codename_01ab375a_uniq ON auth_permission (content_type_id, codename)');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Check if the index auth_permission_content_type_id_2f476e4b exists
SELECT COUNT(*) INTO @index_exists FROM information_schema.statistics
WHERE table_schema = 'aspjdb'
AND table_name = 'auth_permission'
AND index_name = 'auth_permission_content_type_id_2f476e4b';

-- Create the index auth_permission_content_type_id_2f476e4b only if it doesn't exist
SET @sql = IF(@index_exists > 0, '', 'CREATE INDEX auth_permission_content_type_id_2f476e4b ON auth_permission (content_type_id)');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Check if the index discussion_studentdiscussion_course_id_ae59979a exists
SELECT COUNT(*) INTO @index_exists FROM information_schema.statistics
WHERE table_schema = 'aspjdb'
AND table_name = 'discussion_studentdiscussion'
AND index_name = 'discussion_studentdiscussion_course_id_ae59979a';

-- Create the index discussion_studentdiscussion_course_id_ae59979a only if it doesn't exist
SET @sql = IF(@index_exists > 0, '', 'CREATE INDEX discussion_studentdiscussion_course_id_ae59979a ON discussion_studentdiscussion (course_id)');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Check if the index discussion_studentdiscussion_sent_by_id_536a7eae exists
SELECT COUNT(*) INTO @index_exists FROM information_schema.statistics
WHERE table_schema = 'aspjdb'
AND table_name = 'discussion_studentdiscussion'
AND index_name = 'discussion_studentdiscussion_sent_by_id_536a7eae';

-- Create the index discussion_studentdiscussion_sent_by_id_536a7eae only if it doesn't exist
SET @sql = IF(@index_exists > 0, '', 'CREATE INDEX discussion_studentdiscussion_sent_by_id_536a7eae ON discussion_studentdiscussion (sent_by_id)');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Check if the index discussion_facultydiscussion_course_id_b6401a93 exists
SELECT COUNT(*) INTO @index_exists FROM information_schema.statistics
WHERE table_schema = 'aspjdb'
AND table_name = 'discussion_facultydiscussion'
AND index_name = 'discussion_facultydiscussion_course_id_b6401a93';

-- Create the index discussion_facultydiscussion_course_id_b6401a93 only if it doesn't exist
SET @sql = IF(@index_exists > 0, '', 'CREATE INDEX discussion_facultydiscussion_course_id_b6401a93 ON discussion_facultydiscussion (course_id)');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Check if the index discussion_facultydiscussion_sent_by_id_b65af0e9 exists
SELECT COUNT(*) INTO @index_exists FROM information_schema.statistics
WHERE table_schema = 'aspjdb'
AND table_name = 'discussion_facultydiscussion'
AND index_name = 'discussion_facultydiscussion_sent_by_id_b65af0e9';

-- Create the index discussion_facultydiscussion_sent_by_id_b65af0e9 only if it doesn't exist
SET @sql = IF(@index_exists > 0, '', 'CREATE INDEX discussion_facultydiscussion_sent_by_id_b65af0e9 ON discussion_facultydiscussion (sent_by_id)');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Check if the index quiz_quiz_course_id_dd25aae3 exists
SELECT COUNT(*) INTO @index_exists FROM information_schema.statistics
WHERE table_schema = 'aspjdb'
AND table_name = 'quiz_quiz'
AND index_name = 'quiz_quiz_course_id_dd25aae3';

-- Create the index quiz_quiz_course_id_dd25aae3 only if it doesn't exist
SET @sql = IF(@index_exists > 0, '', 'CREATE INDEX quiz_quiz_course_id_dd25aae3 ON quiz_quiz (course_id)');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Check if the index quiz_question_quiz_id_b7429966 exists
SELECT COUNT(*) INTO @index_exists FROM information_schema.statistics
WHERE table_schema = 'aspjdb'
AND table_name = 'quiz_question'
AND index_name = 'quiz_question_quiz_id_b7429966';

-- Create the index quiz_question_quiz_id_b7429966 only if it doesn't exist
SET @sql = IF(@index_exists > 0, '', 'CREATE INDEX quiz_question_quiz_id_b7429966 ON quiz_question (quiz_id)');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Check if the index quiz_studentanswer_student_id_quiz_id_question_id_a1d14b46_uniq exists
SELECT COUNT(*) INTO @index_exists FROM information_schema.statistics
WHERE table_schema = 'aspjdb'
AND table_name = 'quiz_studentanswer'
AND index_name = 'quiz_studentanswer_student_id_quiz_id_question_id_a1d14b46_uniq';

-- Create the index quiz_studentanswer_student_id_quiz_id_question_id_a1d14b46_uniq only if it doesn't exist
SET @sql = IF(@index_exists > 0, '', 'CREATE UNIQUE INDEX quiz_studentanswer_student_id_quiz_id_question_id_a1d14b46_uniq ON quiz_studentanswer (student_id, quiz_id, question_id)');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Check if the index quiz_studentanswer_question_id_aeb56a58 exists
SELECT COUNT(*) INTO @index_exists FROM information_schema.statistics
WHERE table_schema = 'aspjdb'
AND table_name = 'quiz_studentanswer'
AND index_name = 'quiz_studentanswer_question_id_aeb56a58';

-- Create the index quiz_studentanswer_question_id_aeb56a58 only if it doesn't exist
SET @sql = IF(@index_exists > 0, '', 'CREATE INDEX quiz_studentanswer_question_id_aeb56a58 ON quiz_studentanswer (question_id)');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Check if the index quiz_studentanswer_quiz_id_474c5e0c exists
SELECT COUNT(*) INTO @index_exists FROM information_schema.statistics
WHERE table_schema = 'aspjdb'
AND table_name = 'quiz_studentanswer'
AND index_name = 'quiz_studentanswer_quiz_id_474c5e0c';

-- Create the index quiz_studentanswer_quiz_id_474c5e0c only if it doesn't exist
SET @sql = IF(@index_exists > 0, '', 'CREATE INDEX quiz_studentanswer_quiz_id_474c5e0c ON quiz_studentanswer (quiz_id)');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Check if the index quiz_studentanswer_student_id_24a540d2 exists
SELECT COUNT(*) INTO @index_exists FROM information_schema.statistics
WHERE table_schema = 'aspjdb'
AND table_name = 'quiz_studentanswer'
AND index_name = 'quiz_studentanswer_student_id_24a540d2';

-- Create the index quiz_studentanswer_student_id_24a540d2 only if it doesn't exist
SET @sql = IF(@index_exists > 0, '', 'CREATE INDEX quiz_studentanswer_student_id_24a540d2 ON quiz_studentanswer (student_id)');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Check if the index django_session_expire_date_a5c62663 exists
SELECT COUNT(*) INTO @index_exists FROM information_schema.statistics
WHERE table_schema = 'aspjdb'
AND table_name = 'django_session'
AND index_name = 'django_session_expire_date_a5c62663';

-- Create the index django_session_expire_date_a5c62663 only if it doesn't exist
SET @sql = IF(@index_exists > 0, '', 'CREATE INDEX django_session_expire_date_a5c62663 ON django_session (expire_date)');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;


-- Enable foreign key checks
SET FOREIGN_KEY_CHECKS = 1;

COMMIT;
