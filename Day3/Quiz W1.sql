use AdventureWorks2019;
--- Quiz W1

--- 1
select
	PersonType,
	case 
		PersonType
		when 'IN' then 'Individual Customer'
		when 'EM' then 'Employee'
		when 'SP' then 'Sales Person'
		when 'SC' then 'Sales Contact'
		when 'VC' then 'Vendor Contact'
		when 'GC' then 'General Contact'
	end 
	as PersonType,
	COUNT(persontype) as TotalPerson
from Person.Person 
group by PersonType

---2
select
	p.BusinessEntityID,
	concat(p.FirstName,' ',p.MiddleName,' ',p.LastName) as FullName,
	e.EmailAddress,
	pp.PhoneNumber,
	concat(a.AddressLine1,', ',a.City,', ',sp.Name,', ',cr.Name) as Address
from 
	Person.Person p 
	join Person.EmailAddress e on p.BusinessEntityID=e.BusinessEntityID
	join Person.PersonPhone pp on p.BusinessEntityID=pp.BusinessEntityID
	join Person.BusinessEntityAddress bea on p.BusinessEntityID=bea.BusinessEntityID
	join Person.Address a on bea.AddressID=a.AddressID
	join Person.StateProvince sp on a.StateProvinceID=sp.StateProvinceID
	join Person.CountryRegion cr on sp.CountryRegionCode=cr.CountryRegionCode
where cr.Name='United States'
order by p.BusinessEntityID


---3 
select 
	cr.CountryRegionCode,
	cr.Name as CountryName,
	p.PersonType,
	case 
		PersonType
		when 'IN' then 'Individual Customer'
		when 'EM' then 'Employee'
		when 'SP' then 'Sales Person'
		when 'SC' then 'Sales Contact'
		when 'VC' then 'Vendor Contact'
		when 'GC' then 'General Contact'
	end 
	as PersonTypeDesc,
	count(p.BusinessEntityID) as TotalPerson
from Person.Person p
	join Person.BusinessEntityAddress bea on p.BusinessEntityID=bea.BusinessEntityID
	join Person.Address a on bea.AddressID=a.AddressID
	join Person.StateProvince sp on a.StateProvinceID=sp.StateProvinceID
	join Person.CountryRegion cr on sp.CountryRegionCode=cr.CountryRegionCode
group by p.PersonType, cr.CountryRegionCode,cr.Name;

--- 4
with 
pbea as
( 
	select p.BusinessEntityID,bea.AddressID, p.PersonType from Person.Person p
	join Person.BusinessEntityAddress bea on p.BusinessEntityID=bea.BusinessEntityID
),
csa as(
	select cr.CountryRegionCode,cr.Name,a.AddressID from Person.CountryRegion cr
	join Person.StateProvince sp on cr.CountryRegionCode=sp.CountryRegionCode
	join Person.Address a on sp.StateProvinceID=a.StateProvinceID
)
select * from(
	select 
	ca.countryregioncode,
	ca.name,
	case pa.persontype
		when 'IN' then 'Individual Customer'
		when 'EM' then 'Employee'
		when 'SP' then 'Sales Person'
		when 'SC' then 'Sales Contact'
		when 'VC' then 'Vendor Contact'
		when 'GC' then 'General Contact'
	end as persontype,
		ca.AddressID
	from pbea pa join csa ca on pa.AddressID=ca.AddressID
) as d
pivot
(	
	count(AddressID) for persontype
	in([Individual Customer],[Employee],[Sales Person],[Sales Contact],[Vendor Contact],[General Contact])
)as p

--- 5
with 
de as(
	select ed.DepartmentID,d.Name,ed.BusinessEntityID
	from HumanResources.Department d 
	join HumanResources.EmployeeDepartmentHistory ed on d.DepartmentID=ed.DepartmentID
	),
pe as(
	select p.BusinessEntityID from Person.Person p
	join HumanResources.Employee e on p.BusinessEntityID=e.BusinessEntityID
	)
select de.DepartmentID,de.Name,COUNT(pe.BusinessEntityID)as TotalEmployee 
from de 
join pe on de.BusinessEntityID=pe.BusinessEntityID 
group by de.DepartmentID,de.Name

---6
select d.Name,s.Name as shiftname,edh.BusinessEntityID
from HumanResources.EmployeeDepartmentHistory edh
join HumanResources.Shift s on edh.ShiftID=s.ShiftID
join HumanResources.Department d on edh.DepartmentID=d.DepartmentID
order by edh.BusinessEntityID

select * from (
	select d.Name,
		s.Name as shiftname,
		edh.BusinessEntityID
	from HumanResources.EmployeeDepartmentHistory edh
	join HumanResources.Shift s on edh.ShiftID=s.ShiftID
	join HumanResources.Department d on edh.DepartmentID=d.DepartmentID

)as d
pivot(
	count(BusinessEntityID) for shiftname in ([Day],[Evening],[Night])
)as r


--7

select * from Purchasing.Vendor
select * from Purchasing.PurchaseOrderHeader order by Status

select * from 
(
	select
	v.AccountNumber,
	v.Name,
	case poh.Status
		when 1 then 'Pending'
		when 2 then 'Approved'
		when 3 then 'Rejected'
		when 4 then 'Completed'
		end as Status
	from Purchasing.Vendor v 
	 join Purchasing.PurchaseOrderHeader poh on v. BusinessEntityID=poh.VendorID
	
)as d
pivot(
	count(status) for Status in([Pending],[Approved],[Rejected],[Completed])
)as p order by Name


-- 8 
select p.BusinessEntityID from Person.Person p 
select s.CustomerID from Sales.Customer s

select* from(
	select 
		soh.CustomerID,
		CONCAT(p.FirstName,' ',p.MiddleName,' ',p.LastName) as CustomerName,
		case soh.Status
			when 1 then 'InProcess'
			when 2 then 'Approved'
			when 3 then 'BackOrdered'
			when 4 then 'Rejected'
			when 5 then 'Shipped'
			when 6 then 'Cancelled'
		end as status
		from Sales.SalesOrderHeader soh
		join Person.Person p on soh.CustomerID=p.BusinessEntityID
) as d
pivot(
	count(Status) for status in ([InProcess],[Approved],[BackOrdered],[Rejected],[Shipped],[Cancelled])
)as p
order by CustomerID

-- 9 Buat pivot query untuk menampilkan informasi category product yang dibeli oleh customer
-- Select
SELECT * FROM Person.Person
select * from Sales.Customer
select * from Sales.SalesOrderDetail
select * from Sales.SalesOrderHeader
select * from Production.Product
select * from Production.ProductSubcategory
select * from Production.ProductCategory

-- try to using join only

select concat(pr.FirstName,' ',pr.LastName)CustomerName, sod.SalesOrderID, p.Name
from Production.ProductCategory pc
	JOIN Production.ProductSubcategory psc on pc.ProductCategoryID=psc.ProductCategoryID
	JOIN Production.Product p on psc.ProductSubcategoryID=p.ProductSubcategoryID
	JOIN Sales.SalesOrderDetail sod on p.ProductID = sod.ProductID
	JOIN Sales.SalesOrderHeader soh on sod.SalesOrderID=soh.SalesOrderID
	JOIN Sales.Customer c on soh.CustomerID=c.CustomerID
	JOIN Person.Person pr on c.CustomerID=pr.BusinessEntityID

-- try PIVOT IT
select *
from (
    select
		sod.SalesOrderID,
		concat(pr.FirstName, ' ', pr.LastName) as CustomerName,
		pc.Name as Category
	from Production.ProductCategory pc
		JOIN Production.ProductSubcategory psc on pc.ProductCategoryID = psc.ProductCategoryID
		JOIN Production.Product p on psc.ProductSubcategoryID = p.ProductSubcategoryID
		JOIN Sales.SalesOrderDetail sod on p.ProductID = sod.ProductID
		JOIN Sales.SalesOrderHeader soh on sod.SalesOrderID = soh.SalesOrderID
		JOIN Sales.Customer c on soh.CustomerID = c.CustomerID
		JOIN Person.Person pr on c.CustomerID = pr.BusinessEntityID
) as d
PIVOT(
    COUNT(Category) for Category in ([Accessories],[Bikes],[Components],[Clothing])
)as p
where CustomerName BETWEEN 'Albert Martin' And 'Alejandro Chen';


-- 9 try to using with
with
pr as(
	select
		pc.name,
		p.ProductID
	from Production.ProductCategory pc
		join Production.ProductSubcategory psc on pc.ProductCategoryID=psc.ProductCategoryID
		join Production.Product p on psc.ProductSubcategoryID=p.ProductSubcategoryID
),
sa as(
	select
		sod.productid,
		so.CustomerID
	from Sales.SalesOrderDetail sod
		join Sales.SalesOrderHeader so on sod.SalesOrderID=so.SalesOrderID
		where so.[Status]=5
),
pe as
(
	select
		c.CustomerID,
		concat(p.FirstName,' ',p.LastName) CustomerName
	from Person.Person p
		join Sales.Customer c on p.BusinessEntityID=c.CustomerID
)
select *from (
	select
		pe.customerid,
		pe.customername as CustomerName,
		pr.name as category
	from pe
		join sa on pe.CustomerID=sa.CustomerID
		join pr on sa.productid=pr.productid	
)as d
pivot(
	count(category) for category in ([Accessories],[Bikes],[Components],[Clothing])
)as v
where CustomerName between 'Albert Martin' and 'Alejandro Chen'
ORDER by CustomerName

-- =================================================================================
--- 10
select 
    p.ProductID,
    p.Name,
    so.DiscountPct,
    Year(so.EndDate)DiscountYear,
    Month(so.EndDate)DiscountMonth
from Sales.SpecialOffer so
join Sales.SpecialOfferProduct sop on so.SpecialOfferID=sop.SpecialOfferID
join Production.Product p on sop.ProductID=p.ProductID
where so.[Type]<>'No Discount'

-- Try Pivot

select *
from (
    select
		p.ProductID,
		p.Name,
		so.DiscountPct,
		Year(so.StartDate)DiscountYear,
		case Month(so.StartDate)
        When 1 then 'January'
        When 2 then 'February'
        When 3 then 'March'
        When 4 then 'April'
        When 5 then 'May'
        When 6 then 'June'
        When 7 then 'July'
        When 8 then 'August'
        When 9 then 'September'
        When 10 then 'October'
        When 11 then 'November'
        When 12 then 'December'
    end as DiscountMonth
	from Sales.SpecialOffer so
		join Sales.SpecialOfferProduct sop on so.SpecialOfferID=sop.SpecialOfferID
		join Production.Product p on sop.ProductID=p.ProductID
	where so.[Type]<>'No Discount'
)as d
PIVOT(
    COUNT(DiscountMonth) for DiscountMonth in ([January],[February],[March],[April],[May],[June],[July],[August],[September],[October],[November],[December])
)as p
order BY DiscountYear DESC;
