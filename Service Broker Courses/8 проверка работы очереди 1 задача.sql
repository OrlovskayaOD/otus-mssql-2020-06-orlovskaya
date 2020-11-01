use WideWorldImporters;

--������ ������
select * from InvoicesReport

SELECT *
FROM Sales.Invoices
WHERE CustomerID = 1 and OrderId = 36250;

--Send message
EXEC Sales.SendNewInvoice
	@CustomerID = 1,  @OrderId = 36250;

--� ����� ������� �������� ���������?
SELECT CAST(message_body AS XML),*
FROM dbo.InitiatorQueueWWI;

SELECT CAST(message_body AS XML),*
FROM dbo.TargetQueueWWI;

--�������� �������, ��� ��� ��������
--Target
EXEC Sales.GetNewInvoice;

--��������� ������� ������� 00

--Initiator
EXEC Sales.ConfirmInvoice;

-- ��������, ��� ���� ������������

--�������������� �������

--������ �� �������� �������� ��������
SELECT conversation_handle, is_initiator, s.name as 'local service', 
far_service, sc.name 'contract', ce.state_desc
FROM sys.conversation_endpoints ce
LEFT JOIN sys.services s
ON ce.service_id = s.service_id
LEFT JOIN sys.service_contracts sc
ON ce.service_contract_id = sc.service_contract_id
ORDER BY conversation_handle;
