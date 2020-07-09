Use WideWorldImporters

--Задача 1--
--Select StockItemID, StockItemName
-- From Warehouse.StockItems
--  Where StockItemName = 'urgent' Or StockItemName Like 'Animal%'

--Задача 2--

--Select Distinct PS.SupplierID, SupplierName, Count(PurchaseOrderID) As Cnt
-- From Purchasing.Suppliers As PS
--  Join Purchasing.PurchaseOrders As PP
--   On PS.SupplierID = PP.SupplierID
--    Group by PS.SupplierID, SupplierName
--	 Having Count(PurchaseOrderID) = 0

--Задача 3--

--Select SO.OrderID,
--	   cast(SO.PickingCompletedWhen as date) As DatePicking,
--	   DateName(Month, SO.OrderDate) As NameMonth,
--	   DatePart(Quarter, SO.OrderDate) As NumberQuarter,
--	   SC.CustomerName
-- From Sales.Orders As SO
--  Join Sales.OrderLines As SOL
--   On SO.OrderID = SOL.OrderID
--    Join Sales.Customers AS SC
--	 On SO.CustomerID = SO.CustomerID
--    Where (UnitPrice > 100 Or Quantity > 20) And (SOL.PickingCompletedWhen is not null)
--	 Order By NumberQuarter, DatePicking
--	 Offset 1000 Rows Fetch Next 100 Rows Only

--Задача 4--

--Select Ad.DeliveryMethodName, 
--       PP.LastEditedWhen,
--	   PS.SupplierName,
--	   AP.FullName
-- From Purchasing.Suppliers As PS
--  Join Application.DeliveryMethods As AD
--   On PS.DeliveryMethodID = AD.DeliveryMethodID
--    Join Purchasing.PurchaseOrders As PP
--	 On PS.SupplierID = PP.SupplierID
--	  Join Application.People As AP
--	    On PS.LastEditedBy = AP.LastEditedBy
--	  Where LastEditedWhen between '20140101 00:00:00' And '20140131 23:59:59' Or
--	   (AD.DeliveryMethodName = 'Air Freight' or AD.DeliveryMethodName = 'Refrigerated Air Freight')
	   
--Задача 5--

--Select PickingCompletedWhen AS Date, 
--       SC.CustomerName, 
--	   SO.SalespersonPersonID,
--	   AP.FullName
-- From Sales.Orders SO
--  Join Sales.Customers SC
--   On SO.CustomerID = SC.CustomerID
--    Join Application.People As AP
--	 On SC.LastEditedBy = AP.LastEditedBy
--      Order By PickingCompletedWhen
--       Offset 73585 Rows Fetch Next 10 Rows Only

--Задача 6--

--Select CustomerID, CustomerName, SC.PhoneNumber
-- From Sales.Customers As SC