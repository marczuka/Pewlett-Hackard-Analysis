# Pewlett-Hackard-Analysis
Creating a Postgres Database from the source CSV files and obtaining retirement information using SQL queries.

## The Source Files
The source employment information was contained in the following files in the <b>Data/</b> folder:
- <b>departments.scv</b> - worksheet contains department numbers and names.
- <b>employees.csv</b> - the worksheet contains employee number, birth date, first and last names, gender and hire date information.
- <b>dept_emp.csv</b> - the worksheet connects employees numbers with department numbers they work at within the from_date - 
to_date period of time.
- <b>dept_manager.scv</b> - the worksheet contains employee numbers of persons who were or currently are managers of the 
departments at PH within the from_date - to_date period of time.
- <b>salaries.csv</b> - the worksheet contains salaries for each employee number within the from_date - to_date period of time.
- <b>titles.csv</b> - the worksheet contains job titles for each employee number within the from_date - to_date period of time.

## The Entity Relationship Diagram (ERD)
To present the tables in our database and the relationships between them we've created an ERD diagram using QuickDBD online tool:

![alt text](https://github.com/marczuka/Pewlett-Hackard-Analysis/blob/master/EmployeeDB.png "Database ERD")

This diagram presents 6 tables coresponding to 6 sourse CSV files. For each table the following information is presented: 
table name, column names, column data types, primary key (optional) and relationship with the other tables in the database.

Table <b>Departments</b> has a primary key - dept_no column. Tables <b>Employees</b> and <b>Salaries</b> have primary keys - 
column emp_no. 
I don't agree with the description in the module that dept_no is a primary key for the <b>Dept_manager</b> table because at 
different times the department can have different managers so the dept_no may appear in several rows. The primary key for the
<b>Dept_manager</b> table is a composite key dept_no + emp_no.
Dept_no IS NOT a primary key for <b>Dept_emp</b> table because one department can have many employees so one dept_no appears 
in many rows. The primary key for the <b>Dept_emp</b> table is a composite key dept_no + emp_no.
I also don't agree that emp_no is a primary key for the <b>Titles</b> table because one emp_no may appear in many rows 
(at different times one employee had different titles). The primary key for the <b>Titles</b> table would be a composite key
emp_no + from_date (or + to_date).

Table <b>Departments</b> has ONE-TO-MANY relationship with the <b>Dept_emp</b> and the <b>Dept_manager</b> tables. There may be 
many employees in one department and there may be many managers for the one department.

Table <b>Employees</b> has ONE-TO-MANY relationship with the <b>Dept_emp</b>, the <b>Dept_manager</b> and <b>Titles</b> tables: 
one employee may change departments during their career, one employee may be a manager of different departments at different periods 
of time and one employee may have many different titles during there employment period. 

There should be also ONE-TO-MANY relationship between the <b>Employees</b> and the <b>Salaries</b> tables but somehow there is only
one salary value for each employee so the relationship is ONE-TO-ONE.

## The Postgress Database
To create the Postgress Database from CSV files we've created the <b><i>Queries/schema.sql</b></i> file.

The <b><i>Queries/queries.sql</i></b> file was used to create outcome tables (and the CSV files) with the retirement information.

The outcome analysis files generated using SQL-queries:
- <b>retirement_info.csv</b> - list of employees born between '1952-01-01' and '1955-12-31' and been hired between '1985-01-01' 
and '1988-12-31'. All of them fullfil the retirement criteria but some of them have already left the company.
- <b>current_emp.csv</b> - list of all the employees currently working at PH and fulfilling the retirement criteria.
- <b>emp_info.csv</b> - the same list as <b>current_emp.csv</b> also containing gender and salary information about the 
retiring employees.
- <b>manager_info.csv</b> - list of persons going to retire soon who were or currently are managers of the departments in PH. 
Only two active managers are going to retire soon, the other three were managers before but have already left the managment positions.
- <b>dept_info.csv</b> - the same list as <b>current_emp.csv</b> with additional columns dept_no and dept_name.
- <b>retire_emp_by_dept.csv</b> - the list containing numbers of employees retiring soon from each department.
- <b>sales_info.csv</b> - the same information that is in <b>dept_info.csv</b> tailored for the Sales department only.
- <b>sales_develop_info.csv</b> - the same information that is in <b>dept_info.</b> tailored for the Sales and Development departments.

## The Challenge Assignment
The <b><i>Queries/Challenge.csv</b></i> file contains Postgres SQL queries to obtain the additional information requested 
by PH managment.

The following query returns the list of current employees eligible for retirement together with their titles:
<img src="https://github.com/marczuka/Pewlett-Hackard-Analysis/blob/master/Images/Query_1.png" width="300">

To obtain the information we join the <b>emp_info</b> table with the <b>titles</b> table on the common column emp_no. However some
employee names appear twice or even more times in the result table: that's because one employee might have had several titles 
during thier career:
<img src="https://github.com/marczuka/Pewlett-Hackard-Analysis/blob/master/Images/outcome_1.png">

To keep only the current titles for each retiring employee we use the following query:
<img src="https://github.com/marczuka/Pewlett-Hackard-Analysis/blob/master/Images/Query_2.png" width="600">

The nested SELECT query partitions the the <b>retire_titles</b> table into groups by emp_no, sorts rows in each group descending 
by the from_date and gives each row the count number. In the outer SELECT query we choose only the first row from each group 
(i.e. the row with the latest from_date):
<img src="https://github.com/marczuka/Pewlett-Hackard-Analysis/blob/master/Images/outcome_2.png">

Counting the rows in this table we get the number of employees eligible for retirement - <b>33,118 employees</b>. 

To obtain the number of retiring employees for each title we use the following query:
<img src="https://github.com/marczuka/Pewlett-Hackard-Analysis/blob/master/Images/Query_3.png" width="600">

This query groups rows in the <b>retire_recent_titles</b> table by the title and counts number of rows in each group. 
Here is the outcome:

<img src="https://github.com/marczuka/Pewlett-Hackard-Analysis/blob/master/Images/outcome_3.png" width="400">

The following query is used to pick out the potential mentors for the new employees coming to replace the retiring staff:
<img src="https://github.com/marczuka/Pewlett-Hackard-Analysis/blob/master/Images/Query_4.png" width="600">

To obtain the information about potential mentors we join <b>employees</b> table for the personal information, <b>dept_emp</b> 
table for the to_date and the <b>titles</b> table for the job titles on the common field emp_no. The candidates need to born 
between January 01 of 1965 and December 31 of 1965. We also need to narrow the search to the employees currently working at the 
PH (i.e. to_date = '9999-01-01'). 
Here is the result:

<img src="https://github.com/marczuka/Pewlett-Hackard-Analysis/blob/master/Images/outcome_4.png">

Counting rows in the result table we get the number of potential mentors for the new employees - <b>1,549</b> persons.

The outcome analysis files generated using SQL-queries:
- <b>retire_titles.csv</b> - the worksheet contains employee numbers, first and last names, job titles, starting dates of the job titles and salaries for all the employees eligible for retirement;
- <b>retire_recent_titles.csv</b> - the worksheet contains employee numbers, first and last names, MOST RECENT job titles, starting dates of the job titles and salaries for all the employees eligible for retirement;
- <b>retire_emp_by_title.csv</b> - the worksheet contains numbers of retiring employees per each title;
- <b>mentors.csv</b> - the worksheet contains employee numbers, first and last names, titles, birth dates and employment dates (hire_date and the to_date) for the potential mentors.

## Challenge Assignment Summary
The Pewlett Hackard company currently has <b>33,118</b> employees eligible for retirement so the company needs to hire the same 
number of new employees to replace the retiring staff.

The PH company gonna need the following specialists:
- <b>2,711</b> new Engineers;
- <b>13,651</b> new Senior Engineers;
- <b>251</b> new Assistant Engineers;
- <b>2</b> new Managers;
- <b>2,022</b> new Staff employees;
- <b>12,872</b> new Senior Staff employees;
- <b>1,609</b> new Technique Leaders.

The company currently has <b>1,549</b> employees eligible for the mentorship program. Thus the company currently has
1 potential mentor per 22 new employees which seems to be a reasonable ratio.

I would recommend to count number of potential mentors for each title to see if the number of possible mentors per job title 
corresponds with the number of new employees hired for each position. We could also calculate the number of potential mentors
per each department to see if the number of possible mentors per department corresponds to the number of new employees per 
department.
