use WideWorldImporters;

--Вторая задача
select * from OrdersReport

SELECT *
FROM Sales.Orders
WHERE CustomerID = 2 and (OrderDate between '2013-01-01' and '2014-01-01')

--Send message
EXEC Sales.SendNewInvoice1
	@CustomerID = 2,  @StartDate = '2013-01-01', @EndDate = '2014-01-01';

--в какой очереди окажется сообщение?
SELECT CAST(message_body AS XML),*
FROM dbo.InitiatorQueueWWI;

SELECT CAST(message_body AS XML),*
FROM dbo.TargetQueueWWI;

--проверим ручками, что все работает
--Target
EXEC Sales.GetNewInvoice;

--посмотрим текущие диалоги 00

--Initiator
EXEC Sales.ConfirmInvoice;

-- проверим, что дата проставилась

--автоматизируем процесс

--запрос на просмотр открытых диалогов
SELECT conversation_handle, is_initiator, s.name as 'local service', 
far_service, sc.name 'contract', ce.state_desc
FROM sys.conversation_endpoints ce
LEFT JOIN sys.services s
ON ce.service_id = s.service_id
LEFT JOIN sys.service_contracts sc
ON ce.service_contract_id = sc.service_contract_id
ORDER BY conversation_handle;
