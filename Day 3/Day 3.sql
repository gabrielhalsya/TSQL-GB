-- try to solve again quiz day 1 no 11
select 
	d.department_id,
	d.department_name,
	min(hire_date)oldest_date_hire,
	count(1) total_employee
from hr.departments d join hr.employees e
on d.department_id= e.department_id
group by d.department_id,d.department_name

select e.department_id, d.department_name,e.employee_id,e.first_name,e.last_name,e.hire_date
from hr.employees e join hr.departments d on e.department_id=d.department_id
where hire_date in (
	select 
		min(hire_date)as oldest_date_hire
	from hr.departments d join hr.employees e
	on d.department_id= e.department_id
	group by d.department_id,d.department_name
)order by d.department_id



-- there is simple way knowing alias and create condition using WITH clause
with 
emps as(
	select e.department_id, d.department_name,e.employee_id,e.first_name,e.last_name,e.hire_date
	from hr.employees e join hr.departments d on e.department_id=d.department_id
),
seniors as(
	select d.department_id,min(e.hire_date)oldest_hire_date 
	from hr.employees e join hr.departments d on e.department_id=d.department_id
	group by d.department_id
)
select * from emps mp join seniors as s on mp.department_id=s.department_id
where mp.hire_date=s.oldest_hire_date order by mp.department_id


-- pagination
-- usually in mini project when pagination,all data are selectted first, then they pagination using code.
-- but in large project pegination applied in server.
select * from hr.employees

select * from hr.employees
order by employee_id
offset 0 rows fetch next 5 rows only

select * from hr.employees
order by employee_id
offset 5 rows fetch next 6 rows only



--- PIVOT TABLE
--- 4 PEOPLE HIRED BEFORE BOOTCAMP ENDS BECAUSE THIS
--- =================================================
select * from (
	select e.job_id,d.department_name,e.employee_id from hr.departments d
	join hr.employees e on d.department_id=e.department_id
	where d.department_id in(20,60,80)
)as t
pivot(
	count(employee_id) for department_name in ([Sales],[Marketing],[IT])
)

--===================================================

---PIVOT2

select * from hr.employees
use HumanResourcesDb
select * from(
	select 
		employee_id,
		year(hire_date)[Tahun],
		case month(hire_date)
			when 1 then 'Jan'
			when 2 then 'Feb'
			when 3 then 'Mar'
			when 4 then 'Apr'
			when 5 then 'May'
			when 6 then 'Jun'
			when 7 then 'Jul'
			when 8 then 'Aug'
			when 9 then 'Sep'
			when 10 then 'Oct'
			when 11 then 'Nov'
			when 12 then 'Dec'
		end as[Bulan] 
	from hr.employees
)as t
pivot(
	count(employee_id) for [Bulan]
	in ([Jan],[Feb],[Mar],[Apr],[May],[Jun],[Jul],[Aug],[Sept],[Oct],[Nov],[Dec])
)as p