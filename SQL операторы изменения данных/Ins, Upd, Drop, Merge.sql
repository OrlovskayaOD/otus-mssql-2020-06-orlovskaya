--1. Довставлять в базу 5 записей используя insert в таблицу Customers или Suppliers

insert into Sales.Customers
 ([CustomerID], [CustomerName],[BillToCustomerID],[CustomerCategoryID],[PrimaryContactPersonID],
  [DeliveryMethodID],[DeliveryCityID],[PostalCityID],[CreditLimit],[AccountOpenedDate],[StandardDiscountPercentage],[IsStatementSent],
  [IsOnCreditHold],[PaymentDays],[PhoneNumber],[FaxNumber],[WebsiteURL],[DeliveryAddressLine1],
  [DeliveryAddressLine2],[DeliveryPostalCode],[PostalAddressLine1],[PostalPostalCode],
  [LastEditedBy])

values
        (next value for [Sequences].[CustomerID], 'Olga Volkova', next value for [Sequences].[CustomerID], 4, 1001, 3, 10483, 10483, 1600, 
        getdate(), 0, 0, 0, 7, '(205) 555-0100', '(205) 555-0101', 'http://www.microsoft.com/', 
		'Shop 5', '105 Jitka Street', '90069', 'PO Box 13', '90073', 1)
		(next value for [Sequences].[CustomerID], 'Den Avramenko', next value for [Sequences].[CustomerID], 3, 1003, 1, 10484, 10484, 1600, 
        getdate(), 0, 0, 0, 7, '(205) 567-0100', '(205) 567-0101', 'http://www.microsoft.com/', 
		'Shop 5', '105 Jitka Street', '90055', 'PO Box 13', '90055', 1),
		(next value for [Sequences].[CustomerID], 'Anna Pavlova', next value for [Sequences].[CustomerID], 3, 1005, 3, 10485, 10485, null, 
        getdate(), 0, 0, 0, 7, '(205) 125-0100', '(205) 125-0101', 'http://www.microsoft.com/', 
		'Shop 20', '121 Valentina Road', '90650', 'PO Box 3235', '90650', 1),
		(next value for [Sequences].[CustomerID], 'Alex Kornev', next value for [Sequences].[CustomerID], 4, 1001, 1, 10486, 10486, 1500, 
        getdate(), 0, 0, 0, 7, '(205) 999-0100', '(205) 999-0101', 'http://www.microsoft.com/', 
		'Shop 12', '429 Viljo Lane', '90760', 'PO Box 7789', '90760', 1),
		(next value for [Sequences].[CustomerID], 'Sergey Notov', next value for [Sequences].[CustomerID], 4, 1007, 1, 10487, 10487, null, 
        getdate(), 0, 0, 0, 7, '(205) 000-0100', '(205) 000-0101', 'http://www.microsoft.com/', 
		'Shop 17', '105 Jitka Street', '90069', 'PO Box 13', '90069', 1)

--2. удалите 1 запись из Customers, которая была вами добавлена

delete from Sales.Customers
 where CustomerName = 'Sergey Notov'

--3. изменить одну запись, из добавленных через UPDATE

update Sales.Customers
 set [PhoneNumber] = '(209) 999-0990'
 where CustomerID = 1066

--4. Написать MERGE, который вставит вставит запись в клиенты, если ее там нет, и изменит если она уже есть

merge into Sales.Customers as target 
 using (select CustomerID, CustomerName, BillToCustomerID, scc.CustomerCategoryID,
               sbg.BuyingGroupID, PrimaryContactPersonID, AlternateContactPersonID,
			   adm.DeliveryMethodID, DeliveryCityID, PostalCityID,
			   CreditLimit, AccountOpenedDate, StandardDiscountPercentage,
			   IsStatementSent, IsOnCreditHold, PaymentDays, ap.PhoneNumber, ap.FaxNumber,
			   DeliveryRun, RunPosition, WebsiteURL, DeliveryAddressLine1, DeliveryAddressLine2,
			   DeliveryPostalCode, DeliveryLocation, PostalAddressLine1, PostalAddressLine2,
			   PostalPostalCode, ap.LastEditedBy
			    from Sales.Customers sc
				 join Sales.CustomerCategories scc on sc.CustomerCategoryID = scc.CustomerCategoryID
				 join Sales.BuyingGroups sbg on sc.BuyingGroupID = sbg.BuyingGroupID
				 join Application.People ap on sc.PrimaryContactPersonID = ap.PersonID and sc.AlternateContactPersonID = ap.PersonID
				 join Application.DeliveryMethods adm on sc.DeliveryMethodID = adm.DeliveryMethodID
				 join Application.Cities ac on sc.DeliveryCityID = ac.CityID and sc.PostalCityID = ac.CityID) 
	as source (CustomerID, CustomerName, BillToCustomerID, CustomerCategoryID,
               BuyingGroupID, PrimaryContactPersonID, AlternateContactPersonID,
			   DeliveryMethodID, DeliveryCityID, PostalCityID,
			   CreditLimit, AccountOpenedDate, StandardDiscountPercentage,
			   IsStatementSent, IsOnCreditHold, PaymentDays, PhoneNumber, FaxNumber,
			   DeliveryRun, RunPosition, WebsiteURL, DeliveryAddressLine1, DeliveryAddressLine2,
			   DeliveryPostalCode, DeliveryLocation, PostalAddressLine1, PostalAddressLine2,
			   PostalPostalCode, LastEditedBy)
    on (target.CustomerID = source.CustomerID)
 when matched
  then update set CustomerId = source.CustomerId,
                  CustomerName = source.CustomerName,
				  BillToCustomerID = source.BillToCustomerID, 
				  CustomerCategoryID = source.CustomerCategoryID,
                  BuyingGroupID = source.BuyingGroupID, 
				  PrimaryContactPersonID = source.PrimaryContactPersonID, 
				  AlternateContactPersonID = source.AlternateContactPersonID,
			      DeliveryMethodID = source.DeliveryMethodID, 
				  DeliveryCityID = source.DeliveryCityID, 
				  PostalCityID = source.PostalCityID,
			      CreditLimit = source.CreditLimit, 
				  AccountOpenedDate = source.AccountOpenedDate, 
				  StandardDiscountPercentage = source.StandardDiscountPercentage,
			      IsStatementSent = source.IsStatementSent, 
				  IsOnCreditHold = source.IsOnCreditHold, 
				  PaymentDays = source.PaymentDays, 
				  PhoneNumber = source.PhoneNumber, 
				  FaxNumber = source.FaxNumber,
			      DeliveryRun = source.DeliveryRun, 
				  RunPosition = source.RunPosition, 
				  WebsiteURL = source.WebsiteURL, 
				  DeliveryAddressLine1 = source.DeliveryAddressLine1, 
				  DeliveryAddressLine2 = source.DeliveryAddressLine2,
			      DeliveryPostalCode = source.DeliveryPostalCode, 
				  DeliveryLocation = source.DeliveryLocation, 
				  PostalAddressLine1 = source.PostalAddressLine1, 
				  PostalAddressLine2 = source.PostalAddressLine2,
			      PostalPostalCode = source.PostalPostalCode, 
				  LastEditedBy = source.LastEditedBy
 when not matched
  then insert (CustomerID, CustomerName, BillToCustomerID, CustomerCategoryID,
               BuyingGroupID, PrimaryContactPersonID, AlternateContactPersonID,
			   DeliveryMethodID, DeliveryCityID, PostalCityID,
			   CreditLimit, AccountOpenedDate, StandardDiscountPercentage,
			   IsStatementSent, IsOnCreditHold, PaymentDays, PhoneNumber, FaxNumber,
			   DeliveryRun, RunPosition, WebsiteURL, DeliveryAddressLine1, DeliveryAddressLine2,
			   DeliveryPostalCode, DeliveryLocation, PostalAddressLine1, PostalAddressLine2,
			   PostalPostalCode, LastEditedBy)
   values (source.CustomerID, source.CustomerName, source.BillToCustomerID, source.CustomerCategoryID,
           source.BuyingGroupID, source.PrimaryContactPersonID, source.AlternateContactPersonID,
		   source.DeliveryMethodID, source.DeliveryCityID, source.PostalCityID,
		   source.CreditLimit, source.AccountOpenedDate, source.StandardDiscountPercentage,
		   source.IsStatementSent, source.IsOnCreditHold, source.PaymentDays, source.PhoneNumber, source.FaxNumber,
		   source.DeliveryRun, source.RunPosition, source.WebsiteURL, source.DeliveryAddressLine1, source.DeliveryAddressLine2,
		   source.DeliveryPostalCode, source.DeliveryLocation, source.PostalAddressLine1, source.PostalAddressLine2,
		   source.PostalPostalCode, source.LastEditedBy)
   output deleted.*, $action, inserted.*;

--5. Напишите запрос, который выгрузит данные через bcp out и загрузить через bulk insert

-- To allow advanced options to be changed.  
EXEC sp_configure 'show advanced options', 1;  
GO  
-- To update the currently configured value for advanced options.  
RECONFIGURE;  
GO  
-- To enable the feature.  
EXEC sp_configure 'xp_cmdshell', 1;  
GO  
-- To update the currently configured value for this feature.  
RECONFIGURE;  
GO 

SELECT @@SERVERNAME

exec master..xp_cmdshell 'bcp "[WideWorldImporters].Sales.InvoiceLines" out  "C:\1\InvoiceLines15.txt" -T -w -t";" -S LAPTOP-8RGUNJN3\SQL2017'

-------------------------------------------------------

drop table if exists [Sales].[InvoiceLines_BulkDemo]

CREATE TABLE [Sales].[InvoiceLines_BulkDemo](
	[InvoiceLineID] [int] NOT NULL,
	[InvoiceID] [int] NOT NULL,
	[StockItemID] [int] NOT NULL,
	[Description] [nvarchar](100) NOT NULL,
	[PackageTypeID] [int] NOT NULL,
	[Quantity] [int] NOT NULL,
	[UnitPrice] [decimal](18, 2) NULL,
	[TaxRate] [decimal](18, 3) NOT NULL,
	[TaxAmount] [decimal](18, 2) NOT NULL,
	[LineProfit] [decimal](18, 2) NOT NULL,
	[ExtendedPrice] [decimal](18, 2) NOT NULL,
	[LastEditedBy] [int] NOT NULL,
	[LastEditedWhen] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_Sales_InvoiceLines_BulkDemo] PRIMARY KEY CLUSTERED 
(
	[InvoiceLineID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [USERDATA]
) ON [USERDATA]
----

	BULK INSERT [WideWorldImporters].[Sales].[InvoiceLines_BulkDemo]
				   FROM "C:\1\InvoiceLines15.txt"
				   WITH 
					 (
						BATCHSIZE = 1000, 
						DATAFILETYPE = 'widechar',
						FIELDTERMINATOR = ';',
						ROWTERMINATOR ='\n',
						KEEPNULLS,
						TABLOCK        
					  );



select Count(*) from [Sales].[InvoiceLines_BulkDemo];

TRUNCATE TABLE [Sales].[InvoiceLines_BulkDemo];