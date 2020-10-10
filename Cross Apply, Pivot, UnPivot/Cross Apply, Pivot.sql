--Pivot и Cross Apply
--1. Требуется написать запрос, который в результате своего выполнения формирует таблицу следующего вида:
--Название клиента
--МесяцГод Количество покупок

--Клиентов взять с ID 2-6, это все подразделение Tailspin Toys
--имя клиента нужно поменять так чтобы осталось только уточнение
--например исходное Tailspin Toys (Gasport, NY) - вы выводите в имени только Gasport,NY
--дата должна иметь формат dd.mm.yyyy например 25.12.2019

--Например, как должны выглядеть результаты:
--InvoiceMonth Peeples Valley, AZ Medicine Lodge, KS Gasport, NY Sylvanite, MT Jessie, ND
--01.01.2013 3 1 4 2 2
--01.02.2013 7 3 4 2 1

select *
from (select substring(sc.CustomerName, 16, len(sc.CustomerName)-16) as CustomerName,
								 format(si.InvoiceDate, 'dd.MM.yyyy') as InvoiceDate, 
									  					  sil.InvoiceID as InvoiceID
		from Sales.Customers sc
			join Sales.Invoices si on si.CustomerID = sc.CustomerID
			join Sales.InvoiceLines sil on sil.InvoiceID = si.InvoiceID
		 where sc.CustomerId between 2 and 6) as Customer
	    pivot (count(InvoiceID) for CustomerName in ([Peeples Valley, AZ], [Medicine Lodge, KS], [Gasport, NY], [Jessie, ND])) as pvt
		--order by year(pvt.InvoiceDate) -- С order by почему-то не работает
		 
--2. Для всех клиентов с именем, в котором есть Tailspin Toys
--вывести все адреса, которые есть в таблице, в одной колонке

--Пример результатов
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

--3. В таблице стран есть поля с кодом страны цифровым и буквенным
--сделайте выборку ИД страны, название, код - чтобы в поле был либо цифровой либо буквенный код
--Пример выдачи

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

--4. Перепишите ДЗ из оконных функций через CROSS APPLY
--Выберите по каждому клиенту 2 самых дорогих товара, которые он покупал
--В результатах должно быть ид клиета, его название, ид товара, цена, дата покупки

select  sc.CustomerID, 
		sc.CustomerName,
		tabl.UnitPrice,
		tabl.InvoiceDate,
		tabl.StockItemName
	from Sales.Customers sc
		cross apply(select top 2	il.UnitPrice,
									max(i.InvoiceDate) as InvoiceDate,
									StockItemName
						from Sales.InvoiceLines il
							join Sales.Invoices i on il.InvoiceID = i.InvoiceID
								join Warehouse.StockItems si on il.StockItemID = si.StockItemID 
								where sc.CustomerID=i.CustomerID
								group by il.UnitPrice, StockItemName
								order by il.UnitPrice desc) as tabl
