create table hr.regions(
	region_id int identity,
	region_name nvarchar(25) default null
	constraint pk_region_id primary key(region_id)
);

create table hr.countries(
	country_id char(2),
	country_name nvarchar(40) default null,
	region_id int not null
	constraint pk_country_id primary key(country_id)
	constraint fk_region_id foreign key(region_id) references hr.regions(region_id) on delete cascade on update cascade
);

select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS

alter table hr.countries
add constarint uq_country_name references hr.countries(country_name)


create table hr.locations(
	location_id int identity(1,1),
	street_address nvarchar(40),
	postal_code nvarchar(12),
	city nvarchar(30),
	country_id char(2),
	state_province nvarchar(25)
	constraint pk_location_id primary key(location_id),
	constraint fk_country_id foreign key(country_id) references hr.countries(country_id) on delete cascade on update cascade
);
select * from hr.countries

create table hr.departments(
department_id int identity(1,1),
department_name nvarchar(30) default null,
location_id int not null
constraint pk_department_id primary key(department_id)
constraint fk_location_id foreign key(location_id) references hr.locations(location_id) on delete cascade on update cascade
);

create table hr.jobs(
job_id nvarchar(10),
job_title nvarchar(35),
min_salary decimal(8,2),
max_salary decimal(8,2)
constraint uq_job_title unique(job_title),
constraint pk_job_id primary key(job_id)
);

create table hr.employees(
employee_id int identity(1,1),
first_name nvarchar(20),
last_name nvarchar(25),
email nvarchar(25),
phone_number nvarchar(20),
hire_date datetime,
salary decimal(8,2),
commission_pct decimal(2,2),
job_id nvarchar(10) not null,
department_id int,
manager_id int,
constraint pk_employee_id primary key(employee_id),
constraint fk_job_id foreign key(job_id) references hr.jobs(job_id) on delete cascade on update cascade,
constraint fk_department_id foreign key(department_id) references hr.departments(department_id) on delete cascade on update cascade,
constraint fk_manager_id foreign key(manager_id) references hr.employees(employee_id)
);

create table hr.job_history(
employee_id int,
start_date datetime,
end_date datetime,
job_id nvarchar(10),
department_id int,
constraint pk_employee_id_start_date primary key(employee_id,start_date)
);

alter table hr.job_history alter column job_id nvarchar(10)

delete from hr.employees
dbcc checkident('hr.employees',RESEED,0)

select * from hr.jobs
select * from hr.employees
select * from hr.countries
select * from hr.departments
select * from hr.job_history
select * from hr.locations
select * from hr.regions