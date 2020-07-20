-- MySQL dump 10.13  Distrib 8.0.21, for Win64 (x86_64)
--
-- Host: localhost    Database: employees
-- ------------------------------------------------------
-- Server version	8.0.21

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Dumping routines for database 'employees'
--
/*!50003 DROP PROCEDURE IF EXISTS `sp_date_generator` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_date_generator`()
BEGIN

DECLARE last_date, end_date date; 

CREATE TABLE IF NOT EXISTS calendar(
dates date
);


SET last_date = (SELECT dates FROM calendar ORDER BY dates DESC LIMIT 1 );
IF last_date IS NULL 
THEN
	SET last_date = '2020-01-01';
END IF;

SET end_date = date_add(last_date, INTERVAL 10 YEAR);

INSERT INTO calendar(dates)
select * from
    (select adddate('1970-01-01',t4*10000 + t3*1000 + t2*100 + t1*10 + t0) gen_date from
    (select 0 t0 union select 1 union select 2 union select 3 union select 4 union select 5 union select 6 union select 7 union select 8 union select 9) t0,
    (select 0 t1 union select 1 union select 2 union select 3 union select 4 union select 5 union select 6 union select 7 union select 8 union select 9) t1,
    (select 0 t2 union select 1 union select 2 union select 3 union select 4 union select 5 union select 6 union select 7 union select 8 union select 9) t2,
    (select 0 t3 union select 1 union select 2 union select 3 union select 4 union select 5 union select 6 union select 7 union select 8 union select 9) t3,
    (select 0 t4 union select 1 union select 2 union select 3 union select 4 union select 5 union select 6 union select 7 union select 8 union select 9) t4) v
    Where gen_date between last_date and end_date
order by gen_date;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_employee_absence_generator` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_employee_absence_generator`(emp_no_start INT, emp_no_end INT)
BEGIN

INSERT INTO emp_daily_absence (emp_no,start_date,end_date,break_time)
SELECT a.emp_no, 
concat(b.dates, ' ' , concat(FLOOR( RAND() * (11 - 8 + 1) + 8), '', ':00:00')), 
concat(b.dates, ' ' , concat(FLOOR( RAND() * (20 - 17 + 1) + 17), '', ':00:00')),
FLOOR( RAND() * (90 - 30 + 1) + 30)
FROM employees a
INNER JOIN ( 
			SELECT * 
            FROM calendar 
            WHERE dates BETWEEN curdate() AND date_add(curdate(), INTERVAL 3 MONTH)) b ON a.birth_date <= b.dates
WHERE a.emp_no BETWEEN emp_no_start AND emp_no_end;


END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_employee_age_avg` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_employee_age_avg`()
BEGIN

declare total_emp int;
set total_emp = (select count(emp_no) from employees);

select a.age, count(a.age) / total_emp  as total from (
select timestampdiff(YEAR, birth_date, curdate()) as age 
from employees
) a
group by a.age
order by a.age;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_employee_avg_salary_title` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_employee_avg_salary_title`(emp_no_start int, emp_no_end int)
BEGIN
select b.title, avg(c.salary) as avg_salary from employees a
inner join titles  b on a.emp_no = b.emp_no and b.to_date = '9999-01-01'
inner join salaries c on c.emp_no = a.emp_no and c.to_date = curdate()
where a.emp_no between emp_no_start and emp_no_end
group by b.title;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_employee_leave_generator` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_employee_leave_generator`(emp_no_start int, emp_no_end int)
BEGIN

INSERT INTO emp_leave(emp_no,start_date,end_date,`type`)
SELECT emp_no, curdate(), date_add(curdate(), INTERVAL 3 MONTH),
	CASE 
		WHEN gender = 'M' THEN elt(0.5 + rand() * 3, 'Annual', 'Sick', 'Unpaid') 
        WHEN gender = 'F' THEN elt(0.5 + rand() * 4, 'Annual', 'Sick', 'Maternity', 'Unpaid')
        END
FROM employees
WHERE emp_no BETWEEN emp_no_start and emp_no_end;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_employee_salary_adjustment` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_employee_salary_adjustment`(emp_no_start int, emp_no_end int)
BEGIN

insert into salaries(emp_no, salary, from_date,to_date)
select 		b.emp_no, 
			s.salary + (s.salary * (b.working_hour_increment + b.break_time_increment) * 0.01) as new_salary,
			curdate(), 
			'9999-01-01' 
from (
select a.emp_no, 
case when a.working_hour_avg > cast(8 as decimal) and a.working_hour_avg <= cast(12 as decimal) then 5 
 when a.working_hour_avg > cast(7 as decimal) and a.working_hour_avg <= cast(8 as decimal) then 2.5 
 when a.working_hour_avg > cast(5 as decimal) and a.working_hour_avg <= cast(7 as decimal) then 0.5 
 when a.working_hour_avg < cast(5 as decimal) then 0 end 
 
as working_hour_increment,
case when a.break_time_avg > cast(60 as decimal) then -1 else 0 end as break_time_increment ,
case 
when a.title = 'Senior Engineer' then 3
when a.title = 'Staff' then 1
when a.title = 'Engineer' then 2
when a.title = 'Assistant Engineer' then 2.5
when a.title = 'Technique Leader' then 4
else 1000
end as title_increment

from (
select 
a.emp_no, avg(timestampdiff(hour,a.start_date,a.end_date)) as working_hour_avg ,
avg(a.break_time) as break_time_avg,
c.title
from emp_daily_absence a
left join emp_leave b on a.emp_no = b.emp_no
inner join titles c on c.emp_no = a.emp_no and c.to_date = '9999-01-01'
where a.emp_no between emp_no_start and emp_no_end

group by a.emp_no, c.title
) a
) b
inner join salaries s on s.emp_no = b.emp_no and s.to_date = '9999-01-01'
where not exists (
 select emp_no, from_date from salaries 
where emp_no between emp_no_start and emp_no_end
 
);

update salaries a
inner join (
select * from (
select *,RANK() OVER (PARTITION BY
                     emp_no
                 ORDER BY
                     salary ASC
                ) salary_rank 
from salaries
where emp_no between emp_no_start and emp_no_end and from_date <> curdate() and to_date = '9999-01-01'

order by emp_no, from_date 
) a
where a.salary_rank = 1
) b 
on a.emp_no = b.emp_no and a.salary = b.salary and a.from_date = b.from_date and a.to_date = b.to_date
set a.to_date = curdate();

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2020-07-20 17:42:08
