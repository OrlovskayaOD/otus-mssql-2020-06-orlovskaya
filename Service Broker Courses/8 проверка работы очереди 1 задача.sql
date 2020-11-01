use WideWorldImporters;

--первая задача
select * from InvoicesReport

SELECT *
FROM Sales.Invoices
WHERE CustomerID = 1 and OrderId = 36250;

--Send message
EXEC Sales.SendNewInvoice
	@CustomerID = 1,  @OrderId = 36250;

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
