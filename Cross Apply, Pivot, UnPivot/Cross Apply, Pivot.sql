--Pivot � Cross Apply
--1. ��������� �������� ������, ������� � ���������� ������ ���������� ��������� ������� ���������� ����:
--�������� �������
--�������� ���������� �������

--�������� ����� � ID 2-6, ��� ��� ������������� Tailspin Toys
--��� ������� ����� �������� ��� ����� �������� ������ ���������
--�������� �������� Tailspin Toys (Gasport, NY) - �� �������� � ����� ������ Gasport,NY
--���� ������ ����� ������ dd.mm.yyyy �������� 25.12.2019

--��������, ��� ������ ��������� ����������:
--InvoiceMonth Peeples Valley, AZ Medicine Lodge, KS Gasport, NY Sylvanite, MT Jessie, ND
--01.01.2013 3 1 4 2 2
--01.02.2013 7 3 4 2 1

select *
from (select substring(sc.CustomerName, 16, len(sc.CustomerName)-16) CustomerName,
								format(si.InvoiceDate, 'dd.MM.yyyy') InvoiceDate, sil.InvoiceID
		from Sales.Customers sc
			join Sales.Invoices si on si.CustomerID = sc.CustomerID
			join Sales.InvoiceLines sil on sil.InvoiceID = si.InvoiceID
		 where sc.CustomerId between 2 and 6) as Customer
	    pivot (count(InvoiceID) for CustomerName in ([Peeples Valley, AZ], [Medicine Lodge, KS], [Gasport, NY], [Jessie, ND])) as pvt
		--order by year(pvt.InvoiceDate) -- � order by ������-�� �� ��������

--2. ��� ���� �������� � ������, � ������� ���� Tailspin Toys
--������� ��� ������, ������� ���� � �������, � ����� �������

--������ �����������
--CustomerName AddressLine
--Tailspin Toys (Head Office) Shop 38
--Tailspin Toys (Head Office) 1877 Mittal Road
--Tailspin Toys (Head Office) PO Box 8975
--Tailspin Toys (Head Office) Ribeiroville
--.....

select *
	from (
			select CustomerName LogonName, DeliveryAddressLine1 AddressLine, DeliveryAddressLine2 AddressLine1
					from Sales.Customers
						where CustomerName like 'Tailspin Toys%'
		 ) names
unpivot (DeliveryAddressLine1 for [Address] in (AddressLine, AddressLine1)) as unpvt

--3. � ������� ����� ���� ���� � ����� ������ �������� � ���������
--�������� ������� �� ������, ��������, ��� - ����� � ���� ��� ���� �������� ���� ��������� ���
--������ ������

--CountryId CountryName Code
--1 Afghanistan AFG
--1 Afghanistan 4
--3 Albania ALB
--3 Albania 8

select *
	from (
			select  CountryID, 
					CountryName, 
					IsoAlpha3Code, 
					(select cast(IsoNumericCode as nvarchar(3)) from Application.Countries co where co.CountryID = ac.CountryID) as IsoNumericCodes
			 from Application.Countries ac
		 ) as Country
unpivot (Code for [Name] in (IsoAlpha3Code,IsoNumericCodes)) as unpvt

--4. ���������� �� �� ������� ������� ����� CROSS APPLY
--�������� �� ������� ������� 2 ����� ������� ������, ������� �� �������
--� ����������� ������ ���� �� ������, ��� ��������, �� ������, ����, ���� �������

select  sc.CustomerID, 
		sc.CustomerName,
		tabl.UnitPrice,
		tabl.InvoiceDate
	from Sales.Customers sc
		cross apply(select top 2	il.UnitPrice,
									max(i.InvoiceDate) as InvoiceDate
						from Sales.InvoiceLines il
							join Sales.Invoices i on il.InvoiceID = i.InvoiceID
								where sc.CustomerID=i.CustomerID
								group by il.UnitPrice
								order by il.UnitPrice desc) as tabl