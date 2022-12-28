use HumanResourcesDb
-- 1 informasi jumlah department di tiap regions
	select r.region_name,count(d.department_id) as jumlah_department
	from hr.regions r
	left join hr.countries c on r.region_id=c.region_id 
	left join hr.locations l on c.country_id=l.country_id 
	left join hr.departments d on l.location_id=d.location_id
	group by r.region_name

-- 2 informasi jumlah department tiap countries
	select c.country_name,count(d.department_id) as jumlah_department
	from hr.countries c
	join hr.locations l on c.country_id=l.country_id 
	join hr.departments d on l.location_id=d.location_id
	group by c.country_name

	
-- 3 informasi jumlah employee tiap department 
	select  d.department_name,d.department_id, count(e.employee_id) as jumlah_employee
	from hr.departments d
	join hr.employees e on d.department_id = e.department_id 
	group by d.department_name,d.department_id

-- 4 informasi jumlah employee tiap region
	select r.region_name,count(e.employee_id) as jumlah_employee
	from hr.regions r
	left join hr.countries c on r.region_id=c.region_id 
	left join hr.locations l on c.country_id=l.country_id 
	left join hr.departments d on l.location_id=d.location_id
	left join hr.employees e on d.department_id=e.department_id
	group by r.region_name

-- 5 informasi jumlah employee tiap countries
	select c.country_name, count(e.employee_id) as jumlah_employee
	from hr.countries c
	left join hr.locations l on c.country_id=l.country_id 
	left join hr.departments d on l.location_id=d.location_id
	left join hr.employees e on d.department_id=e.department_id
	group by c.country_name

-- 6 informasi salary tertinggi tiap department
	select d.department_id, department_name, MAX(e.salary) salary_tertinggi
	from hr.departments d left join hr.employees e
	on d.department_id = e.department_id
	group by d.department_id, department_name

-- 7 informasi salary terendah tiap department
	select d.department_id, department_name, MIN(e.salary) salary_terendah
	from hr.departments d left join hr.employees e
	on d.department_id = e.department_id
	group by d.department_id, department_name

-- 8 informasi salary rata-rata tiap department
	select d.department_id, department_name, AVG(e.salary) salary_rata_rata
	from hr.departments d JOIN hr.employees e
	on d.department_id = e.department_id
	group by d.department_id, department_name

-- 9 informasi jumlah mutasi pegawai tiap department
	select d.department_name, count(h.employee_id) jumlah_mutasi
	from hr.departments d left join hr.job_history h
	on d.department_id = h.department_id
	group by d.department_name
	order by jumlah_mutasi desc

	select * from hr.departments

	select * from hr.job_history

-- 10 informasi jumlah mutasi pegawai berdasarkan role-jobs
	select h.job_id, j.job_title, count(h.job_id) jumlah_mutasi_role_jobs
	from hr.job_history h join hr.jobs j
	on h.job_id=j.job_id
	group by h.job_id, j.job_title
	order by jumlah_mutasi_role_jobs desc

	select * from hr.jobs
 
-- 11 informasi jumlah employee yang sering dimutasi.
	select h.employee_id, e.first_name, count(h.employee_id) berapa_kali_employee_mutasi
	from hr.job_history h join hr.employees e
	on h.employee_id = e.employee_id
	group by h.employee_id, e.first_name
	having count(h.employee_id) >= (
		select MAX(t.berapa_kali_employee_mutasi) as maksimal_mutasi from (
			select h.employee_id, e.first_name, count(h.employee_id) berapa_kali_employee_mutasi
			from hr.job_history h 
			join hr.employees e	on h.employee_id = e.employee_id
			group by h.employee_id, e.first_name
		)t
	)

	select count(x.employee_id) as most_mutation_employees from (
		select h.employee_id, e.first_name, count(h.employee_id) berapa_kali_employee_mutasi
		from hr.job_history h join hr.employees e
		on h.employee_id = e.employee_id
		group by h.employee_id, e.first_name
		having count(h.employee_id) >= (
			select MAX(t.berapa_kali_employee_mutasi) as maksimal_mutasi from (
				select h.employee_id, e.first_name, count(h.employee_id) berapa_kali_employee_mutasi
				from hr.job_history h join hr.employees e
				on h.employee_id = e.employee_id
				group by h.employee_id, e.first_name)t
			)
	) x

	select count(x.employee_id) as most_mutation_employees from (
		select h.employee_id, count(h.employee_id) berapa_kali_employee_mutasi 
		from hr.job_history h join hr.employees e
		on h.employee_id = e.employee_id
		group by h.employee_id, e.first_name
		having count(h.employee_id) >= (
			select MAX(t.berapa_kali_employee_mutasi) as maksimal_mutasi from (
				select count(e.employee_id) berapa_kali_employee_mutasi
				from hr.job_history h join hr.employees e
				on h.employee_id = e.employee_id
				group by h.employee_id
			) t
		)
	) x

  -- 12 informasi jumlah employee berdasarkan role jobs-nya
  select j.job_title, count(e.employee_id)as jumlah_employee
  from hr.jobs j
  join hr.employees e on j.job_id=e.job_id
  group by j.job_title

  select * from hr.jobs

  -- 13 informasi employee paling lama bekerja di tiap department
  select d.department_id,d.department_name, e.first_name, e.last_name, e.hire_date from hr.employees e
  join hr.departments d on d.department_id = e.department_id
  where e.hire_date in(
	select min(hire_date) from
	hr.departments as d join hr.employees as e on d.department_id = e.department_id
	group by d.department_name
  )

  
  -- 14 informasi employee baru masuk kerja di tiap department
  select d.department_name, e.first_name, e.last_name, e.hire_date from hr.employees e
  join hr.departments d on d.department_id = e.department_id
  where e.hire_date in(
	select max(hire_date) from
	hr.departments as d join hr.employees as e on d.department_id = e.department_id
	group by d.department_name
  )

  -- 15 informasi lama bekerja tiap employee dalam tahun dan jumlah mutasi history nya
  select e.first_name, datediff(yy,e.hire_date,getdate()) as lama_bekerja, count(h.employee_id) as mutasi
  from hr.employees e
  left join hr.job_history h on e.employee_id = h.employee_id
  group by e.first_name,e.hire_date