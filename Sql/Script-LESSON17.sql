CREATE TABLE Students (
    student_id INTEGER PRIMARY KEY,
    first_name TEXT,
    last_name TEXT,
    dob TEXT,
    major TEXT,
    gpa REAL
);
--
CREATE TABLE Courses (
    course_id INTEGER PRIMARY KEY,
    course_name TEXT,
    department TEXT
);
--
CREATE TABLE Instructors (
    instructor_id INTEGER PRIMARY KEY,
    instructor_name TEXT,
    department TEXT
);
--
CREATE TABLE Enrolments (
    enrolment_id INTEGER PRIMARY KEY,
    student_id INTEGER,
    course_id INTEGER,
    semester TEXT,
    grade TEXT,
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (course_id) REFERENCES Courses(course_id)
);
---create the view InstructorSchedule
CREATE VIEW InstructorSchedule AS
SELECT 
    i.instructor_id,
    i.instructor_name,
    i.department,
    c.course_id,
    c.course_name
FROM Instructors i
JOIN Courses c
    ON i.department = c.department;
--Modify CourseSummary
CREATE VIEW CourseSummary AS
SELECT 
    c.course_id,
    c.course_name,
    GROUP_CONCAT(DISTINCT e.semester) AS semesters_offered,
    COUNT(e.student_id) AS total_enrollment
FROM Courses c
LEFT JOIN Enrolments e
    ON c.course_id = e.course_id
GROUP BY c.course_id, c.course_name;

SELECT * FROM CourseSummary;
--Update InstructorSchedule
CREATE VIEW InstructorSchedule_currentsemester AS
SELECT 
    i.instructor_id,
    i.instructor_name,
    i.department,
    c.course_id,
    c.course_name,
    e.semester
FROM Instructors i
JOIN Courses c
    ON i.department = c.department
JOIN Enrolments e
    ON c.course_id = e.course_id
WHERE e.semester = 'Spring 2024';
--Create a view EligibleGraduates
CREATE VIEW EligibleGraduates AS
SELECT
    student_id,
    first_name,
    last_name,
    gpa,
    major
FROM Students
WHERE gpa >= 3.7;
--Alter EligibleGraduates to include students' GPAs
CREATE VIEW EligibleGraduates_WithGPA AS
SELECT
    student_id,
    first_name,
    last_name,
    gpa,
    major
FROM Students
WHERE gpa >= 3.7;
--Rename CourseSummary
CREATE VIEW CourseEnrolmentSummary AS
SELECT
    c.course_id,
    c.course_name,
    GROUP_CONCAT(DISTINCT e.semester) AS semesters_offered,
    COUNT(e.student_id) AS total_enrollment
FROM Courses c
LEFT JOIN Enrolments e
    ON c.course_id = e.course_id
GROUP BY c.course_id, c.course_name;
--Drop EligibleGraduates
DROP VIEW IF EXISTS EligibleGraduates;
--
WITH SemesterCourses AS (
    SELECT
        e.course_id,
        c.course_name,
        e.semester
    FROM Enrolments e
    JOIN Courses c
        ON e.course_id = c.course_id
    WHERE e.semester = 'Fall 2023'
)
SELECT * FROM SemesterCourses;


