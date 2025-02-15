-- Task 1.1 
Comments: To find all the required data I needed to combine 'product' table and 'productsubcategory' tables based
on ProductSubcategoryID column which is as primary key of 'productsubcategory table' and foreign key of
'product table'. I used alias to save space and to make sure that my code could be read better --

SELECT
  prod.ProductID,
  prod.Name,
  prod.ProductNumber,
  prod.Size,
  prod.Color, 
  prod.ProductSubcategoryId,
  prodsub.Name as SubCategory
FROM adwentureworks_db.product as prod
JOIN adwentureworks_db.productsubcategory as prodsub
    ON prod.ProductSubcategoryID = prodsub.ProductSubcategoryID
ORDER BY SubCategory;


-- Task 1.2
In order to add a category name I joined another table called 'productcategory' relating its' primary key 'ProductCategoryID'
with the same foreign key in 'productsubcategory' table. This way I could add 'Category' column to our existing table -- 

SELECT
  prod.ProductID,
  prod.Name,
  prod.ProductNumber,
  prod.Size,
  prod.Color, 
  prod.ProductSubcategoryId,
  prodsub.Name as SubCategory,
  prodcat.Name as Category
FROM adwentureworks_db.product as prod
JOIN adwentureworks_db.productsubcategory as prodsub
    ON prod.ProductSubcategoryID = prodsub.ProductSubcategoryID
JOIN adwentureworks_db.productcategory as prodcat
    ON prodsub.ProductCategoryID = prodcat.ProductCategoryID
ORDER BY Category;


-- Task 1.3
In this task I used 'WHERE' clause to filter by category name = 'Bikes', price listing more than 2000 and with no
'sellenddate', which is ultimately 'NULL' value in SQL database. These data could be
found in 'products' table. Then I sorted by 'ListPrice' in DESC order from most expensive bike to least expensive --

SELECT
  prod.ProductID,
  prod.Name,
  prod.ProductNumber,
  prod.Size,
  prod.Color, 
  prod.ProductSubcategoryId,
  prodsub.Name as SubCategory,
  prodcat.Name as Category,
  prod.ListPrice as Price_Listed
FROM adwentureworks_db.product as prod
JOIN adwentureworks_db.productsubcategory as prodsub
    ON prod.ProductSubcategoryID = prodsub.ProductSubcategoryID
JOIN adwentureworks_db.productcategory as prodcat
    ON prodsub.ProductCategoryID = prodcat.ProductCategoryID
WHERE prodcat.Name = 'Bikes' AND ListPrice > 2000 AND prod.SellEndDate IS NULL   -- Filtering my results--
ORDER BY ListPrice DESC;



-- Task 2.1 
I used 'LocationID' from 'workorderrouting' table as a base to GROUP BY required aggregations. 
COUNT (DISTINCT) selected - because I needed to count unique values (no duplicates).
Also I used 'WHERE' clause before GROUP BY because I needed to filter dates from non-aggragated data 
(I did not do any aggregations with dates). I selected the date of orders as 'ActualStartDate'
implementing 'BETWEEN-AND' command covering whole January --


SELECT
 LocationID,
 COUNT (DISTINCT WorkOrderID) as no_workorders,
 COUNT (DISTINCT ProductID) as no_unique_products,
 SUM (ActualCost) as actual_cost,
FROM adwentureworks_db.workorderrouting
WHERE ActualStartDate BETWEEN '2004-01-01' AND '2004-01-31'
 GROUP BY LocationID

-- Task 2.2
In this task I added function AVG and DATE_DIFF to know the average amount of days between 'ActualStartDate' and 
'ActualEndDate'. Also I added ROUND function to the result and narrowed the day difference to 2 decimal places.
If you've noticed I am not using one letter aliasing when working with tables, though aliasing helps me
to shrink the long names and make my code more readalbe I still choose more than one letter so I can 
understand which table I refer to in my calculations.--

SELECT
 wo_route.LocationID as LocationId,
 loc.Name as Location,
 COUNT (DISTINCT wo_route.WorkOrderID) as no_workorders,
 COUNT (DISTINCT wo_route.ProductID) as no_unique_products,
 SUM (wo_route.ActualCost) as actual_cost,
 ROUND (AVG (DATE_DIFF (wo_route.ActualEndDate,wo_route.ActualStartDate, day)), 2) as avg_days_diff  --here is the full clause for average date difference--
FROM adwentureworks_db.workorderrouting as wo_route
JOIN adwentureworks_db.location as loc
  ON wo_route.LocationID = loc.LocationID
WHERE ActualStartDate BETWEEN '2004-01-01' AND '2004-01-31'
 GROUP BY LocationId, location
ORDER BY LocationId;


Task 2.3
-- In this task I used WHERE clause to filter based on dates for month of Jan (non-aggregated data) 
and then HAVING clause to filter aggregated data - SUM of actual cost. Then grouping by WorkOrderID
which is a non-aggregated column. --


SELECT
 WorkOrderID,
 SUM (ActualCost) as actual_cost,
FROM `adwentureworks_db.workorderrouting`
WHERE ActualStartDate BETWEEN '2004-01-01' AND '2004-01-31'
GROUP BY
 WorkOrderID
HAVING SUM(ActualCost) > 300;

Task 3.1
-- I would suggest to make code more tidy first of all. I think 'specialofferproduct' table should not be included,
as 'modified date' columnt does not give us any valueable insights. Then obviously tupe of JOIN should be INNER JOIN,
not LEFT JOIN. Using INNER JOIN we connect list of orders to special offers, using LEFT JOIN we take ALL rows from
'salesorderdetail' table even if there is no overlapping with 'specialoffer' table so we have huge results span. --

SELECT 
 sales_detail.SalesOrderId,
 sales_detail.OrderQty,
 sales_detail.UnitPrice,
 sales_detail.LineTotal,
 sales_detail.ProductId,
 sales_detail.SpecialOfferID,
 spec_offer.Type,
 spec_offer.Category,
 spec_offer.Description

FROM adwentureworks_db.salesorderdetail as sales_detail
  JOIN adwentureworks_db.specialoffer as spec_offer
    ON sales_detail.SpecialOfferID = spec_offer.SpecialOfferID

ORDER BY LineTotal DESC;

--Task 3.1, 2nd option
To take things further and narrow our results
we could eliminate 'No Discount' Type which has 'SpecialOfferID' = 1,
so our query would look like that.--

SELECT 
 sales_detail.SalesOrderId,
 sales_detail.OrderQty,
 sales_detail.UnitPrice,
 sales_detail.LineTotal,
 sales_detail.ProductId,
 sales_detail.SpecialOfferID,
 spec_offer.Type,
 spec_offer.Category,
 spec_offer.Description

FROM adwentureworks_db.salesorderdetail  as sales_detail
  JOIN adwentureworks_db.specialoffer as spec_offer
    ON sales_detail.SpecialOfferID = spec_offer.SpecialOfferID
WHERE spec_offer.SpecialOfferID != 1

ORDER BY LineTotal DESC;


-- Task 3.2
Using analytical approach and subjective logic I would constract the basic information for vendors this way-
Starting from vendorID, name and address followed by information of employees. I use INNER JOIN/JOIN
to combine data in several tables to provide me with desired results. I did not
implement aliases to make sure that I am wasn't lost in joining different tables. 
The query provided as an example was a bit of a mess, which was very confusing by the
way it was written, aliasing appreaing in some cases but not fully, table columns in SELECT
mixed together etc. So, I've basically completely redone it to have a consistent and cohesive information.
I think it should look more in orderand legit this way. --

SELECT 
 vendor.VendorID,
 vendor.Name as Vendor_name,
 vendoraddress.AddressID,
 address.AddressLine1,
 address.City,
 address.PostalCode,
 contact.FirstName as Employee_FirstName,
 contact.LastName as Employee_LastName,
 contact.Emailaddress as Employee_Email,
 contact.Phone as Employee_Phone

FROM adwentureworks_db.vendor
JOIN adwentureworks_db.vendoraddress
   ON vendor.VendorID = vendoraddress.VendorID
JOIN adwentureworks_db.address
   ON vendoraddress.AddressID = address.AddressID
JOIN adwentureworks_db.vendorcontact
   ON vendor.VendorID = vendorcontact.VendorID
JOIN adwentureworks_db.contact
   ON vendorcontact.ContactID = contact.ContactID

ORDER BY VendorID;

