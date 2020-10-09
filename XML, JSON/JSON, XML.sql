--XML, JSON � ������������ SQL
--1. ��������� ������ �� ����� StockItems.xml � ������� Warehouse.StockItems.
--������������ ������ � ������� ��������, ������������� �������� (������������ ������ �� ���� StockItemName).
--���� StockItems.xml � ������ ��������.

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

--2. ��������� ������ �� ������� StockItems � ����� �� xml-����, ��� StockItems.xml

--���������� � �������� 1, 2:
--* ���� � ��������� � ���� ����� ��������, �� ����� ������� ������ SELECT c ����������� � ���� XML.
--* ���� � ��� � ������� ������������ �������/������ � XML, �� ������ ����� ���� XML � ���� �������.
--* ���� � ���� XML ��� ����� ������, �� ������ ����� ����� �������� ������ � ������������� �� � ������� (��������, � https://data.gov.ru).

--3. � ������� Warehouse.StockItems � ������� CustomFields ���� ������ � JSON.
--�������� SELECT ��� ������:
--- StockItemID
--- StockItemName
--- CountryOfManufacture (�� CustomFields)
--- FirstTag (�� ���� CustomFields, ������ �������� �� ������� Tags)

select StockItemID 'StockId', StockItemName 'StockName',
		(select json_value((select top 1 CustomFields from Warehouse.StockItems where StockItemId = ws.StockItemId), '$.CountryOfManufacture')) 'Country',
		(select json_value((select top 1 CustomFields from Warehouse.StockItems where StockItemId = ws.StockItemId), '$.Tags[0]')) 'FirstTags'
 from Warehouse.StockItems ws order by StockItemID

--4. ����� � StockItems ������, ��� ���� ��� "Vintage".
--�������:
--- StockItemID
--- StockItemName
--- (�����������) ��� ���� (�� CustomFields) ����� ������� � ����� ����

--���� ������ � ���� CustomFields, � �� � Tags.
--������ �������� ����� ������� ������ � JSON.
--��� ������ ������������ ���������, ������������ LIKE ���������.

--������ ���� � ����� ����:
--... where ... = 'Vintage'

--��� ������� �� �����:
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

--5. ����� ������������ PIVOT.
--�� ������� �� ������� ���������� CROSS APPLY, PIVOT, CUBE�.
--��������� �������� ������, ������� � ���������� ������ ���������� ��������� ������� ���������� ����:
--�������� �������
--�������� ���������� �������

--����� �������� ������, ������� ����� ������������ ���������� ��� ���� ��������.
--��� ������� ��������� ��������� �� CustomerName.
--���� ������ ����� ������ dd.mm.yyyy �������� 01.12.2019

select *
from (select sc.CustomerName CustomerName,
								format(si.InvoiceDate, 'dd.MM.yyyy') InvoiceDate, sil.InvoiceID
		from Sales.Customers sc
			join Sales.Invoices si on si.CustomerID = sc.CustomerID
			join Sales.InvoiceLines sil on sil.InvoiceID = si.InvoiceID) as Customer
			pivot (count(InvoiceID) for CustomerName in ([Peeples Valley, AZ], [Medicine Lodge, KS], [Gasport, NY], [Jessie, ND])) as pvt