--XML, JSON и динамический SQL
--1. Загрузить данные из файла StockItems.xml в таблицу Warehouse.StockItems.
--Существующие записи в таблице обновить, отсутствующие добавить (сопоставлять записи по полю StockItemName).
--Файл StockItems.xml в личном кабинете.

--!!!!!!!!!!!!!!!!!!!!!ERROR 
--XML parsing: line 2, character 14, whitespace expected

DECLARE @hdocid int, @StockItemsXml XML
SET @StockItemsXml = (SELECT * FROM OPENROWSET (BULK 'C:\TEMP\StockItems.xml', SINGLE_BLOB) as data)

select @StockItemsXml StockItemsImportXml


--!!!!!!!!!!!!!!!!!!!!!ERROR 
--XML parsing: line 2, character 14, whitespace expected

--EXEC sp_xml_preparedocument @hdocid OUTPUT, @StockItemsXml;

--MERGE Warehouse.StockItems_Copy t
--using (
--SELECT l.*
--FROM OPENXML (@hdocid, N'/StockItems/Item',2)
--WITH

--2. Выгрузить данные из таблицы StockItems в такой же xml-файл, как StockItems.xml

--Примечания к заданиям 1, 2:
--* Если с выгрузкой в файл будут проблемы, то можно сделать просто SELECT c результатом в виде XML.
--* Если у вас в проекте предусмотрен экспорт/импорт в XML, то можете взять свой XML и свои таблицы.
--* Если с этим XML вам будет скучно, то можете взять любые открытые данные и импортировать их в таблицы (например, с https://data.gov.ru).

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