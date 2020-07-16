--1 �������--
--�������� ����������� (Application.People), 
--������� �������� ������������ (IsSalesPerson), � �� ������� �� ����� ������� 04 ���� 2015 ����. 
--������� �� ���������� � ��� ������ ���. ������� �������� � ������� Sales.Invoices.

select AP.PersonID, AP.FullName 
 from Application.People AP  
  where  exists 
   (select * 
     from Sales.Invoices SI
	  where IsSalesPerson=1 and OrderID is null and SI.InvoiceDate = '2015-07-04' and AP.PersonID = SI.SalespersonPersonID)

--2 �������--
--�������� ������ � ����������� ����� (�����������). 
--�������� ��� �������� ����������. �������: �� ������, ������������ ������, ����.

select StockItemID, StockItemName, UnitPrice
 from Warehouse.StockItems
  where UnitPrice in (select Min(UnitPrice)
                        from Warehouse.StockItems)

select StockItemID, StockItemName, UnitPrice
 from Warehouse.StockItems
  where UnitPrice =All (select Min(UnitPrice)
                        from Warehouse.StockItems)

--3 �������--
--�������� ���������� �� ��������, ������� �������� �������� ���� ������������ �������� �� Sales.
--CustomerTransactions. ����������� ��������� �������� (� ��� ����� � CTE).
select CustomerID, FullName, PersonID
 from Sales.CustomerTransactions CT
  join Application.People AP on CT.LastEditedBy = AP.PersonID
   where TransactionAmount IN (select top 5 TransactionAmount
                                 from Sales.CustomerTransactions
                                   order by TransactionAmount desc)

select CustomerID, FullName, PersonID
 from Sales.CustomerTransactions CT
  join Application.People P on CT.LastEditedBy = P.PersonID
   where TransactionAmount =any (select top 5 TransactionAmount
                                 from Sales.CustomerTransactions
                                   order by TransactionAmount desc)

;with cteTOP5Customer as

     (
       select top 5 TransactionAmount
        from Sales.CustomerTransactions
         order by TransactionAmount desc
     ) 

select CustomerID, FullName, PersonID
 from Sales.CustomerTransactions CT
  join Application.People P on CT.LastEditedBy = P.PersonID
   where TransactionAmount IN (select *
                                from cteTOP5Customer)

;with cteTOP5Customer as

     (
       select top 5 TransactionAmount
        from Sales.CustomerTransactions
         order by TransactionAmount desc
     ) 

select CustomerID, FullName, PersonID
 from Sales.CustomerTransactions CT
  join Application.People P on CT.LastEditedBy = P.PersonID
   where TransactionAmount =any (select *
                                  from cteTOP5Customer)

--4 �������--
--�������� ������ (�� � ��������), � ������� ���� ���������� ������, 
--�������� � ������ ����� ������� �������, � ����� ��� ����������, 
--������� ����������� �������� ������� (PackedByPersonID).

select CityID, CityName, SI.PackedByPersonID, AP.FullName
 from Application.People AP
  Join Application.Cities AC
   On AC.LastEditedBy = AP.PersonID
  Join Sales.Invoices SI
   On SI.PackedByPersonID = AP.PersonID
  where exists (Select TOP 3 StockItemName, UnitPrice From Warehouse.StockItems Order By UnitPrice Desc) 
   Group by CityID, CityName, SI.PackedByPersonID, AP.FullName

--5 �������--
--�����������

;With cte (InvoiceId, TotalSumm) As

(

SELECT InvoiceId, SUM(Quantity*UnitPrice) AS TotalSumm
           FROM Sales.InvoiceLines
               GROUP BY InvoiceId
                  HAVING SUM(Quantity*UnitPrice) > 27000
)

SELECT 
       Invoices.InvoiceID,
        Invoices.InvoiceDate,
         AP.FullName AS SalesPersonName,
        SalesTotals.TotalSumm AS TotalSummByInvoice,
         (SELECT SUM(OrderLines.PickedQuantity*OrderLines.UnitPrice)
           FROM Sales.OrderLines
              WHERE OrderLines.OrderId = (SELECT Orders.OrderId
                                            FROM Sales.Orders
                                               WHERE Orders.PickingCompletedWhen IS NOT NULL
                                                 AND Orders.OrderId = Invoices.OrderId)) AS TotalSummForPickedItems
  FROM Sales.Invoices
   Join Application.People As AP
    On AP.PersonID = Invoices.SalespersonPersonID
   JOIN cte AS SalesTotals
     ON Invoices.InvoiceID = SalesTotals.InvoiceID
        ORDER BY TotalSumm DESC
