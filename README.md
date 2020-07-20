# kredivo


pre requisite 

1. restore all tables and data from :  https://github.com/datacharmer/test_db


2. folder sql : 

restore three tables 

    1. calendar => employees_calendar.sql
    2. emp_daily_absence => employees_emp_daily_absence.sql
    3. emp_leave => employees_emp_leave.sql

restore store procedure from employees_routines.sql,
there should be 6 store procedures : 

    1. sp_date_generator
    2. sp_employee_absence_generator
    3. sp_employee_age_avg
    4. sp_employee_avg_salary_title
    5. sp_employee_leave_generator
    6. sp_employee_salary_adjustment

3. Redis, install redis on your local computer because bull use redis.

to run the app : 

npm run start

rest api :

/queue => to generate random data

/report/avg-salary-title => report for average salary by title
/report/avg-age => report for average age of employee


