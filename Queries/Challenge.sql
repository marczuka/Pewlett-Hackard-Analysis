-------------------------
-- MODULE 7 CHALLENGE --
-------------------------
-- Number of [titles] retiring
-- Note: the table resulting from joining the titles table on 
-- the employees who are eligible for retirement table.  At this 
-- point there are duplicates due to multiple titles per employee..
SELECT ei.emp_no,
	ei.first_name,
	ei.last_name,
	t.title,
	t.from_date,
	ei.salary
INTO retire_titles
FROM emp_info AS ei
	INNER JOIN titles AS t
		ON (ei.emp_no = t.emp_no);

SELECT * FROM retire_titles;

-- Partition the data to show only most recent title per employee
SELECT twr.emp_no,
	twr.first_name,
	twr.last_name,
	twr.title,
	twr.from_date,
	twr.salary
INTO retire_recent_titles
FROM
  (SELECT *, ROW_NUMBER()
  	OVER
    (PARTITION BY emp_no ORDER BY from_date DESC) AS rn
  FROM retire_titles) AS twr
WHERE twr.rn = 1;

SELECT * FROM retire_recent_titles;

-- Counting the number of employees eligible for retire per title
SELECT title, COUNT(title)
INTO retire_emp_by_title
FROM retire_recent_titles
GROUP BY title;
 
SELECT * FROM retire_emp_by_title;

-- Creating a list of employees eligible for potential mentorship program
-- Their birth dates needs to be between January 1, 1965 and December 31, 1965
-- In the task it was unclear which from_date and to_date are asked for so
-- I've taken the employment dates: hire_date and the to_date of the most recent title.
SELECT e.emp_no,
	e.first_name,
	e.last_name,
	e.birth_date,
	t.title,
	e.hire_date AS from_date,
	t.to_date
INTO mentors
FROM employees AS e
	INNER JOIN dept_emp AS de
		ON (e.emp_no = de.emp_no)
	LEFT JOIN titles AS t
		ON (e.emp_no = t.emp_no)
WHERE (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
	AND de.to_date = '9999-01-01'
	AND t.to_date = '9999-01-01';  
	
SELECT * FROM mentors;
