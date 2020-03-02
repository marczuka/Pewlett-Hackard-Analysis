# Pewlett-Hackard-Analysis
Creating a Postgres Database from the source CSV files and obtain retirement information using SQL queries.

## The Module Practice
To create the Postgress Database from CSV files we've created the <b><i>Queries/schema.sql</i></b> file.

The source employment information was contained in the following files in the <b>Data/</b> folder:
- <b>departments.scv</b> - worksheet contains department numbers and names.
- <b>employees.csv</b> - the worksheet contains employee number, birth date, first and last names, gender and hire date information.
- <b>dept_emp.csv</b> - the worksheet connects employees numbers with department numbers they work at within the from_date - to_date period of time.
- <b>dept_manager.scv</b> - the worksheet contains employee numbers of persons who were or currently are managers of the departments at PH within the from_date - to_date period of time.
- <b>salaries.csv</b> - the worksheet contains salaries for each employee number within the from_date - to_date period of time.
- <b>titles.csv</b> - the worksheet contains job titles for each employee number within the from_date - to_date period of time.

The <b><i>queries.sql</i></b> file was used to create outcome tables (and the CSV files) with the retirement information.

The outcome analysis files generated using SQL-queries:
- <b>retirement_info.csv</b> - list of employees born between '1952-01-01' and '1955-12-31' and been hired between '1985-01-01' 
and '1988-12-31'. All of them fullfil the retirement criteria but some of them have already left the company.
- <b>current_emp.csv</b> - list of all the employees currently working at PH and fulfilling the retirement criteria.
- <b>emp_info.csv</b> - the same list as <b>current_emp.csv</b> also containing gender and salary information about the retiring employees.
- <b>manager_info.csv</b> - list of persons going to retire soon who were or currently are managers of the departments in PH. 
Only two active managers are going to retire soon, the other three were managers before but have already left the managment positions.
- <b>dept_info.csv</b> - the same list as <b>current_emp.csv</b> with additional columns dept_no and dept_name.
- <b>retire_emp_by_dept.csv</b> - the list containing numbers of employees retiring soon from each department.
- <b>sales_info.csv</b> - the same information that is in <b>dept_info.csv</b> tailored for the Sales department only.
- <b>sales_develop_info.csv</b> - the same information that is in <b>dept_info.</b> tailored for the Sales and Development departments.

## The Challenge Assignment
