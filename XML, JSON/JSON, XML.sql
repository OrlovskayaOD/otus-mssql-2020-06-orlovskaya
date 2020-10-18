--XML, JSON и динамический SQL
--1. Загрузить данные из файла StockItems.xml в таблицу Warehouse.StockItems.
--Существующие записи в таблице обновить, отсутствующие добавить (сопоставлять записи по полю StockItemName).
--Файл StockItems.xml в личном кабинете.

DECLARE @hdocid int, @StockItemsXml XML
SET @StockItemsXml = (SELECT * FROM OPENROWSET (BULK 'C:\TEMP\StockItems.xml', SINGLE_BLOB) as data)

select @StockItemsXml StockItemsImportXml

exec sp_xml_preparedocument @hdocid output, @StockItemsXml;

merge Warehouse.StockItems as target
	using (select * from openxml (@hdocid, N'/StockItems/Item',2)
	with ([StockItemName] nvarchar(100) '@Name',
		  [SupplierID] int 'SupplierID',
		  [UnitPackageID] int 'Package/UnitPackageID',
		  [OuterPackageID] int 'Package/OuterPackageID',
		  [QuantityPerOuter] int 'Package/QuantityPerOuter',
		  [TypicalWeightPerUnit] decimal 'Package/TypicalWeightPerUnit',
		  [LeadTimeDays] int 'LeadTimeDays',
		  [IsChillerStock] bit 'IsChillerStock',
		  [TaxRate] decimal 'TaxRate',
		  [UnitPrice] decimal 'UnitPrice'))		  
	as source ([StockItemName], [SupplierID], [UnitPackageID], [OuterPackageID], [QuantityPerOuter], [TypicalWeightPerUnit], [LeadTimeDays], [IsChillerStock], [TaxRate], [UnitPrice])
	on (target.StockItemName = source.StockItemName)
	 when matched
		then update set [StockItemName] = source.[StockItemName],
						[SupplierID] = source.[SupplierID],
						[UnitPackageID] = source.[UnitPackageID],
						[OuterPackageID] = source.[OuterPackageID],
						[QuantityPerOuter] = source.[QuantityPerOuter],
						[TypicalWeightPerUnit] = source.[TypicalWeightPerUnit],
						[LeadTimeDays] = source.[LeadTimeDays],
						[IsChillerStock] = source.[IsChillerStock],
						[TaxRate] = source.[TaxRate],
						[UnitPrice] = source.[UnitPrice]
	 when not matched
		then insert ([StockItemName], [SupplierID], [UnitPackageID], [OuterPackageID], [QuantityPerOuter], [TypicalWeightPerUnit], [LeadTimeDays], [IsChillerStock], [TaxRate], [UnitPrice], [LastEditedBy])
	 values (source.[StockItemName], source.[SupplierID], source.[UnitPackageID], source.[OuterPackageID], source.[QuantityPerOuter], source.[TypicalWeightPerUnit], source.[LeadTimeDays], source.[IsChillerStock], source.[TaxRate], source.[UnitPrice], 1)
	 output deleted.*, $action, inserted.*;

--2. Выгрузить данные из таблицы StockItems в такой же xml-файл, как StockItems.xml

select *
 from Warehouse.StockItems
  for xml path

--3. В таблице Warehouse.StockItems в колонке CustomFields есть данные в JSON.
--Написать SELECT для вывода:
--- StockItemID
--- StockItemName
--- CountryOfManufacture (из CustomFields)
--- FirstTag (из поля CustomFields, первое значение из массива Tags)

select StockItemID 'StockId', StockItemName 'StockName',
		(select json_value((select top 1 CustomFields from Warehouse.StockItems where StockItemId = ws.StockItemId), '$.CountryOfManufacture')) 'Country',
		(select json_value((select top 1 CustomFields from Warehouse.StockItems where StockItemId = ws.StockItemId), '$.Tags[0]')) 'FirstTags'
 from Warehouse.StockItems ws order by StockItemID

--4. Найти в StockItems строки, где есть тэг "Vintage".
--Вывести:
--- StockItemID
--- StockItemName
--- (опционально) все теги (из CustomFields) через запятую в одном поле

--Тэги искать в поле CustomFields, а не в Tags.
--Запрос написать через функции работы с JSON.
--Для поиска использовать равенство, использовать LIKE запрещено.

--Должно быть в таком виде:
--... where ... = 'Vintage'

--Так принято не будет:
--... where ... Tags like '%Vintage%'
--... where ... CustomFields like '%Vintage%'

select StockItemID 'StockId', StockItemName 'StockName',
		(select json_value((select top 1 CustomFields from Warehouse.StockItems where StockItemId = ws.StockItemId), '$.CountryOfManufacture')) 'Country',
		(select json_value((select top 1 CustomFields from Warehouse.StockItems where StockItemId = ws.StockItemId), '$.Tags[0]')) 'FirstTags'
 from Warehouse.StockItems ws
  where (select json_value((select top 1 CustomFields from Warehouse.StockItems where StockItemId = ws.StockItemId), '$.Tags[0]')) = 'Vintage'
		or
		(select json_value((select top 1 CustomFields from Warehouse.StockItems where StockItemId = ws.StockItemId), '$.Tags[1]')) = 'Vintage'
		or
		(select json_value((select top 1 CustomFields from Warehouse.StockItems where StockItemId = ws.StockItemId), '$.Tags[2]')) = 'Vintage'
  order by StockItemID

--5. Пишем динамический PIVOT.
--По заданию из занятия “Операторы CROSS APPLY, PIVOT, CUBE”.
--Требуется написать запрос, который в результате своего выполнения формирует таблицу следующего вида:
--Название клиента
--МесяцГод Количество покупок

--Нужно написать запрос, который будет генерировать результаты для всех клиентов.
--Имя клиента указывать полностью из CustomerName.
--Дата должна иметь формат dd.mm.yyyy например 01.12.2019

select *
from (select sc.CustomerName CustomerName,
								format(si.InvoiceDate, 'dd.MM.yyyy') InvoiceDate, sil.InvoiceID
		from Sales.Customers sc
			join Sales.Invoices si on si.CustomerID = sc.CustomerID
			join Sales.InvoiceLines sil on sil.InvoiceID = si.InvoiceID) as Customer
			pivot (count(InvoiceID) for CustomerName in ([Peeples Valley, AZ], [Medicine Lodge, KS], [Gasport, NY], [Jessie, ND])) as pvt