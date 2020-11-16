SET STATISTICS io, time on;


Select ord.CustomerID , det.StockItemID, SUM(det.UnitPrice) Summa, SUM(det.Quantity) Kolvo, COUNT(ord.OrderID) Zakaz
	FROM Sales.Orders AS ord
		JOIN Sales.OrderLines AS det
			ON det.OrderID = ord.OrderID
		JOIN Sales.Invoices AS Inv
			ON Inv.OrderID = ord.OrderID
		JOIN Sales.CustomerTransactions AS Trans
			ON Trans.InvoiceID = Inv.InvoiceID
		JOIN Warehouse.StockItemTransactions AS ItemTrans
			ON ItemTrans.StockItemID = det.StockItemID
	WHERE Inv.BillToCustomerID != ord.CustomerID
		AND (Select SupplierId
				FROM Warehouse.StockItems AS It
					Where It.StockItemID = det.StockItemID) = 12
				AND (SELECT SUM(Total.UnitPrice*Total.Quantity)
						FROM Sales.OrderLines AS Total
							Join Sales.Orders AS ordTotal
								On ordTotal.OrderID = Total.OrderID
						WHERE ordTotal.CustomerID = Inv.CustomerID) > 250000
				AND DATEDIFF(dd, Inv.InvoiceDate, ord.OrderDate) = 0
	GROUP BY ord.CustomerID, det.StockItemID
	ORDER BY ord.CustomerID, det.StockItemID

--SQL Server parse and compile time: 
--   CPU time = 0 ms, elapsed time = 0 ms.

-- SQL Server Execution Times:
--   CPU time = 1546 ms,  elapsed time = 1871 ms.

Select ord.CustomerID , det.StockItemID, SUM(det.UnitPrice) Summa, SUM(det.Quantity) Kolvo, COUNT(ord.OrderID) Zakaz
	FROM Sales.Orders AS ord
		inner merge JOIN Sales.OrderLines AS det
			ON det.OrderID = ord.OrderID
		inner JOIN Sales.Invoices AS Inv
			ON Inv.OrderID = ord.OrderID
		inner loop JOIN Sales.CustomerTransactions AS Trans
			ON Trans.InvoiceID = Inv.InvoiceID
		inner merge JOIN Warehouse.StockItemTransactions AS ItemTrans
			ON ItemTrans.StockItemID = det.StockItemID
	WHERE Inv.BillToCustomerID != ord.CustomerID
		AND (Select SupplierId
				FROM Warehouse.StockItems AS It
					Where It.StockItemID = det.StockItemID) = 12
				AND (SELECT SUM(Total.UnitPrice*Total.Quantity)
						FROM Sales.OrderLines AS Total
							Join Sales.Orders AS ordTotal
								On ordTotal.OrderID = Total.OrderID
						WHERE ordTotal.CustomerID = Inv.CustomerID) > 250000
				AND DATEDIFF(dd, Inv.InvoiceDate, ord.OrderDate) = 0
	GROUP BY ord.CustomerID, det.StockItemID
	ORDER BY ord.CustomerID, det.StockItemID
	--Option(force order)

--Warning: The join order has been enforced because a local join hint is used.
--SQL Server parse and compile time: 
-- CPU time = 46 ms, elapsed time = 59 ms.

-- SQL Server Execution Times:
-- CPU time = 8181 ms,  elapsed time = 2324 ms.

--�� ������� ���������� ������ ������, �.�. ������ � ����������� Hint-��, ���������� ������, ��� ��� ���.
--� ����� ��������� �������, ����������� ������ ������, ��� Hint-��, �.�. ���������� ����������� ����� 26% � 74%.

--��������� ������������ Option(force order)  -- �����, ��� � � Hint-���, ���������� �����������, �������� Hash Match, ��������� ���������� ������ ������� ����� 60 � 40% ����� ����������:
--SQL Server parse and compile time: 
--   CPU time = 109 ms, elapsed time = 177 ms.

-- SQL Server Execution Times:
--   CPU time = 1982 ms,  elapsed time = 1536 ms.
--SQL Server parse and compile time: 
--   CPU time = 0 ms, elapsed time = 0 ms.

--��� Option(for�e order) -- ��������� ������� merge, loop ����� ���� �����������, ��� �� ���� ������, �������� Hash Match, �� ��������� �������, ��� ����������� ���� �����.
--�� ���������� ������� � Hint-���, ������ ������ �������.