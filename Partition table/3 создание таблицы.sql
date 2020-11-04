--то же самое для второй таблицы
CREATE TABLE [Sales].[OrdersYears](
	[OrderID] [int] NOT NULL,
	[CustomerID] [int] NOT NULL,
	[SalespersonPersonID] [int] NOT NULL,
	[PickedByPersonID] [int] NULL,
	[ContactPersonID] [int] NOT NULL,
	[BackorderOrderID] [int] NULL,
	[OrderDate] [date] NOT NULL,
	[ExpectedDeliveryDate] [date] NOT NULL,
	[CustomerPurchaseOrderNumber] [nvarchar](20) NULL,
	[IsUndersupplyBackordered] [bit] NOT NULL,
	[Comments] [nvarchar](max) NULL,
	[DeliveryInstructions] [nvarchar](max) NULL,
	[InternalComments] [nvarchar](max) NULL,
) ON [schmOrderYearPartition]([OrderDate])
GO

ALTER TABLE [Sales].[OrdersYears] ADD CONSTRAINT PK_Sales_OrdersYears 
PRIMARY KEY CLUSTERED  (OrderDate, OrderId)
 ON [schmOrderYearPartition]([OrderDate]);

 --второй вариант - на существующей таблице удалить кластерный индекс 
 -- и создать новый кластерный индекс с ключом секционирования

 select min(OrderDate), max(OrderDate)
 FROM Sales.Orders