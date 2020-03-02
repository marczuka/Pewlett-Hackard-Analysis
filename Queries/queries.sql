-- Retirement eligibility --
SELECT COUNT (first_name)
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

SELECT first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

SELECT * from retirement_info;

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1953-01-01' AND '1953-12-31';

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1954-01-01' AND '1954-12-31';

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1955-01-01' AND '1955-12-31';

-- Recreating retirement_info table with employees grouped by department --
DROP TABLE retirement_info;

SELECT emp_no, first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

SELECT * FROM retirement_info;

-- Joining departments and dept_manager tables
SELECT departments.dept_name,
	dept_manager.emp_no,
	dept_manager.from_date,
	dept_manager.to_date
FROM departments INNER JOIN dept_manager
ON departments.dept_no = dept_manager.dept_no;

-- Joining retirement_info and dept_emp tables
SELECT retirement_info.emp_no,
	retirement_info.first_name,
	retirement_info.last_name,
	dept_emp.to_date
FROM retirement_info LEFT JOIN dept_emp
ON retirement_info.emp_no = dept_emp.emp_no;

SELECT ri.emp_no,
	ri.first_name,
	ri.last_name,
	de.to_date
INTO current_emp
FROM retirement_info AS ri 
LEFT JOIN dept_emp AS de
ON ri.emp_no = de.emp_no
WHERE de.to_date = '9999-01-01';

SELECT * FROM current_emp;

-- Retiring employee count by deptartment number
SELECT COUNT(ce.emp_no), de.dept_no
INTO retire_emp_by_dept
FROM current_emp AS ce
    LEFT JOIN dept_emp AS de
        ON ce.emp_no = de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no;

SELECT * FROM retire_emp_by_dept;

-- Salaries dates are not recent. Why?
SELECT * FROM salaries
ORDER BY to_date DESC;

-- List 1: Creating a list of retiring employees containing their 
-- unique employee number, their last name, first name, gender and salary
SELECT e.emp_no, e.first_name, 
	e.last_name, e.gender,
	s.salary, de.to_date
INTO emp_info
FROM employees AS e
    INNER JOIN salaries AS s
        ON (e.emp_no = s.emp_no)
    INNER JOIN dept_emp AS de
        ON (e.emp_no = de.emp_no)
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
    AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31')
    AND (de.to_date = '9999-01-01');

-- List 2: a list of managers for each department, including 
-- the department number, name, and the manager’s employee number, 
-- last name, first name, and the starting and ending employment dates
SELECT dm.dept_no,
	d.dept_name,
	dm.emp_no,
	ce.last_name,
	ce.first_name,
	dm.from_date,
	dm.to_date
INTO manager_info
FROM dept_manager AS dm
	INNER JOIN departments AS d
		ON (dm.dept_no = d.dept_no)
	INNER JOIN current_emp AS ce
		ON (dm.emp_no = ce.emp_no);	
		
SELECT * FROM manager_info;

-- The question "Why are there only five active managers for nine departments?"
-- is incorrect. There are active managers for all nine departments but only 
-- 5 people from the list of retiring persons were/are the active managers of 
-- departments at PH and only two of them are the active managers now. 
-- So only two managers are going to retire soon and need to be replaced.

-- List 3: An updated current_emp list that includes everything 
-- it currently has, but also the employee’s departments
-- (I want to see department number in this table too)
SELECT ce.emp_no,
	ce.first_name,
	ce.last_name,
	de.dept_no,
	d.dept_name
-- INTO dept_info
FROM current_emp AS ce
	INNER JOIN dept_emp AS de
		ON (ce.emp_no = de.emp_no)
	INNER JOIN departments AS d
		ON (de.dept_no = d.dept_no);

-- To answer the question why some employees appear twice in the List 3 we need 
-- to narrow our search for only the Departments they are currently employed at 
-- (because some of them might have switched the departments during their employment).
SELECT ce.emp_no,
	ce.first_name,
	ce.last_name,
	de.dept_no,
	d.dept_name
INTO dept_info
FROM current_emp AS ce
	INNER JOIN dept_emp AS de
		ON (ce.emp_no = de.emp_no)
	INNER JOIN departments AS d
		ON (de.dept_no = d.dept_no)
WHERE de.to_date = '9999-01-01';

