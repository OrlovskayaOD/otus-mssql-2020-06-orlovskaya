--1 Написать хранимую процедуру возвращающую Клиента с набольшей разовой суммой покупки.

use WideWorldImporters
 go

	create procedure maxPrice(@CustId int)
		as
			select CustomerName Customer, max(UnitPrice) maxPrice
			 from Sales.Customers c
				join Sales.Orders o on c.CustomerID=o.CustomerID
				 join Sales.OrderLines ol on o.OrderID=ol.OrderID
				 where c.CustomerID = @CustId
				 group by c.CustomerID, CustomerName
				 order by maxPrice desc

	execute maxPrice @CustId = 1

--2 Написать функцию возвращающую Клиента с наибольшей суммой покупки.

use WideWorldImporters
 go

	create function sumPrice (@CustId int)
		returns table
			as return(
						select c.CustomerID, CustomerName Customer, sum(UnitPrice) sumPrice
						 from Sales.Customers c
							join Sales.Orders o on c.CustomerID=o.CustomerID
							 join Sales.OrderLines ol on o.OrderID=ol.OrderID
							where c.CustomerID = @CustId
							 group by CustomerName, c.CustomerID
					 )

	select * from sumPrice(132)

--3 Написать хранимую процедуру с входящим параметром СustomerID, выводящую сумму покупки по этому клиенту.
--Использовать таблицы :
--Sales.Customers
--Sales.Invoices
--Sales.InvoiceLines

	create procedure CustomerSumPrice
		@CustomerId int
		as
						select c.CustomerID, CustomerName Customer, sum(UnitPrice) sumPrice
						 from Sales.Invoices i
							join Sales.Customers c on i.CustomerID=c.CustomerID
							 join Sales.InvoiceLines il on i.InvoiceID = il.InvoiceID
							where c.CustomerID = @CustId
							 group by CustomerName, c.CustomerID
							 order by sumPrice desc

							 exec CustomerSumPrice 
								@CustomerId = 132

--4 Создать одинаковую функцию и хранимую процедуру, посмотреть в чем разница в производительности и почему.


	create function DateSum
							(
								  @time1 time
								, @time2 time
							)
	returns time
		as 
			begin
	declare @time time
				set @time = dateadd(minute, datepart(minute, @time1), @time2)
				set @time = dateadd(hour, datepart(hour, @time1), @time)
				set @time = dateadd(second, datepart(second, @time1), @time)
	return @time
			end

	--Вызов функции (подсчет времени)
		--declare @time2 time
		--set @time2 = (select  [dbo].[DateSum] ('12:10:03', '01:59:15') )
		--select @time2

	create procedure XPDateSum
	   @time1 time, @time2 time
	    as 
		declare @time time
				set @time = dateadd(minute, datepart(minute, @time1), @time2)
				set @time = dateadd(hour, datepart(hour, @time1), @time)
				set @time = dateadd(second, datepart(second, @time1), @time)
				select @time

	execute XPDateSum @time1 = '12:10:03', @time2 = '01:59:15'