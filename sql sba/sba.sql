
/* The curriculum Planning committee is attempting to fill in gaps in the current course offerings.
You need to provide them with a query which lists each department and the number of courses
offered by that department 

The output should be stored first by the NUMBER OF courses in
ascending order, then by department.

The query below select records from name column from department table and 
counts number of courses offered by each department. Used LEFT join to show each 
department from department table and courses offered by each department from course table.
*/
SELECT 
	dept.name AS 'Department Name',
	COUNT(c.id) AS 'Number of courses'
FROM
	department AS dept 
LEFT JOIN course AS c
	ON dept.id = c.deptid 
GROUP BY 
	dept.name
ORDER BY 
	COUNT(c.id), dept.name ASC;

/* 
3.The recruiting department needs to know which courses are most popular with the students
Please provide them with a query which lists the name of each course and the number of students
in that course.

The output should be sorted by the NUMBER OF STUDENTS in descending order, then by COURSE NAME in ascending order.


/*
 The query below list all courses from the course table and nummber of student taking each courses
 The count function takes in studentid column and returns number of students taking each courses when used the group by statement later in the query.
 Also used the inner join to show the relationship between course and studentcourse table, both table has
 studeent id in common. The inner join selects records that has matching values of course id. 
*/

	
SELECT
	course.name AS 'Courses',
	COUNT(studentcourse.studentid) AS 'Number of students'
FROM 
	course INNER JOIN studentcourse 
ON course.id = studentcourse.courseid
GROUP BY
course.name
ORDER BY
COUNT(studentcourse.studentid) DESC , course.name ASC;



/*
4. Quite a few students have been complaining that the professors are absent from
some of their courses.

Write a query to list the names of all COURSES where the number of faculty assisged to those courese is zero.
The output should be sorted by Course Name in ascending alphabetical order

*/


SELECT
course.name AS 'Courses with no faculty assigned'
FROM 
course LEFT JOIN facultycourse
ON course.id = facultycourse.courseid
WHERE
 ( SELECT 
 	COUNT(facultycourse.facultyid) = 0 )
ORDER BY 
course.name ASC;



/*
5. Write a query to list the course names and the number of students in those
courses for all courses where there are no assigned faculty. 

The output should be sorted first by the NUMBER OF STUDENTS in decending order, then
by Course name in ascending order.

*/


SELECT course.name AS 'Courses',
COUNT(studentcourse.studentid) AS 'number of students'
FROM 
course LEFT JOIN facultycourse 
ON course.id = facultycourse.courseid
INNER JOIN studentcourse 
ON studentcourse.courseid = course.id
WHERE ( SELECT 
		  COUNT(facultycourse.courseid) = 0)
GROUP BY course.name
ORDER BY COUNT(studentcourse.studentid) DESC, course.name ASC;


/*
6. The enrollment team is gathering analytics about student enrollment throughout the years.
Write a query that lists the TOTALNUMBER OF STUDENTS that were enrolled in classes during each
SCHOOL YEAR. The first column should have the header 'Students'. Provide a second 'YEAR' column showing
the enrollment year.

The output should be sorted first by the SCHOOL YEAR in ascending order, then by TOTALNUMBER of STUDENTS in 
decending order.
*/


SELECT
COUNT(studentcourse.studentid) AS 'Students' ,
YEAR(studentcourse.startdate) AS 'YEAR' 
FROM studentcourse 
GROUP BY YEAR(studentcourse.startdate)
ORDER BY YEAR(studentcourse.startdate) , COUNT(studentcourse.studentid) DESC;


SELECT
COUNT(studentid) AS 'Students' ,
DATE_FORMAT(startdate, '%Y') AS 'YEAR' 
FROM studentcourse
GROUP BY DATE_FORMAT(startdate, '%Y')
ORDER BY DATE_FORMAT(startdate, '%Y') , COUNT(studentid) DESC;


SELECT
	FORMAT(startdate, 'YYYY') AS 'YEAR'



/* 
The enrollment team is gathering analytics about student enrollment and they
now want to know about August admissions specifically. 

Write a query that lists the start Date and Total Number of Students who
enrolled in classes in August of each year.

The output should be ordered first by Start Date in ascending order and then
by TOTAL Number of Students in ascending order. 

*/

SELECT startdate, COUNT(Distinct studentid) 
FROM 
studentcourse 
WHERE
 ( MONTHNAME(startdate) = 'August' )
GROUP BY startdate
ORDER BY startdate ASC, COUNT( DISTINCT studentid) ASC;

-- _________ OR ___________________

SELECT startdate, COUNT(studentid) 
FROM 
studentcourse 
WHERE
	startdate LIKE '%-08-%'
GROUP BY startdate
ORDER BY startdate ASC, COUNT(studentid) ASC;



/* 8
 List students name and # of courses in their major
 
 students are required to take 4 courses, and at least two of these courses must be
 from the department of their major.
 
 Write a query to list students FIRST NAME, LAST NAME , and NUMBER OF COURSES they are taking
 in their major department
 
 THe output should be sorted first by the NUMBER OF COURSES in decending order, then by
 First Name in ascending order, then by the Last Name in ascending order. 

*/



SELECT student.firstname AS 'First Name',
		 student.lastname AS 'Last Name',
		 COUNT(studentcourse.courseid) AS 'Number of Courses'
FROM 
	student INNER JOIN studentcourse
		ON student.id = studentcourse.studentid
		
		INNER JOIN course ON studentcourse.courseid = course.id
		WHERE student.majorid = course.deptid
GROUP BY
student.lastname, student.firstname		
ORDER BY 
COUNT(studentcourse.courseid)	, student.lastname;	



						
/* 9 Student making average progress in their courses of less than 50% need to be offered  tutoring assistance.
  Write a query to list First Name, Last Name, and Average Progress of all students achieving average progress
  of less than 50% 
  
  The average progress displayed should be rounded to one decimal place
  
  The output should be sorted first by Average progress in decending order, then by First Name in 
  ascending order, then by the Last Name in ascending order. 
*/

SELECT student.firstname AS 'First Name', 
		  student.lastname AS 'Last Name' , 
		  ROUND(AVG( studentcourse.progress), 1) AS 'Average Progress'
FROM
studentcourse  JOIN student
	ON studentcourse.studentid = student.id
GROUP BY
 student.lastname, student.firstname
WHERE	
	AVG(studentcourse.progress) < 50 
ORDER BY
AVG(studentcourse.progress) DESC, student.firstname, student.lastname;

/* 10
faculty are awarded bonuses based on the progress made by students in their courses
 
Write a query to list each COURSE NAME and the Average Progress of students in that course

The Average Progress displayed should be rounded to one decimal place

The output should be sorted first by Average Progress in descending order, then by Course Name in 
 ascending order.

*/

SELECT 
		course.name AS 'Course Name',
       ROUND(AVG(studentcourse.progress), 1) AS 'Average Progress'
FROM 
course INNER JOIN studentcourse
	ON course.id = studentcourse.courseid
GROUP BY studentcourse.courseid
ORDER BY ROUND(AVG(studentcourse.progress), 1) DESC, course.name; 

/* 11 
 Faculty are awared bonuses based on the progress made by students in their courses
 
 Write a query that shows the COURSE NAME and the Average Student Progress of the Course
 with the highest Average progress in the system
 
 The Average Progress displayed should be rounded to one decimal place. 

*/


SELECT course.name AS 'Course name',
		 ROUND(AVG(studentcourse.progress), 1) AS 'Highest Average progress'
FROM 
course INNER JOIN studentcourse
	ON course.id = studentcourse.courseid
GROUP BY 
course.name
ORDER BY 
AVG(studentcourse.progress) DESC LIMIT 0,1;


/* 12
faculty are awarded bonuses based on the progress made by students in their courses.

Write a query that ouputs the faculty First Name, Last Name, and the Average Progress made 
over all of their courses.

The Avearage progress displayed should be rounded to one decimal place.

The output should be sorted by Average Progress in descending order , then by First Name in ascending order, 
then by Last Name in ascending order. 

*/


SELECT faculty.firstname AS 'First Name',
		 faculty.lastname AS 'Last Name', 
		 ROUND(AVG(studentcourse.progress), 1) AS 'Average progress'
FROM
	 faculty INNER JOIN facultycourse 
	 ON faculty.id = facultycourse.facultyid
	 INNER JOIN studentcourse 
	 ON facultycourse.courseid = studentcourse.courseid
GROUP BY 
faculty.id
ORDER BY AVG(studentcourse.progress) DESC , faculty.firstname, faculty.lastname;


/*
 13 Faculty are awarded bonuses based on the progress made by students in their courses
 
 Write a query that outputs the faculty First Name, Last Name, and the Average Progress
 made by students over all of their courses.
 
 Display only records from faculty where their Average Progress is 90% or more, of the course with
 the highest/maximum Average Progress of students in that Course
 
 The Average Progress displayed should be rounded to one decimal place.
 
 The output should be sorted by Average Progress in descending order, then by First Name in ascending order,
 then by Last Name in ascending order.  
 
*/





/*
Students are awared two grades based on the minimum and maximum progress they are making in their
courses. The grading scale is as follows

Progress< 40: F
Progress < 50: D
Progress<60: C
Progress<70: B
Progress >=70: A

Write a query that displays each student's First Name, Last Name, Minimum Grade based on their minimum
progress, and Maximum Grade based on their maximum progress

The output should be sorted by Minimum Grade in  descending order, then by Maximum Grade in decending order,
then by First Name in ascending order, then by Last Name in ascending order

*/



SELECT
	s.firstname AS 'First Name',
	s.lastname AS 'Last Name',
	(CASE
		WHEN MIN(sc.progress) < 40 THEN 'F'
		WHEN MIN(sc.progress) < 50 THEN 'D'
		WHEN MIN(sc.progress) < 60 THEN 'C'
		WHEN MIN(sc.progress) < 70 THEN 'B'
		WHEN MIN(sc.progress) >= 70 THEN 'A'
END) AS 'Minimum Grade', 
	(CASE
		WHEN MAX(sc.progress) < 40 THEN 'F'
		WHEN MAX(sc.progress) < 50 THEN 'D'
		WHEN MAX(sc.progress) < 60 THEN 'C'
		WHEN MAX(sc.progress) < 70 THEN 'B'
		WHEN MAX(sc.progress) >= 70 THEN 'A'
END) AS 'Maximum Grade'

FROM 
	student s RIGHT JOIN studentcourse sc
	ON s.id = sc.studentid
GROUP BY
  s.firstname, s.lastname, 'Minimum Grade', 'Maximum Grade'
ORDER BY 
'Minimum Grade' DESC, 
'Maximum Grade' DESC,
 s.firstname ASC, 
 s.lastname ASC;




