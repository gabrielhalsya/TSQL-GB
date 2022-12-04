select CategoryName,Description from Northwind.dbo.Categories


insert into sales.categories(cate_name, cate_description)
select CategoryName,Description from Northwind.dbo.Categories

select * from sales.categories

ALTER TABLE sales.customers  ADD cust_code nvarchar(5)
select * from sales.customers
select companyname, customerid from Northwind.dbo.Customers

insert into sales.customers(cust_name,cust_code)
select companyname, customerid from Northwind.dbo.Customers
 
select * from Northwind.dbo.shippers
select * from sales.shippers

insert into sales.shippers(ship_name,ship_phone)
select companyname,phone from Northwind.dbo.Shippers

y
select * from Northwind.dbo.Orders

alter table sales.orders add xcust_id nvarchar(5)
alter table sales.orders add xemployee_id nvarchar(5)

set identity_insert sales.orders on
insert into sales.orders(order_id,order_date,order_required_date,order_shipped_date,order_freight,order_ship_city,
	order_ship_address,order_ship_id,xcust_id,xemployee_id)
select orderid, orderdate,requireddate,shippeddate,freight,shipcity,shipaddress,shipvia,customerid, employeeid from Northwind.dbo.Orders
set identity_insert sales.orders off

update so set order_cust_id = (Select sc.cust_id from sales.customers sc where sc.cust_code = so.xcust_id)from sales.orders so

select * from sales.customers
select * from sales.orders
select * from Northwind.dbo.Customers
select * from hr.locations
alter table sales.customers add cust_city nvarchar(55)

update sc set cust_city = (select city from Northwind.dbo.customers where customerid=sc.cust_code) from sales.customers sc 

update cust set cust_location_id=(
select distinct l.location_id from hr.locations l where lower(l.city) like lower(concat('%',cust.cust_city,'%')))
from sales.customers cust

select* from sales.suppliers
select* from hr.locations

set identity_insert sales.suppliers on
insert into sales.suppliers(supr_id,supr_name,supr_contact_name)
select supplierid,companyname,contactname from northwind.dbo.suppliers;
set identity_insert sales.suppliers off

update ss set supr_city=(
select l.City from Northwind.dbo.Suppliers ns 
where ss.supr_id=ns.SupplierID)
from sales.suppliers ss

select distinct l.location_id from hr.locations l where lower(l.city) like lower(concat('%',cust.cust_city,'%'))

alter table sales.suppliers add supr_city nvarchar(250)




select* from sales.products
set identity_insert sales.products on
insert into sales.products(prod_id,prod_name,prod_quantity,prod_price,prod_in_stock,prod_on_order,prod_reorder_level,prod_discontinued,prod_cate_id,prod_supr_id)
select productid,productname,quantityperunit,unitprice,unitsinstock,unitsonorder,reorderlevel,discontinued,categoryid,supplierid
from northwind.dbo.products;
set identity_insert sales.products off

select*from sales.categories
select*from sales.customers

merge into sales.customers as tg
using
(select companyname, city,customerid from northwind.dbo.customers) src
on tg.cust_name=src.companyname
when matched then update set tg.cust_name=src.companyname
when not matched then insert(cust_name,cust_city,cust_code)
values(src.companyname,city,customerid);

select * from sales.orders_detail
select * from Northwind.dbo.[Order Details]

merge into sales.orders_detail as od
using(
select orderid,productid,unitprice,quantity,discount from Northwind.dbo.[Order Details]) src
on od.ordet_order_id = src.orderid
when matched then update set od.ordet_prod_id=src.productid
when not matched then 
insert(ordet_order_id,ordet_prod_id,ordet_price,ordet_quantity,ordt_discount)
values(orderid,productid,unitprice,quantity,discount);
