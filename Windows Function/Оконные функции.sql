--1. �������� ������ � ��������� �������� � ���������� ��� � ��������� ����������. �������� �����.
--� �������� ������� � ��������� �������� � ��������� ���������� ����� ����� ���� ������ ��� ��������� ������:
--������� ������ ����� ������ ����������� ������ �� ������� � 2015 ���� (� ������ ������ ������ �� ����� ����������, ��������� ����� � ������� ������� �������)
--�������� id �������, �������� �������, ���� �������, ����� �������, ����� ����������� ������
--������
--���� ������� ����������� ���� �� ������
--2015-01-29 4801725.31
--2015-01-30 4801725.31
--2015-01-31 4801725.31
--2015-02-01 9626342.98
--2015-02-02 9626342.98
--2015-02-03 9626342.98
--������� ����� ����� �� ������� Invoices.
--����������� ���� ������ ���� ��� ������� �������.

--������  ���������� ��������

drop table if exists #SumAscItog
; with cte as(
				select distinct	si.InvoiceId, 
								si.InvoiceDate, 
								si.CustomerID, 
								sc.CustomerName, 
				(select sum(ct.TransactionAmount)
					from Sales.Invoices i
						join Sales.CustomerTransactions ct on i.InvoiceID =	ct.InvoiceID
							where month(i.InvoiceDate) = month(si.InvoiceDate) and InvoiceDate >= '2015.01.01'
								group by month(i.InvoiceDate)) as SumAscItog
from Sales.Invoices AS si
	join Sales.Customers sc on si.CustomerID = sc.CustomerID
		where si.InvoiceDate >= '2015-01-01')

select * into #SumAscItog from cte
select * from #SumAscItog order by InvoiceID;

--������ � ��������� ����������

declare @SumAscItog table
(
	InvoiceID int not null,
	InvoiceDate date not null,
	CustomerID int not null,
	CustomerName nvarchar(100) not null,
	SumAscItog float not null
)
; with cte as(
				select distinct	si.InvoiceId, 
								si.InvoiceDate, 
								si.CustomerID, 
								sc.CustomerName, 
				(select sum(ct.TransactionAmount)
					from Sales.Invoices i
						join Sales.CustomerTransactions ct on i.InvoiceID =	ct.InvoiceID
							where month(i.InvoiceDate) = month(si.InvoiceDate) and InvoiceDate >= '2015.01.01'
								group by month(i.InvoiceDate)) as SumAscItog
from Sales.Invoices AS si
	join Sales.Customers sc on si.CustomerID = sc.CustomerID
		where si.InvoiceDate >= '2015-01-01')

insert into @SumAscItog select * from cte
select * from @SumAscItog order by InvoiceID;

--2. ���� �� ����� ������������ ���� ������, �� �������� ������ ����� ����������� ������ � ������� ������� �������.
--�������� 2 �������� ������� - ����� windows function � ��� ���. �������� ����� ������� �����������, �������� �� set statistics time on;

SELECT distinct si.InvoiceId, 
				si.InvoiceDate, 
				si.CustomerID, 
				sc.CustomerName, 
				(sum(ct.TransactionAmount) OVER (order by Month(InvoiceDate))) as SumAscItog
FROM Sales.Invoices AS si
	join Sales.Customers sc on si.CustomerID = sc.CustomerID
		join Sales.CustomerTransactions ct on si.InvoiceID = ct.InvoiceID
	WHERE si.InvoiceDate >= '2015-01-01'
		ORDER BY si.InvoiceId, si.InvoiceDate;

--3. ������� ������ 2� ����� ���������� ��������� (�� ���-�� ���������) � ������ ������ �� 2016� ��� (�� 2 ����� ���������� �������� � ������ ������)

	select * 
		from(select	si.StockItemID, 
					si.StockItemName, 
					il.Quantity, 
					i.InvoiceDate, 
					month (i.InvoiceDate) as monthh, 
					year (i.InvoiceDate) as yeaar,
					ROW_NUMBER() Over (Partition by i.InvoiceDate Order by il.Quantity Desc) as RowNumber
						from Sales.Invoices i
							 join Sales.InvoiceLines il on il.InvoiceID = i.InvoiceID
								join Warehouse.StockItems si on si.StockItemID = il.StockItemID
									where  year(i.InvoiceDate) = '2016' ) as tbl
			where  RowNumber <= 2
				order by month(InvoiceDate), year (InvoiceDate);

--4. ������� ����� ��������
--���������� �� ������� �������,
--� ����� ����� ������ ������� �� ������, ��������, ����� � ����
--������������ ������ �� �������� ������, ��� ����� ��� ��������� ����� �������� ��������� ���������� ������ +
--���������� ����� ���������� ������� � �������� ����� � ���� �� ������� +
--���������� ����� ���������� ������� � ����������� �� ������ ����� �������� ������ +
--���������� ��������� id ������ ������ �� ����, ��� ������� ����������� ������� �� ����� +
--���������� �� ������ � ��� �� �������� ����������� (�� �����) +
--�������� ������ 2 ������ �����, � ������ ���� ���������� ������ ��� ����� ������� "No items" +
--����������� 30 ����� ������� �� ���� ��� ������ �� 1 �� +
--��� ���� ������ �� ����� ������ ������ ��� ������������� �������

select StockItemID, StockItemName, Brand, UnitPrice,
	ROW_NUMBER() over(partition by left(StockItemName, 1) order by StockItemName) as 'Rownumber',
	count(QuantityPerOuter) over () as 'Count',
	count(QuantityPerOuter) over (order by left(StockItemName, 1)) as 'Count1',
	LEAD(StockItemID) over(order by StockItemName),
	LAG(StockItemID) over(order by StockItemName),
	LAG(StockItemName, 2, 'No Title') over(order by StockItemName) as 'No Title',
	NTILE(30) over(order by TypicalWeightPerUnit) as 'Ntile'
 from Warehouse.StockItems;

--5. �� ������� ���������� �������� ���������� �������, �������� ��������� ���-�� ������
--� ����������� ������ ���� �� � ������� ����������, �� � �������� �������, ���� �������, ����� ������

select *
 from (
		select o.SalespersonPersonID,
			   p.FullName,
			   o.CustomerID, 
			   c.CustomerName,
			   o.OrderDate, 
			   ol.Quantity * ol.UnitPrice as Total,
				ROW_NUMBER() over(partition by o.SalespersonPersonID order by o.OrderDate desc) as LastSalCust
			from Sales.Orders o
				join Sales.OrderLines ol on o.OrderID = ol.OrderID
					join Application.People p on o.SalespersonPersonID = p.PersonID
					join Sales.Customers c on o.CustomerID = c.CustomerID) as tabl
	where LastSalCust = 1;

--6. �������� �� ������� ������� 2 ����� ������� ������, ������� �� �������
--� ����������� ������ ���� �� ������, ��� ��������, �� ������, ����, ���� �������

select *
 from (select	i.CustomerID, 
				sc.CustomerName, 
				i.InvoiceID,
				ct.TransactionAmount,
				i.InvoiceDate,  
				row_number() over (partition by i.CustomerID order by ct.TransactionAmount) as CustTrans
			from Sales.Invoices i
				join Sales.Customers sc on i.CustomerID = sc.CustomerID			
					join Sales.CustomerTransactions as ct on i.InvoiceID = ct.TransactionAmount) as tabl
	where CustTrans <= 2
	 order by CustomerID, TransactionAmount desc