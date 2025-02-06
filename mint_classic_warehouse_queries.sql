use mintclassics;


-- product
select count(*) from products;

-- No.of ware houses
select * from warehouses;

-- No. of products from each warehouse
select warehousecode, count(productname)
from products
group by warehousecode;


-- Productline
select * from productlines;


-- orders
select count( distinct ordernumber) from orders;
select count(distinct orderNumber) from orderdetails;

select orderlinenumber, count(ordernumber)
from orderdetails 
group by orderlinenumber;


-- no.of orders accounding to the warehouse that the order product belongs to.
select warehousecode, count(distinct od.ordernumber)
from orderdetails od  
join products p on od.productcode = p.productcode
group by warehousecode;


-- Creating a view with name as PRODUCTS_ORDERED
create view products_ordered as
	select p.productname, p.productline,p.buyprice, od.quantityordered, od.priceeach, o.OrderDate, p.warehousecode
	from orders o
	join orderdetails od on o.ordernumber = od.ordernumber
	join products p on p.productcode = od.productcode;
    
 select * from products_ordered;


-- Total_profit
select sum(quantityOrdered*(priceEach-buyprice))/1000000 as profit_in_million
from products_ordered;

-- Total_profit_percentage per order according to productline and warehouse
select warehousecode, productline, 
	   sum(quantityOrdered*(priceEach-buyprice))/(select sum(quantityOrdered*(priceEach-buyprice))from products_ordered)*100 as profit_percentage
from products_ordered
group by productline, warehousecode
order by warehousecode;


-- Total sales value
select sum(quantityordered*priceeach) as total_sales
from products_ordered;

-- Total_sales_value, total_sales_percentage according to productline and warehouse
select warehousecode, productline, 
	   sum(quantityordered) as inventorySold,
	   sum(quantityordered *priceeach)/1000000 as sales,
	   (sum(quantityordered * priceEach)/(select sum(quantityordered*priceeach) as total_sales
										from products_ordered))*100   as sales_percentage
from products_ordered 
group by productline, warehouseCode
order by warehousecode;


-- Total quantity of the orders
select sum(quantityordered) from products_ordered;

-- total_orders, total_orders_percentage according to productline and warehouse
select warehousecode,productLine,sum(quantityOrdered)/1000 as order_quantity, round((sum(quantityordered)/(select sum(quantityordered) from products_ordered)*100),4) as order_total_percentage
from products_ordered
group by productLine, warehousecode
order by warehousecode;

-- total_sales per order according to productline and warehouse
select warehousecode, productline, sum(quantityOrdered*priceEach)/sum(quantityordered) as sales_per_order
from products_ordered
group by productline, warehousecode
order by warehousecode;


-- Total_stocks and Space avalibility
select w.warehouseCode,sum(quantityInStock) as total_stock, (100-warehousePctCap) as SpaceAvalibility
from products p
join warehouses w on p.warehousecode = w.warehousecode
group by w.warehouseCode, w.warehousePctCap;


-- distinct customers that order products from each warehouse
select p.warehousecode, count(distinct c.customerNumber) as count_of_customers
from orders o
join orderdetails od on o.ordernumber = od.ordernumber
join products p on od.productcode = p.productcode
join customers c on o.customerNumber = c.customerNumber
group by p.warehousecode;

                                    
-- year wise orderdetails
select year(orderDate), productline, sum(quantityOrdered)
from orders o
join orderdetails od on o.orderNumber = od.orderNumber
join products p on od.productCode = p.productCode
group by year(orderDate), productLine;



