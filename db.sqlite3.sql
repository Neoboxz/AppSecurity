BEGIN TRANSACTION;
CREATE TABLE IF NOT EXISTS "django_migrations" (
	"id"	integer NOT NULL,
	"app"	varchar(255) NOT NULL,
	"name"	varchar(255) NOT NULL,
	"applied"	datetime NOT NULL,
	PRIMARY KEY("id" AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS "auth_group_permissions" (
	"id"	integer NOT NULL,
	"group_id"	integer NOT NULL,
	"permission_id"	integer NOT NULL,
	PRIMARY KEY("id" AUTOINCREMENT),
	FOREIGN KEY("permission_id") REFERENCES "auth_permission"("id") DEFERRABLE INITIALLY DEFERRED,
	FOREIGN KEY("group_id") REFERENCES "auth_group"("id") DEFERRABLE INITIALLY DEFERRED
);
CREATE TABLE IF NOT EXISTS "auth_user_groups" (
	"id"	integer NOT NULL,
	"user_id"	integer NOT NULL,
	"group_id"	integer NOT NULL,
	PRIMARY KEY("id" AUTOINCREMENT),
	FOREIGN KEY("user_id") REFERENCES "auth_user"("id") DEFERRABLE INITIALLY DEFERRED,
	FOREIGN KEY("group_id") REFERENCES "auth_group"("id") DEFERRABLE INITIALLY DEFERRED
);
CREATE TABLE IF NOT EXISTS "auth_user_user_permissions" (
	"id"	integer NOT NULL,
	"user_id"	integer NOT NULL,
	"permission_id"	integer NOT NULL,
	PRIMARY KEY("id" AUTOINCREMENT),
	FOREIGN KEY("user_id") REFERENCES "auth_user"("id") DEFERRABLE INITIALLY DEFERRED,
	FOREIGN KEY("permission_id") REFERENCES "auth_permission"("id") DEFERRABLE INITIALLY DEFERRED
);
CREATE TABLE IF NOT EXISTS "django_admin_log" (
	"id"	integer NOT NULL,
	"action_time"	datetime NOT NULL,
	"object_id"	text,
	"object_repr"	varchar(200) NOT NULL,
	"change_message"	text NOT NULL,
	"content_type_id"	integer,
	"user_id"	integer NOT NULL,
	"action_flag"	smallint unsigned NOT NULL CHECK("action_flag" >= 0),
	PRIMARY KEY("id" AUTOINCREMENT),
	FOREIGN KEY("user_id") REFERENCES "auth_user"("id") DEFERRABLE INITIALLY DEFERRED,
	FOREIGN KEY("content_type_id") REFERENCES "django_content_type"("id") DEFERRABLE INITIALLY DEFERRED
);
CREATE TABLE IF NOT EXISTS "main_department" (
	"department_id"	integer NOT NULL,
	"name"	varchar(100) NOT NULL,
	"description"	text,
	PRIMARY KEY("department_id")
);
CREATE TABLE IF NOT EXISTS "main_student" (
	"student_id"	integer NOT NULL,
	"name"	varchar(100) NOT NULL,
	"email"	varchar(100),
	"password"	varchar(255) NOT NULL,
	"role"	varchar(100) NOT NULL,
	"photo"	varchar(100) NOT NULL,
	"department_id"	integer NOT NULL,
	PRIMARY KEY("student_id"),
	FOREIGN KEY("department_id") REFERENCES "main_department"("department_id") DEFERRABLE INITIALLY DEFERRED
);
CREATE TABLE IF NOT EXISTS "main_student_course" (
	"id"	integer NOT NULL,
	"student_id"	integer NOT NULL,
	"course_id"	integer NOT NULL,
	PRIMARY KEY("id" AUTOINCREMENT),
	FOREIGN KEY("student_id") REFERENCES "main_student"("student_id") DEFERRABLE INITIALLY DEFERRED,
	FOREIGN KEY("course_id") REFERENCES "main_course"("code") DEFERRABLE INITIALLY DEFERRED
);
CREATE TABLE IF NOT EXISTS "main_material" (
	"id"	integer NOT NULL,
	"description"	text NOT NULL,
	"datetime"	datetime NOT NULL,
	"file"	varchar(100),
	"course_code_id"	integer NOT NULL,
	PRIMARY KEY("id" AUTOINCREMENT),
	FOREIGN KEY("course_code_id") REFERENCES "main_course"("code") DEFERRABLE INITIALLY DEFERRED
);
CREATE TABLE IF NOT EXISTS "main_faculty" (
	"faculty_id"	integer NOT NULL,
	"name"	varchar(100) NOT NULL,
	"email"	varchar(100),
	"password"	varchar(255) NOT NULL,
	"role"	varchar(100) NOT NULL,
	"photo"	varchar(100) NOT NULL,
	"department_id"	integer NOT NULL,
	PRIMARY KEY("faculty_id"),
	FOREIGN KEY("department_id") REFERENCES "main_department"("department_id") DEFERRABLE INITIALLY DEFERRED
);
CREATE TABLE IF NOT EXISTS "main_course" (
	"code"	integer NOT NULL,
	"name"	varchar(255) NOT NULL UNIQUE,
	"studentKey"	integer NOT NULL UNIQUE,
	"facultyKey"	integer NOT NULL UNIQUE,
	"department_id"	integer NOT NULL,
	"faculty_id"	integer,
	PRIMARY KEY("code"),
	FOREIGN KEY("department_id") REFERENCES "main_department"("department_id") DEFERRABLE INITIALLY DEFERRED,
	FOREIGN KEY("faculty_id") REFERENCES "main_faculty"("faculty_id") DEFERRABLE INITIALLY DEFERRED
);
CREATE TABLE IF NOT EXISTS "main_assignment" (
	"id"	integer NOT NULL,
	"title"	varchar(255) NOT NULL,
	"description"	text NOT NULL,
	"datetime"	datetime NOT NULL,
	"deadline"	datetime NOT NULL,
	"file"	varchar(100),
	"marks"	decimal NOT NULL,
	"course_code_id"	integer NOT NULL,
	PRIMARY KEY("id" AUTOINCREMENT),
	FOREIGN KEY("course_code_id") REFERENCES "main_course"("code") DEFERRABLE INITIALLY DEFERRED
);
CREATE TABLE IF NOT EXISTS "main_announcement" (
	"id"	integer NOT NULL,
	"datetime"	datetime NOT NULL,
	"description"	text NOT NULL,
	"course_code_id"	integer NOT NULL,
	PRIMARY KEY("id" AUTOINCREMENT),
	FOREIGN KEY("course_code_id") REFERENCES "main_course"("code") DEFERRABLE INITIALLY DEFERRED
);
CREATE TABLE IF NOT EXISTS "main_submission" (
	"id"	integer NOT NULL,
	"file"	varchar(100),
	"datetime"	datetime NOT NULL,
	"marks"	decimal,
	"status"	varchar(100),
	"assignment_id"	bigint NOT NULL,
	"student_id"	integer NOT NULL,
	PRIMARY KEY("id" AUTOINCREMENT),
	FOREIGN KEY("student_id") REFERENCES "main_student"("student_id") DEFERRABLE INITIALLY DEFERRED,
	FOREIGN KEY("assignment_id") REFERENCES "main_assignment"("id") DEFERRABLE INITIALLY DEFERRED
);
CREATE TABLE IF NOT EXISTS "attendance_attendance" (
	"id"	integer NOT NULL,
	"date"	date NOT NULL,
	"status"	bool NOT NULL,
	"created_at"	datetime NOT NULL,
	"updated_at"	datetime NOT NULL,
	"course_id"	integer NOT NULL,
	"student_id"	integer NOT NULL,
	PRIMARY KEY("id" AUTOINCREMENT),
	FOREIGN KEY("student_id") REFERENCES "main_student"("student_id") DEFERRABLE INITIALLY DEFERRED,
	FOREIGN KEY("course_id") REFERENCES "main_course"("code") DEFERRABLE INITIALLY DEFERRED
);
CREATE TABLE IF NOT EXISTS "django_content_type" (
	"id"	integer NOT NULL,
	"app_label"	varchar(100) NOT NULL,
	"model"	varchar(100) NOT NULL,
	PRIMARY KEY("id" AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS "auth_permission" (
	"id"	integer NOT NULL,
	"content_type_id"	integer NOT NULL,
	"codename"	varchar(100) NOT NULL,
	"name"	varchar(255) NOT NULL,
	PRIMARY KEY("id" AUTOINCREMENT),
	FOREIGN KEY("content_type_id") REFERENCES "django_content_type"("id") DEFERRABLE INITIALLY DEFERRED
);
CREATE TABLE IF NOT EXISTS "auth_group" (
	"id"	integer NOT NULL,
	"name"	varchar(150) NOT NULL UNIQUE,
	PRIMARY KEY("id" AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS "auth_user" (
	"id"	integer NOT NULL,
	"password"	varchar(128) NOT NULL,
	"last_login"	datetime,
	"is_superuser"	bool NOT NULL,
	"username"	varchar(150) NOT NULL UNIQUE,
	"last_name"	varchar(150) NOT NULL,
	"email"	varchar(254) NOT NULL,
	"is_staff"	bool NOT NULL,
	"is_active"	bool NOT NULL,
	"date_joined"	datetime NOT NULL,
	"first_name"	varchar(150) NOT NULL,
	PRIMARY KEY("id" AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS "discussion_studentdiscussion" (
	"id"	integer NOT NULL,
	"content"	text NOT NULL,
	"sent_at"	datetime NOT NULL,
	"course_id"	integer NOT NULL,
	"sent_by_id"	integer NOT NULL,
	PRIMARY KEY("id" AUTOINCREMENT),
	FOREIGN KEY("course_id") REFERENCES "main_course"("code") DEFERRABLE INITIALLY DEFERRED,
	FOREIGN KEY("sent_by_id") REFERENCES "main_student"("student_id") DEFERRABLE INITIALLY DEFERRED
);
CREATE TABLE IF NOT EXISTS "discussion_facultydiscussion" (
	"id"	integer NOT NULL,
	"content"	text NOT NULL,
	"sent_at"	datetime NOT NULL,
	"course_id"	integer NOT NULL,
	"sent_by_id"	integer NOT NULL,
	PRIMARY KEY("id" AUTOINCREMENT),
	FOREIGN KEY("sent_by_id") REFERENCES "main_faculty"("faculty_id") DEFERRABLE INITIALLY DEFERRED,
	FOREIGN KEY("course_id") REFERENCES "main_course"("code") DEFERRABLE INITIALLY DEFERRED
);
CREATE TABLE IF NOT EXISTS "quiz_quiz" (
	"id"	integer NOT NULL,
	"title"	varchar(100) NOT NULL,
	"description"	text,
	"start"	datetime NOT NULL,
	"end"	datetime NOT NULL,
	"created_at"	datetime NOT NULL,
	"updated_at"	datetime NOT NULL,
	"publish_status"	bool,
	"started"	bool,
	"course_id"	integer NOT NULL,
	PRIMARY KEY("id" AUTOINCREMENT),
	FOREIGN KEY("course_id") REFERENCES "main_course"("code") DEFERRABLE INITIALLY DEFERRED
);
CREATE TABLE IF NOT EXISTS "quiz_question" (
	"id"	integer NOT NULL,
	"question"	text NOT NULL,
	"marks"	integer NOT NULL,
	"option1"	text NOT NULL,
	"option2"	text NOT NULL,
	"option3"	text NOT NULL,
	"option4"	text NOT NULL,
	"answer"	varchar(1) NOT NULL,
	"explanation"	text,
	"quiz_id"	bigint NOT NULL,
	PRIMARY KEY("id" AUTOINCREMENT),
	FOREIGN KEY("quiz_id") REFERENCES "quiz_quiz"("id") DEFERRABLE INITIALLY DEFERRED
);
CREATE TABLE IF NOT EXISTS "quiz_studentanswer" (
	"id"	integer NOT NULL,
	"answer"	varchar(1),
	"marks"	integer,
	"created_at"	datetime,
	"question_id"	bigint NOT NULL,
	"quiz_id"	bigint NOT NULL,
	"student_id"	integer NOT NULL,
	FOREIGN KEY("quiz_id") REFERENCES "quiz_quiz"("id") DEFERRABLE INITIALLY DEFERRED,
	FOREIGN KEY("student_id") REFERENCES "main_student"("student_id") DEFERRABLE INITIALLY DEFERRED,
	PRIMARY KEY("id" AUTOINCREMENT),
	FOREIGN KEY("question_id") REFERENCES "quiz_question"("id") DEFERRABLE INITIALLY DEFERRED
);
CREATE TABLE IF NOT EXISTS "django_session" (
	"session_key"	varchar(40) NOT NULL,
	"session_data"	text NOT NULL,
	"expire_date"	datetime NOT NULL,
	PRIMARY KEY("session_key")
);
INSERT INTO "django_migrations" VALUES (1,'contenttypes','0001_initial','2023-05-12 09:51:45.956207');
INSERT INTO "django_migrations" VALUES (2,'auth','0001_initial','2023-05-12 09:51:45.972227');
INSERT INTO "django_migrations" VALUES (3,'admin','0001_initial','2023-05-12 09:51:45.988279');
INSERT INTO "django_migrations" VALUES (4,'admin','0002_logentry_remove_auto_add','2023-05-12 09:51:45.996276');
INSERT INTO "django_migrations" VALUES (5,'admin','0003_logentry_add_action_flag_choices','2023-05-12 09:51:46.012563');
INSERT INTO "django_migrations" VALUES (6,'main','0001_initial','2023-05-12 09:51:46.070715');
INSERT INTO "django_migrations" VALUES (7,'attendance','0001_initial','2023-05-12 09:51:46.085521');
INSERT INTO "django_migrations" VALUES (8,'contenttypes','0002_remove_content_type_name','2023-05-12 09:51:46.128477');
INSERT INTO "django_migrations" VALUES (9,'auth','0002_alter_permission_name_max_length','2023-05-12 09:51:46.142684');
INSERT INTO "django_migrations" VALUES (10,'auth','0003_alter_user_email_max_length','2023-05-12 09:51:46.150698');
INSERT INTO "django_migrations" VALUES (11,'auth','0004_alter_user_username_opts','2023-05-12 09:51:46.166871');
INSERT INTO "django_migrations" VALUES (12,'auth','0005_alter_user_last_login_null','2023-05-12 09:51:46.175038');
INSERT INTO "django_migrations" VALUES (13,'auth','0006_require_contenttypes_0002','2023-05-12 09:51:46.183041');
INSERT INTO "django_migrations" VALUES (14,'auth','0007_alter_validators_add_error_messages','2023-05-12 09:51:46.191123');
INSERT INTO "django_migrations" VALUES (15,'auth','0008_alter_user_username_max_length','2023-05-12 09:51:46.207036');
INSERT INTO "django_migrations" VALUES (16,'auth','0009_alter_user_last_name_max_length','2023-05-12 09:51:46.215032');
INSERT INTO "django_migrations" VALUES (17,'auth','0010_alter_group_name_max_length','2023-05-12 09:51:46.231023');
INSERT INTO "django_migrations" VALUES (18,'auth','0011_update_proxy_permissions','2023-05-12 09:51:46.239102');
INSERT INTO "django_migrations" VALUES (19,'auth','0012_alter_user_first_name_max_length','2023-05-12 09:51:46.247097');
INSERT INTO "django_migrations" VALUES (20,'discussion','0001_initial','2023-05-12 09:51:46.270618');
INSERT INTO "django_migrations" VALUES (21,'quiz','0001_initial','2023-05-12 09:51:46.302970');
INSERT INTO "django_migrations" VALUES (22,'sessions','0001_initial','2023-05-12 09:51:46.311071');
INSERT INTO "auth_group_permissions" VALUES (4,2,5);
INSERT INTO "auth_group_permissions" VALUES (5,2,6);
INSERT INTO "auth_group_permissions" VALUES (6,2,7);
INSERT INTO "auth_group_permissions" VALUES (7,2,8);
INSERT INTO "auth_group_permissions" VALUES (8,2,9);
INSERT INTO "auth_group_permissions" VALUES (9,2,10);
INSERT INTO "auth_group_permissions" VALUES (10,2,11);
INSERT INTO "auth_group_permissions" VALUES (11,2,12);
INSERT INTO "auth_group_permissions" VALUES (12,2,13);
INSERT INTO "auth_group_permissions" VALUES (13,2,14);
INSERT INTO "auth_group_permissions" VALUES (14,2,15);
INSERT INTO "auth_group_permissions" VALUES (15,2,16);
INSERT INTO "auth_group_permissions" VALUES (16,2,17);
INSERT INTO "auth_group_permissions" VALUES (17,2,18);
INSERT INTO "auth_group_permissions" VALUES (18,2,19);
INSERT INTO "auth_group_permissions" VALUES (19,2,20);
INSERT INTO "auth_group_permissions" VALUES (20,2,21);
INSERT INTO "auth_group_permissions" VALUES (21,2,22);
INSERT INTO "auth_group_permissions" VALUES (22,2,23);
INSERT INTO "auth_group_permissions" VALUES (23,2,24);
INSERT INTO "auth_group_permissions" VALUES (24,2,25);
INSERT INTO "auth_group_permissions" VALUES (25,2,26);
INSERT INTO "auth_group_permissions" VALUES (26,2,27);
INSERT INTO "auth_group_permissions" VALUES (27,2,28);
INSERT INTO "auth_group_permissions" VALUES (28,2,29);
INSERT INTO "auth_group_permissions" VALUES (29,2,30);
INSERT INTO "auth_group_permissions" VALUES (30,2,31);
INSERT INTO "auth_group_permissions" VALUES (31,2,32);
INSERT INTO "auth_group_permissions" VALUES (32,2,33);
INSERT INTO "auth_group_permissions" VALUES (33,2,34);
INSERT INTO "auth_group_permissions" VALUES (34,2,35);
INSERT INTO "auth_group_permissions" VALUES (35,2,36);
INSERT INTO "auth_group_permissions" VALUES (36,2,37);
INSERT INTO "auth_group_permissions" VALUES (37,2,38);
INSERT INTO "auth_group_permissions" VALUES (38,2,39);
INSERT INTO "auth_group_permissions" VALUES (39,2,40);
INSERT INTO "auth_group_permissions" VALUES (40,2,41);
INSERT INTO "auth_group_permissions" VALUES (41,2,42);
INSERT INTO "auth_group_permissions" VALUES (42,2,43);
INSERT INTO "auth_group_permissions" VALUES (43,2,44);
INSERT INTO "auth_group_permissions" VALUES (44,2,45);
INSERT INTO "auth_group_permissions" VALUES (45,2,46);
INSERT INTO "auth_group_permissions" VALUES (46,2,47);
INSERT INTO "auth_group_permissions" VALUES (47,2,48);
INSERT INTO "auth_group_permissions" VALUES (48,2,49);
INSERT INTO "auth_group_permissions" VALUES (49,2,50);
INSERT INTO "auth_group_permissions" VALUES (50,2,51);
INSERT INTO "auth_group_permissions" VALUES (51,2,52);
INSERT INTO "auth_group_permissions" VALUES (52,2,53);
INSERT INTO "auth_group_permissions" VALUES (53,2,54);
INSERT INTO "auth_group_permissions" VALUES (54,2,55);
INSERT INTO "auth_group_permissions" VALUES (55,2,56);
INSERT INTO "auth_group_permissions" VALUES (56,2,57);
INSERT INTO "auth_group_permissions" VALUES (57,2,58);
INSERT INTO "auth_group_permissions" VALUES (58,2,59);
INSERT INTO "auth_group_permissions" VALUES (59,2,60);
INSERT INTO "auth_group_permissions" VALUES (60,2,61);
INSERT INTO "auth_group_permissions" VALUES (61,2,62);
INSERT INTO "auth_group_permissions" VALUES (62,2,63);
INSERT INTO "auth_group_permissions" VALUES (63,2,64);
INSERT INTO "auth_group_permissions" VALUES (64,2,65);
INSERT INTO "auth_group_permissions" VALUES (65,2,66);
INSERT INTO "auth_group_permissions" VALUES (66,2,67);
INSERT INTO "auth_group_permissions" VALUES (67,2,68);
INSERT INTO "auth_group_permissions" VALUES (68,2,69);
INSERT INTO "auth_group_permissions" VALUES (69,2,70);
INSERT INTO "auth_group_permissions" VALUES (70,2,71);
INSERT INTO "auth_group_permissions" VALUES (71,2,72);
INSERT INTO "auth_group_permissions" VALUES (72,2,73);
INSERT INTO "auth_group_permissions" VALUES (73,2,74);
INSERT INTO "auth_group_permissions" VALUES (74,2,75);
INSERT INTO "auth_group_permissions" VALUES (75,2,76);
INSERT INTO "auth_group_permissions" VALUES (76,2,77);
INSERT INTO "auth_group_permissions" VALUES (77,2,78);
INSERT INTO "auth_group_permissions" VALUES (78,2,79);
INSERT INTO "auth_group_permissions" VALUES (79,2,80);
INSERT INTO "django_admin_log" VALUES (1,'2023-05-12 09:57:21.640923','1','Environmental Science','[{"added": {}}]',8,1,1);
INSERT INTO "django_admin_log" VALUES (2,'2023-05-12 09:58:20.173454','1','John','[{"added": {}}]',11,1,1);
INSERT INTO "django_admin_log" VALUES (3,'2023-05-12 09:58:53.642209','1','Environmental sustanability fundamentals','[{"added": {}}]',7,1,1);
INSERT INTO "django_admin_log" VALUES (4,'2023-05-12 09:59:32.098153','1','Mary','[{"added": {}}]',9,1,1);
INSERT INTO "django_admin_log" VALUES (5,'2023-05-12 10:00:11.947104','1','12-May-23, 10:00 AM','[{"added": {}}]',13,1,1);
INSERT INTO "django_admin_log" VALUES (6,'2023-05-12 10:01:19.591144','1','Assignment 1','[{"added": {}}]',12,1,1);
INSERT INTO "django_admin_log" VALUES (7,'2023-05-12 10:02:17.338463','1','Simple quiz about Environment','[{"added": {}}]',18,1,1);
INSERT INTO "django_admin_log" VALUES (8,'2023-05-12 10:03:00.328947','1','Testing','[{"added": {}}]',19,1,1);
INSERT INTO "django_admin_log" VALUES (9,'2023-05-12 18:50:24.525095','10','Mary','[{"changed": {"fields": ["Student id", "Password"]}}]',9,1,2);
INSERT INTO "django_admin_log" VALUES (10,'2023-05-12 18:50:42.228113','10','Mary','',9,1,3);
INSERT INTO "django_admin_log" VALUES (11,'2023-05-12 18:50:55.883954','10','Mary','[{"changed": {"fields": ["Student id", "Password"]}}]',9,1,2);
INSERT INTO "django_admin_log" VALUES (12,'2023-05-12 18:51:22.536407','1','Mary','',9,1,3);
INSERT INTO "django_admin_log" VALUES (13,'2023-05-12 18:58:35.746903','10','Mary','[]',9,1,2);
INSERT INTO "django_admin_log" VALUES (14,'2023-05-12 18:58:46.082264','10','Mary','[]',9,1,2);
INSERT INTO "django_admin_log" VALUES (15,'2023-05-12 19:03:42.257082','1','John','[]',11,1,2);
INSERT INTO "django_admin_log" VALUES (16,'2023-05-12 19:04:31.631955','1','12-May-23, 10:00 AM','[]',13,1,2);
INSERT INTO "django_admin_log" VALUES (17,'2023-05-12 19:04:51.201692','1','Assignment 1','[]',12,1,2);
INSERT INTO "django_admin_log" VALUES (18,'2023-05-13 10:13:17.651028','1','Testing','[]',19,1,2);
INSERT INTO "django_admin_log" VALUES (19,'2023-05-13 10:13:28.832152','2','Importance of Environment','',18,1,3);
INSERT INTO "django_admin_log" VALUES (20,'2023-05-15 21:47:54.604687','10','Mary','[]',9,1,2);
INSERT INTO "django_admin_log" VALUES (21,'2023-05-18 21:14:50.623396','1','Module Lead','[{"added": {}}]',3,1,1);
INSERT INTO "django_admin_log" VALUES (22,'2023-05-18 21:15:26.794435','1','Module Lead','',3,1,3);
INSERT INTO "django_admin_log" VALUES (23,'2023-05-18 21:21:05.533006','2','18-May-23, 09:21 PM','[{"added": {}}]',13,1,1);
INSERT INTO "django_admin_log" VALUES (24,'2023-05-18 21:21:53.910270','2','18-May-23, 09:21 PM','[{"changed": {"fields": ["Description"]}}]',13,1,2);
INSERT INTO "django_admin_log" VALUES (25,'2023-05-18 21:22:37.253532','2','18-May-23, 09:21 PM','[{"changed": {"fields": ["Description"]}}]',13,1,2);
INSERT INTO "django_admin_log" VALUES (26,'2023-05-25 17:11:15.054153','11','Dom Torrento','[{"added": {}}]',9,1,1);
INSERT INTO "django_admin_log" VALUES (27,'2023-05-25 17:12:17.509716','11','Dom Torrento','[{"changed": {"fields": ["Course"]}}]',9,1,2);
INSERT INTO "django_admin_log" VALUES (28,'2023-05-25 17:26:09.005128','5','Waste Management ','',18,1,3);
INSERT INTO "django_admin_log" VALUES (29,'2023-05-25 17:27:28.708948','2','Tom','[{"added": {}}]',4,1,1);
INSERT INTO "django_admin_log" VALUES (30,'2023-05-25 17:29:59.818236','2','Tom','[{"changed": {"fields": ["First name", "Last name", "Email address", "Staff status", "User permissions", "Last login"]}}]',4,1,2);
INSERT INTO "django_admin_log" VALUES (31,'2023-05-25 17:30:37.570720','1','John','[]',11,1,2);
INSERT INTO "django_admin_log" VALUES (32,'2023-05-25 17:30:44.634467','2','Tom','[]',4,1,2);
INSERT INTO "django_admin_log" VALUES (33,'2023-05-25 17:32:13.855211','2','Tom','[]',4,1,2);
INSERT INTO "django_admin_log" VALUES (35,'2023-05-25 17:34:17.143949','2','Tom','',4,1,3);
INSERT INTO "django_admin_log" VALUES (36,'2023-05-25 17:35:35.741436','2','Module Lead','[{"added": {}}]',3,1,1);
INSERT INTO "django_admin_log" VALUES (37,'2023-05-25 17:35:42.568095','2','Module Lead','[]',3,1,2);
INSERT INTO "django_admin_log" VALUES (38,'2023-05-25 17:36:42.027867','3','Tom','[{"added": {}}]',4,1,1);
INSERT INTO "django_admin_log" VALUES (39,'2023-05-25 17:37:30.919587','3','Tom','[{"changed": {"fields": ["First name", "Last name", "Email address", "Groups"]}}]',4,1,2);
INSERT INTO "django_admin_log" VALUES (40,'2023-05-25 17:38:00.168663','3','Tom','[{"changed": {"fields": ["Staff status"]}}]',4,1,2);
INSERT INTO "django_admin_log" VALUES (41,'2023-05-25 17:38:13.053409','1','Admin','[]',4,1,2);
INSERT INTO "django_admin_log" VALUES (42,'2023-05-25 17:39:13.110081','3','Tom','',4,1,3);
INSERT INTO "django_admin_log" VALUES (43,'2023-05-25 17:39:20.416674','1','Admin','[]',4,1,2);
INSERT INTO "main_department" VALUES (1,'Environmental Science','This is a place where we can learn more about enviromental sustanablity');
INSERT INTO "main_student" VALUES (10,'Mary','Mary@gmail.com','Mary','Student','profile_pics/jonas-kakaroto-mjRwhvqEC0U-unsplash.jpg',1);
INSERT INTO "main_student" VALUES (11,'Dom Torrento','FamilyForever@example.com','Family','Student','profile_pics/Dom_screenshot.JPG',1);
INSERT INTO "main_student_course" VALUES (3,10,1);
INSERT INTO "main_student_course" VALUES (4,11,1);
INSERT INTO "main_material" VALUES (1,'<p>Topic 1</p>','2023-05-16 13:10:57.789988','materials/__xid-49693158_1.pdf',1);
INSERT INTO "main_material" VALUES (2,'<p>Topic 2</p>','2023-05-18 21:05:18.361285','materials/__xid-49244994_1.pptx',1);
INSERT INTO "main_faculty" VALUES (1,'John','John@gmail.com','John','Faculty','profile_pics/Infosec_Zombie.png',1);
INSERT INTO "main_course" VALUES (1,'Environmental sustanability fundamentals',1,1,1,1);
INSERT INTO "main_assignment" VALUES (1,'Assignment 1','Please submit assignment in pdf format.','2023-05-12 10:01:19.583147','2023-05-19 08:00:57','assignments/Assignment_1.jpg',20,1);
INSERT INTO "main_announcement" VALUES (1,'2023-05-12 10:00:11.940089','<p>Please do assignment 1 which is worth <strong>15%</strong> of your grade for this course!</p>',1);
INSERT INTO "main_announcement" VALUES (3,'2023-05-25 17:01:49.830303','<p><span id="isPasted" style="color: rgb(33, 37, 41); font-family: Inter, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;">Please refer to this video as a briefing for the next assignment that is worth&nbsp;</span><strong style="box-sizing: border-box; font-family: Inter, sans-serif; font-weight: bolder; color: rgb(33, 37, 41); font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;">25%</strong><span style="color: rgb(33, 37, 41); font-family: Inter, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;">&nbsp;of your grade for your module.</span>&nbsp;</p><p><span class="fr-video fr-deletable fr-fvc fr-dvb fr-draggable" contenteditable="false" draggable="true"><iframe width="640" height="360" src="https://www.youtube.com/embed/5lrn4CDQZzo?&pp=ygUpZW52aXJvbm1lbnRhbCBzdXN0YWluYWJpbGl0eSBwcmVzZW50YXRpb24%3D&wmode=opaque&rel=0" frameborder="0" allowfullscreen="" class="fr-draggable"></iframe></span><br></p>',1);
INSERT INTO "main_announcement" VALUES (4,'2023-05-25 17:33:19.376847','<p>Testing</p>',1);
INSERT INTO "main_submission" VALUES (1,'submissions/Screenshot_2023-05-01_192833.png','2023-05-15 21:43:23.771283',18,'Submitted',1,10);
INSERT INTO "attendance_attendance" VALUES (1,'2023-05-15',1,'2023-05-15 21:45:30.154215','2023-05-16 13:12:01.285614',1,10);
INSERT INTO "attendance_attendance" VALUES (2,'2023-05-16',1,'2023-05-16 13:12:07.902247','2023-05-16 13:12:21.393213',1,10);
INSERT INTO "django_content_type" VALUES (1,'admin','logentry');
INSERT INTO "django_content_type" VALUES (2,'auth','permission');
INSERT INTO "django_content_type" VALUES (3,'auth','group');
INSERT INTO "django_content_type" VALUES (4,'auth','user');
INSERT INTO "django_content_type" VALUES (5,'contenttypes','contenttype');
INSERT INTO "django_content_type" VALUES (6,'sessions','session');
INSERT INTO "django_content_type" VALUES (7,'main','course');
INSERT INTO "django_content_type" VALUES (8,'main','department');
INSERT INTO "django_content_type" VALUES (9,'main','student');
INSERT INTO "django_content_type" VALUES (10,'main','material');
INSERT INTO "django_content_type" VALUES (11,'main','faculty');
INSERT INTO "django_content_type" VALUES (12,'main','assignment');
INSERT INTO "django_content_type" VALUES (13,'main','announcement');
INSERT INTO "django_content_type" VALUES (14,'main','submission');
INSERT INTO "django_content_type" VALUES (15,'discussion','studentdiscussion');
INSERT INTO "django_content_type" VALUES (16,'discussion','facultydiscussion');
INSERT INTO "django_content_type" VALUES (17,'attendance','attendance');
INSERT INTO "django_content_type" VALUES (18,'quiz','quiz');
INSERT INTO "django_content_type" VALUES (19,'quiz','question');
INSERT INTO "django_content_type" VALUES (20,'quiz','studentanswer');
INSERT INTO "auth_permission" VALUES (1,1,'add_logentry','Can add log entry');
INSERT INTO "auth_permission" VALUES (2,1,'change_logentry','Can change log entry');
INSERT INTO "auth_permission" VALUES (3,1,'delete_logentry','Can delete log entry');
INSERT INTO "auth_permission" VALUES (4,1,'view_logentry','Can view log entry');
INSERT INTO "auth_permission" VALUES (5,2,'add_permission','Can add permission');
INSERT INTO "auth_permission" VALUES (6,2,'change_permission','Can change permission');
INSERT INTO "auth_permission" VALUES (7,2,'delete_permission','Can delete permission');
INSERT INTO "auth_permission" VALUES (8,2,'view_permission','Can view permission');
INSERT INTO "auth_permission" VALUES (9,3,'add_group','Can add group');
INSERT INTO "auth_permission" VALUES (10,3,'change_group','Can change group');
INSERT INTO "auth_permission" VALUES (11,3,'delete_group','Can delete group');
INSERT INTO "auth_permission" VALUES (12,3,'view_group','Can view group');
INSERT INTO "auth_permission" VALUES (13,4,'add_user','Can add user');
INSERT INTO "auth_permission" VALUES (14,4,'change_user','Can change user');
INSERT INTO "auth_permission" VALUES (15,4,'delete_user','Can delete user');
INSERT INTO "auth_permission" VALUES (16,4,'view_user','Can view user');
INSERT INTO "auth_permission" VALUES (17,5,'add_contenttype','Can add content type');
INSERT INTO "auth_permission" VALUES (18,5,'change_contenttype','Can change content type');
INSERT INTO "auth_permission" VALUES (19,5,'delete_contenttype','Can delete content type');
INSERT INTO "auth_permission" VALUES (20,5,'view_contenttype','Can view content type');
INSERT INTO "auth_permission" VALUES (21,6,'add_session','Can add session');
INSERT INTO "auth_permission" VALUES (22,6,'change_session','Can change session');
INSERT INTO "auth_permission" VALUES (23,6,'delete_session','Can delete session');
INSERT INTO "auth_permission" VALUES (24,6,'view_session','Can view session');
INSERT INTO "auth_permission" VALUES (25,7,'add_course','Can add course');
INSERT INTO "auth_permission" VALUES (26,7,'change_course','Can change course');
INSERT INTO "auth_permission" VALUES (27,7,'delete_course','Can delete course');
INSERT INTO "auth_permission" VALUES (28,7,'view_course','Can view course');
INSERT INTO "auth_permission" VALUES (29,8,'add_department','Can add department');
INSERT INTO "auth_permission" VALUES (30,8,'change_department','Can change department');
INSERT INTO "auth_permission" VALUES (31,8,'delete_department','Can delete department');
INSERT INTO "auth_permission" VALUES (32,8,'view_department','Can view department');
INSERT INTO "auth_permission" VALUES (33,9,'add_student','Can add student');
INSERT INTO "auth_permission" VALUES (34,9,'change_student','Can change student');
INSERT INTO "auth_permission" VALUES (35,9,'delete_student','Can delete student');
INSERT INTO "auth_permission" VALUES (36,9,'view_student','Can view student');
INSERT INTO "auth_permission" VALUES (37,10,'add_material','Can add material');
INSERT INTO "auth_permission" VALUES (38,10,'change_material','Can change material');
INSERT INTO "auth_permission" VALUES (39,10,'delete_material','Can delete material');
INSERT INTO "auth_permission" VALUES (40,10,'view_material','Can view material');
INSERT INTO "auth_permission" VALUES (41,11,'add_faculty','Can add faculty');
INSERT INTO "auth_permission" VALUES (42,11,'change_faculty','Can change faculty');
INSERT INTO "auth_permission" VALUES (43,11,'delete_faculty','Can delete faculty');
INSERT INTO "auth_permission" VALUES (44,11,'view_faculty','Can view faculty');
INSERT INTO "auth_permission" VALUES (45,12,'add_assignment','Can add assignment');
INSERT INTO "auth_permission" VALUES (46,12,'change_assignment','Can change assignment');
INSERT INTO "auth_permission" VALUES (47,12,'delete_assignment','Can delete assignment');
INSERT INTO "auth_permission" VALUES (48,12,'view_assignment','Can view assignment');
INSERT INTO "auth_permission" VALUES (49,13,'add_announcement','Can add announcement');
INSERT INTO "auth_permission" VALUES (50,13,'change_announcement','Can change announcement');
INSERT INTO "auth_permission" VALUES (51,13,'delete_announcement','Can delete announcement');
INSERT INTO "auth_permission" VALUES (52,13,'view_announcement','Can view announcement');
INSERT INTO "auth_permission" VALUES (53,14,'add_submission','Can add submission');
INSERT INTO "auth_permission" VALUES (54,14,'change_submission','Can change submission');
INSERT INTO "auth_permission" VALUES (55,14,'delete_submission','Can delete submission');
INSERT INTO "auth_permission" VALUES (56,14,'view_submission','Can view submission');
INSERT INTO "auth_permission" VALUES (57,15,'add_studentdiscussion','Can add student discussion');
INSERT INTO "auth_permission" VALUES (58,15,'change_studentdiscussion','Can change student discussion');
INSERT INTO "auth_permission" VALUES (59,15,'delete_studentdiscussion','Can delete student discussion');
INSERT INTO "auth_permission" VALUES (60,15,'view_studentdiscussion','Can view student discussion');
INSERT INTO "auth_permission" VALUES (61,16,'add_facultydiscussion','Can add faculty discussion');
INSERT INTO "auth_permission" VALUES (62,16,'change_facultydiscussion','Can change faculty discussion');
INSERT INTO "auth_permission" VALUES (63,16,'delete_facultydiscussion','Can delete faculty discussion');
INSERT INTO "auth_permission" VALUES (64,16,'view_facultydiscussion','Can view faculty discussion');
INSERT INTO "auth_permission" VALUES (65,17,'add_attendance','Can add attendance');
INSERT INTO "auth_permission" VALUES (66,17,'change_attendance','Can change attendance');
INSERT INTO "auth_permission" VALUES (67,17,'delete_attendance','Can delete attendance');
INSERT INTO "auth_permission" VALUES (68,17,'view_attendance','Can view attendance');
INSERT INTO "auth_permission" VALUES (69,18,'add_quiz','Can add quiz');
INSERT INTO "auth_permission" VALUES (70,18,'change_quiz','Can change quiz');
INSERT INTO "auth_permission" VALUES (71,18,'delete_quiz','Can delete quiz');
INSERT INTO "auth_permission" VALUES (72,18,'view_quiz','Can view quiz');
INSERT INTO "auth_permission" VALUES (73,19,'add_question','Can add question');
INSERT INTO "auth_permission" VALUES (74,19,'change_question','Can change question');
INSERT INTO "auth_permission" VALUES (75,19,'delete_question','Can delete question');
INSERT INTO "auth_permission" VALUES (76,19,'view_question','Can view question');
INSERT INTO "auth_permission" VALUES (77,20,'add_studentanswer','Can add student answer');
INSERT INTO "auth_permission" VALUES (78,20,'change_studentanswer','Can change student answer');
INSERT INTO "auth_permission" VALUES (79,20,'delete_studentanswer','Can delete student answer');
INSERT INTO "auth_permission" VALUES (80,20,'view_studentanswer','Can view student answer');
INSERT INTO "auth_group" VALUES (2,'Module Lead');
INSERT INTO "auth_user" VALUES (1,'pbkdf2_sha256$390000$GqDksmOOUE4xukvH2EvCqO$iJc6VgapRR65UpXsnW23mu9bHyg3Pny5ttLNyffDVDw=','2023-05-26 09:37:34.574649',1,'Admin','','Admin@gmail.com',1,1,'2023-05-12 09:52:38','');
INSERT INTO "discussion_studentdiscussion" VALUES (1,'School was fine Mr John','2023-05-13 10:14:54.017685',1,10);
INSERT INTO "discussion_studentdiscussion" VALUES (2,'Sorry guys, I was looking after my family!','2023-05-25 17:14:25.372265',1,11);
INSERT INTO "discussion_facultydiscussion" VALUES (1,'How was school today?','2023-05-13 10:13:53.782954',1,1);
INSERT INTO "quiz_quiz" VALUES (1,'Simple quiz about Environment','Environmental science pop quiz','2023-05-12 08:02:04','2023-05-19 08:02:12','2023-05-12 10:02:17.330535','2023-05-25 17:40:15.423771',1,1,1);
INSERT INTO "quiz_quiz" VALUES (3,'Testing 2','Please finish all the questions','2023-05-15 21:38:00','2023-05-22 12:00:00','2023-05-15 21:38:59.936040','2023-05-25 17:40:15.415028',1,1,1);
INSERT INTO "quiz_quiz" VALUES (4,'Sus','Do test ','2023-05-16 13:14:00','2023-05-23 13:14:00','2023-05-16 13:14:43.122588','2023-05-25 17:40:15.408018',1,1,1);
INSERT INTO "quiz_question" VALUES (1,'Testing',2,'This is correct','This is wrong','This is wrong','This is wrong','A','Testing',1);
INSERT INTO "quiz_question" VALUES (2,'First Question',2,'Yes','No','No','No','A','A is the correct answer in this case',3);
INSERT INTO "quiz_question" VALUES (3,'Second Question',2,'No','No','Yes','No','C','C is the correct answer.',3);
INSERT INTO "quiz_question" VALUES (4,'Third Question',2,'No','Yes','No','No','B','B is the correct answer.',3);
INSERT INTO "quiz_question" VALUES (5,'Testing',2,'Yes','No','No','No','A','A is the correct answer',4);
INSERT INTO "quiz_studentanswer" VALUES (1,'A',2,'2023-05-12 19:06:32.490709',1,1,10);
INSERT INTO "quiz_studentanswer" VALUES (2,'A',2,'2023-05-15 21:42:22.963936',2,3,10);
INSERT INTO "quiz_studentanswer" VALUES (3,'B',0,'2023-05-15 21:42:22.977811',3,3,10);
INSERT INTO "quiz_studentanswer" VALUES (4,'B',2,'2023-05-15 21:42:22.980801',4,3,10);
INSERT INTO "quiz_studentanswer" VALUES (5,'B',0,'2023-05-16 13:18:10.383798',5,4,10);
CREATE UNIQUE INDEX IF NOT EXISTS "auth_group_permissions_group_id_permission_id_0cd325b0_uniq" ON "auth_group_permissions" (
	"group_id",
	"permission_id"
);
CREATE INDEX IF NOT EXISTS "auth_group_permissions_group_id_b120cbf9" ON "auth_group_permissions" (
	"group_id"
);
CREATE INDEX IF NOT EXISTS "auth_group_permissions_permission_id_84c5c92e" ON "auth_group_permissions" (
	"permission_id"
);
CREATE UNIQUE INDEX IF NOT EXISTS "auth_user_groups_user_id_group_id_94350c0c_uniq" ON "auth_user_groups" (
	"user_id",
	"group_id"
);
CREATE INDEX IF NOT EXISTS "auth_user_groups_user_id_6a12ed8b" ON "auth_user_groups" (
	"user_id"
);
CREATE INDEX IF NOT EXISTS "auth_user_groups_group_id_97559544" ON "auth_user_groups" (
	"group_id"
);
CREATE UNIQUE INDEX IF NOT EXISTS "auth_user_user_permissions_user_id_permission_id_14a6b632_uniq" ON "auth_user_user_permissions" (
	"user_id",
	"permission_id"
);
CREATE INDEX IF NOT EXISTS "auth_user_user_permissions_user_id_a95ead1b" ON "auth_user_user_permissions" (
	"user_id"
);
CREATE INDEX IF NOT EXISTS "auth_user_user_permissions_permission_id_1fbb5f2c" ON "auth_user_user_permissions" (
	"permission_id"
);
CREATE INDEX IF NOT EXISTS "django_admin_log_content_type_id_c4bce8eb" ON "django_admin_log" (
	"content_type_id"
);
CREATE INDEX IF NOT EXISTS "django_admin_log_user_id_c564eba6" ON "django_admin_log" (
	"user_id"
);
CREATE INDEX IF NOT EXISTS "main_student_department_id_94f07529" ON "main_student" (
	"department_id"
);
CREATE UNIQUE INDEX IF NOT EXISTS "main_student_course_student_id_course_id_8daf50dc_uniq" ON "main_student_course" (
	"student_id",
	"course_id"
);
CREATE INDEX IF NOT EXISTS "main_student_course_student_id_9da32d28" ON "main_student_course" (
	"student_id"
);
CREATE INDEX IF NOT EXISTS "main_student_course_course_id_872fc03c" ON "main_student_course" (
	"course_id"
);
CREATE INDEX IF NOT EXISTS "main_material_course_code_id_2aed10c8" ON "main_material" (
	"course_code_id"
);
CREATE INDEX IF NOT EXISTS "main_faculty_department_id_123b9ec7" ON "main_faculty" (
	"department_id"
);
CREATE INDEX IF NOT EXISTS "main_course_department_id_bd662e7c" ON "main_course" (
	"department_id"
);
CREATE INDEX IF NOT EXISTS "main_course_faculty_id_86dcf2b3" ON "main_course" (
	"faculty_id"
);
CREATE UNIQUE INDEX IF NOT EXISTS "main_course_code_department_id_name_099e0bb4_uniq" ON "main_course" (
	"code",
	"department_id",
	"name"
);
CREATE INDEX IF NOT EXISTS "main_assignment_course_code_id_3ee9c816" ON "main_assignment" (
	"course_code_id"
);
CREATE INDEX IF NOT EXISTS "main_announcement_course_code_id_fef48428" ON "main_announcement" (
	"course_code_id"
);
CREATE UNIQUE INDEX IF NOT EXISTS "main_submission_assignment_id_student_id_b41b7195_uniq" ON "main_submission" (
	"assignment_id",
	"student_id"
);
CREATE INDEX IF NOT EXISTS "main_submission_assignment_id_ddd2348f" ON "main_submission" (
	"assignment_id"
);
CREATE INDEX IF NOT EXISTS "main_submission_student_id_49dd63c7" ON "main_submission" (
	"student_id"
);
CREATE INDEX IF NOT EXISTS "attendance_attendance_course_id_1d4d6a83" ON "attendance_attendance" (
	"course_id"
);
CREATE INDEX IF NOT EXISTS "attendance_attendance_student_id_94863613" ON "attendance_attendance" (
	"student_id"
);
CREATE UNIQUE INDEX IF NOT EXISTS "django_content_type_app_label_model_76bd3d3b_uniq" ON "django_content_type" (
	"app_label",
	"model"
);
CREATE UNIQUE INDEX IF NOT EXISTS "auth_permission_content_type_id_codename_01ab375a_uniq" ON "auth_permission" (
	"content_type_id",
	"codename"
);
CREATE INDEX IF NOT EXISTS "auth_permission_content_type_id_2f476e4b" ON "auth_permission" (
	"content_type_id"
);
CREATE INDEX IF NOT EXISTS "discussion_studentdiscussion_course_id_ae59979a" ON "discussion_studentdiscussion" (
	"course_id"
);
CREATE INDEX IF NOT EXISTS "discussion_studentdiscussion_sent_by_id_536a7eae" ON "discussion_studentdiscussion" (
	"sent_by_id"
);
CREATE INDEX IF NOT EXISTS "discussion_facultydiscussion_course_id_b6401a93" ON "discussion_facultydiscussion" (
	"course_id"
);
CREATE INDEX IF NOT EXISTS "discussion_facultydiscussion_sent_by_id_b65af0e9" ON "discussion_facultydiscussion" (
	"sent_by_id"
);
CREATE INDEX IF NOT EXISTS "quiz_quiz_course_id_dd25aae3" ON "quiz_quiz" (
	"course_id"
);
CREATE INDEX IF NOT EXISTS "quiz_question_quiz_id_b7429966" ON "quiz_question" (
	"quiz_id"
);
CREATE UNIQUE INDEX IF NOT EXISTS "quiz_studentanswer_student_id_quiz_id_question_id_a1d14b46_uniq" ON "quiz_studentanswer" (
	"student_id",
	"quiz_id",
	"question_id"
);
CREATE INDEX IF NOT EXISTS "quiz_studentanswer_question_id_aeb56a58" ON "quiz_studentanswer" (
	"question_id"
);
CREATE INDEX IF NOT EXISTS "quiz_studentanswer_quiz_id_474c5e0c" ON "quiz_studentanswer" (
	"quiz_id"
);
CREATE INDEX IF NOT EXISTS "quiz_studentanswer_student_id_24a540d2" ON "quiz_studentanswer" (
	"student_id"
);
CREATE INDEX IF NOT EXISTS "django_session_expire_date_a5c62663" ON "django_session" (
	"expire_date"
);
COMMIT;
