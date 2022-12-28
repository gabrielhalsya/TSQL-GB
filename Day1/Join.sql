select * from hr.employees where salary>=7000 and salary<=9000 and department_id=80

--- create table from table
select top(5) employee_id,first_name,salary,department_id
into TableA
from hr.employees

select top(6) employee_id,first_name,salary,department_id
into TableB
from hr.employees

select * from TableA
select * from TableB

--- inner join using alias
select a.* from TableA as a join TableB as b on a.employee_id=b.employee_id

--- left/right join with alias attribute
select b.*,b.employee_id as EmpId
from TableA a right join TableB b
on b.employee_id=a.employee_id


--- countries & locations

select * from hr.countries
select * from hr.locations

select *
from hr.countries c left join hr.locations l
on c.country_id = l.country_id
where l.location_id is null

---mengecek

select distinct l.location_id
from hr.regions r join hr.countries c on r.region_id=c.region_id
join hr.locations l on c.country_id = l.country_id
where r.region_id=2

--- masukkan kesini (SUBQUERY MENGGUNAKAN IN JIKA HASIL SUBNYA LEBIH DARI 1)
select * from hr.departments d where d.location_id in(
select distinct l.location_id
from hr.regions r join hr.countries c on r.region_id=c.region_id
join hr.locations l on c.country_id = l.country_id
where r.region_id=2
)

--- agregat
select min(salary) as min_salary, max(salary) as max_salary
from hr.employees

select min(hire_date) as senior, max(hire_date) as fresh_graduate
from hr.employees

--- cara ambil date terttua tanpa ORDER = MENGGUNAKAN DENGAN OPERATOR SAMADENGAN(=)SUBQUERY DENGAN SYARAT HASIL SUBQUERY HARUS 1 RECORD
--- NAMUN JIKA LEBIH MAKA MENGGUNAKAN IN
select * from hr.employees where hire_date=(select min(hire_date) from hr.employees)


-- datetime
select employee_id,first_name,hire_date,year(hire_date) as tahun, month(hire_date) as bulan, day(hire_date) as tanggal,
datediff(YY,hire_date,getdate())as lama_tahun_kerja,
datediff(MM,hire_date,getdate())as lama_bulan_kerja,
datediff(DD,hire_date,getdate())as lama_hari_kerja
from hr.employees e

--- display total employee each department
select d.department_id,department_name,count(employee_id) as total_employee
from hr.departments d join hr.employees e on d.department_id=e.department_id
group by d.department_name,d.department_id
having count(employee_id)>=40
order by total_employee desc

-- sum total employee
select sum(total_employee)as total_emps from(
	select d.department_id,department_name,count(employee_id) as total_employee
	from hr.departments d join hr.employees e on d.department_id=e.department_id
	group by d.department_name,d.department_id
	having count(employee_id)>=5
)t

--- 11.Informasi jumlah employee yang sering dimutasi.


