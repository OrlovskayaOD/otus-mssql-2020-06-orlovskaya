USE [WideWorldImporters]
GO
/****** Object:  StoredProcedure [Sales].[GetNewInvoice]    Script Date: 01.11.2020 21:25:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE [Sales].[GetNewInvoice]
AS
BEGIN

	DECLARE @TargetDlgHandle UNIQUEIDENTIFIER, --идентификатор диалога
			@Message NVARCHAR(4000),--полученное сообщение
			@MessageType Sysname,--тип полученного сообщения
			@ReplyMessage NVARCHAR(4000),--ответное сообщение
			@CustomerId INT, @OrderId int,
			@xml XML; 
	
	BEGIN TRAN; 

	--Receive message from Initiator
	RECEIVE TOP(1)
		@TargetDlgHandle = Conversation_Handle,
		@Message = Message_Body,
		@MessageType = Message_Type_Name
	FROM dbo.TargetQueueWWI; 

	SELECT @Message; --выводим в консоль полученный месседж

	SET @xml = CAST(@Message AS XML); -- получаем xml из мессаджа

	--получаем InvoiceID из xml
	SELECT @CustomerId = R.Iv.value('@CustomerId','INT')
	FROM @xml.nodes('/RequestMessage/Inv') as R(Iv);

		SELECT @OrderId = R.Iv.value('@OrderID','INT')
		FROM @xml.nodes('/RequestMessage/Inv') as R(Iv);

	--проставим дату в пустое поле для InvoiceID
	IF EXISTS (SELECT * FROM Sales.Invoices WHERE CustomerID = @CustomerId and OrderID = @OrderId)
	BEGIN
		insert into InvoicesReport
		values (@CustomerId, @OrderId, getdate())
	END;
	
	SELECT @Message AS ReceivedRequestMessage, @MessageType; --в лог. замедляет работу
	
	-- Confirm and Send a reply
	IF @MessageType=N'//WWI/SB/RequestMessage'
	BEGIN
		SET @ReplyMessage =N'<ReplyMessage> Message received </ReplyMessage>'; 
	
		SEND ON CONVERSATION @TargetDlgHandle
		MESSAGE TYPE
		[//WWI/SB/ReplyMessage]
		(@ReplyMessage);
		END CONVERSATION @TargetDlgHandle;--закроем диалог со стороны таргета
	END 
	
	SELECT @ReplyMessage AS SentReplyMessage; --в лог

	COMMIT TRAN;
END