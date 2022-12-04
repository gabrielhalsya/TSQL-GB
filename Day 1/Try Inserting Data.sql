--insert data into hr.countries

select * from hr.regions 

insert into hr.regions(region_name)
values ('asia');
select * from hr.regions 

-- mengabaikan set identity
set identity_insert hr.regions on;
insert into hr.regions(region_id,region_name) values(3,'africa')
set identity_insert hr.regions off;
select * from hr.regions 

--- delete row table regions
delete  from hr.regions
select * from hr.regions

-- reset identity column region_id
dbcc checkident('hr.regions',RESEED,0);
select * from hr.regions 

--insert ke table hr.countries
insert into hr.countries(country_id,country_name,region_id)
values('SG','Singapore',1)
select * from hr.countries 

