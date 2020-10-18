--XML, JSON � ������������ SQL
--1. ��������� ������ �� ����� StockItems.xml � ������� Warehouse.StockItems.
--������������ ������ � ������� ��������, ������������� �������� (������������ ������ �� ���� StockItemName).
--���� StockItems.xml � ������ ��������.

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

--2. ��������� ������ �� ������� StockItems � ����� �� xml-����, ��� StockItems.xml

select *
 from Warehouse.StockItems
  for xml path

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