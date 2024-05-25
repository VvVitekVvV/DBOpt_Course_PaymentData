BEGIN TRAN T1;
SET NOCOUNT ON
SET STATISTICS time ON
-- Test Data
DECLARE @BankId UNIQUEIDENTIFIER = NEWID()
DECLARE @ClientId UNIQUEIDENTIFIER = NEWID()
DECLARE @CashboxId UNIQUEIDENTIFIER = NEWID()
DECLARE @SupplierId UNIQUEIDENTIFIER = NEWID()
DECLARE @ManagerId UNIQUEIDENTIFIER = NEWID()
DECLARE @ForemanId UNIQUEIDENTIFIER = NEWID()
DECLARE @ProjectId UNIQUEIDENTIFIER = NEWID()

DECLARE @balance_supplier_start INT
DECLARE @balance_bank_start INT
DECLARE @balance_client_start INT
DECLARE @balance_cashbox_start INT

SET @balance_supplier_start = 0
SET @balance_bank_start = 0
SET @balance_client_start = 0
SET @balance_cashbox_start = 0

DECLARE @bank_to_supplier  INT
DECLARE @supplier_to_client  INT
DECLARE @client_to_cashbox 	 INT
DECLARE @cashbox_to_bank INT

SET @bank_to_supplier = 400000
SET @supplier_to_client = 100000
SET @client_to_cashbox = 150000
SET @cashbox_to_bank = 100000

INSERT dbo.PaymentParticipant(Oid, Balance, Name, OptimisticLockField, GCRecord, ObjectType, ActiveFrom, InactiveFrom, BankDetails, Balance2, Balance3) 
	VALUES (@BankId, 0, N'Тест банка', 1, NULL, 1, '2023-01-01 00:00:00.000', NULL, N'HJOX IT YO WW7', 0, 0)
INSERT dbo.PaymentParticipant(Oid, Balance, Name, OptimisticLockField, GCRecord, ObjectType, ActiveFrom, InactiveFrom, BankDetails, Balance2, Balance3) 
	VALUES (@ClientID, 0, N'Тест клиента', 1, NULL, 1, '2023-01-01 00:00:00.000', NULL, NULL, 0, 0)
INSERT dbo.PaymentParticipant(Oid, Balance, Name, OptimisticLockField, GCRecord, ObjectType, ActiveFrom, InactiveFrom, BankDetails, Balance2, Balance3) 
	VALUES (@CashboxID, 0, N'Тест кассы', 1, NULL, 1, '2023-01-01 00:00:00.000', NULL, NULL, 0, 0)
INSERT dbo.PaymentParticipant(Oid, Balance, Name, OptimisticLockField, GCRecord, ObjectType, ActiveFrom, InactiveFrom, BankDetails, Balance2, Balance3) 
	VALUES (@SupplierID, 0, N'Тест поставщика', 1, NULL, 1, '2023-01-01 00:00:00.000', NULL, NULL, 0, 0)
INSERT dbo.PaymentParticipant(Oid, Balance, Name, OptimisticLockField, GCRecord, ObjectType, ActiveFrom, InactiveFrom, BankDetails, Balance2, Balance3) 
	VALUES (@ManagerId, 0, N'Тест менеджера', 1, NULL, 1, '2023-01-01 00:00:00.000', NULL, NULL, 0, 0)
INSERT dbo.PaymentParticipant(Oid, Balance, Name, OptimisticLockField, GCRecord, ObjectType, ActiveFrom, InactiveFrom, BankDetails, Balance2, Balance3) 
	VALUES (@ForemanId, 0, N'Тест начальника', 1, NULL, 1, '2023-01-01 00:00:00.000', NULL, NULL, 0, 0)

INSERT dbo.Bank(Oid, AccountType) VALUES (@BankId, '2126EF07-0276-4440-B71C-C353516A0946')
INSERT dbo.Client(Oid, FirstName, SecondName, Phone) VALUES (@ClientId, N'Test First Name', N'Test Second Name', N'(999) 999-9999')
INSERT dbo.Cashbox(Oid, AccountType) VALUES (@CashboxId, 'A126415B-734D-4D05-BF68-F888D680C5BA')
INSERT dbo.Supplier(Oid, Contact, ProfitByMaterialAsPayer, ProfitByMaterialAsPayee, CostByMaterialAsPayer) VALUES (@SupplierId, N'Test Contact', 0, 1, 0)
INSERT dbo.Employee(Oid, BusyUntil, SecondName, Stuff, HourPrice, Patronymic, PlanfixId, Head, PlanfixMoneyRequestTask) 
	VALUES (@ManagerId, '2023-01-01 00:00:00.000', N'Second Name 1', 1, 2000, N'P', 1, NULL, N'Task 1')
INSERT dbo.Employee(Oid, BusyUntil, SecondName, Stuff, HourPrice, Patronymic, PlanfixId, Head, PlanfixMoneyRequestTask) 
	VALUES (@ForemanId, '2023-02-02 00:00:00.000', N'Second Name 2', 1, 2500, N'PP', 2, NULL, N'Task 2')
INSERT dbo.Project(Oid, Name, Address, Client, Manager, Foreman, OptimisticLockField, GCRecord, Balance, BalanceByMaterial, BalanceByWork, PlaningStartDate, Status, FinishDate, Area, WorkPriceRate, WorkersPriceRate, RemainderTheAdvance, PlanfixWorkTask, PlanfixChangeRequestTask, UseAnalytics) 
	VALUES (@ProjectId, N'Тестовый проект', N'Адрес', @ClientId, @ManagerId, @ForemanId, 0, NULL, 3, 0, 0, '2023-04-01 00:00:00.000', 1, '2023-04-04 00:00:00.000', 10, 1000000.00, 1000.00, 0, N'Task', N'Change request task', 1)



DECLARE @BankBalance INT
DECLARE @ClientBalance INT
DECLARE @CashboxBalance INT
DECLARE @SupplierBalance INT

SET @BankBalance = (SELECT Balance FROM PaymentParticipant WHERE Oid = @BankId)
SET @ClientBalance = (SELECT Balance FROM PaymentParticipant WHERE Oid = @ClientId)
SET @CashboxBalance = (SELECT Balance FROM PaymentParticipant WHERE Oid = @CashboxId)
SET @SupplierBalance = (SELECT Balance FROM PaymentParticipant WHERE Oid = @SupplierId)

DECLARE @Category UNIQUEIDENTIFIER = '700AB7DD-72AE-4F01-A7E2-1DBC341ED4C2'

DECLARE @Payment1Id UNIQUEIDENTIFIER = NEWID()
DECLARE @Payment2Id UNIQUEIDENTIFIER = NEWID()
DECLARE @Payment3Id UNIQUEIDENTIFIER = NEWID()
DECLARE @Payment4Id UNIQUEIDENTIFIER = NEWID()

INSERT dbo.Payment(Oid, Amount, Category, Project, Justification, Comment, Date, Payer, Payee, OptimisticLockField, GCRecord, CreateDate, CheckNumber, IsAuthorized, Number) 
	VALUES (@Payment1Id, 400000, @Category, @ProjectId, NULL, N'Перевели денег поставщику для будущих закупок. Образовался долг банку.', '2018-05-05 00:00:00.000', @BankId, @SupplierId, NULL, NULL, '2018-05-05 00:00:00.000', N'31862', NULL, N'001')

SET @Category  = '951FAEE9-8883-4AEF-8CB2-11AAC0A245E0'

INSERT dbo.Payment(Oid, Amount, Category, Project, Justification, Comment, Date, Payer, Payee, OptimisticLockField, GCRecord, CreateDate, CheckNumber, IsAuthorized, Number) 
	VALUES (@Payment2Id, 100000, @Category, @ProjectId, NULL, N'Для клиента приобрели материал. Поставщик нам должен меньше, а клиент должен за материалы.', '2018-06-06 00:00:00.000', @SupplierId, @ClientId, NULL, NULL, '2018-06-06 00:00:00.000', N'31863', NULL, N'002')

INSERT dbo.Payment(Oid, Amount, Category, Project, Justification, Comment, Date, Payer, Payee, OptimisticLockField, GCRecord, CreateDate, CheckNumber, IsAuthorized, Number) 
	VALUES (@Payment3Id, 150000, @Category, @ProjectId, NULL, N'Клиент передал наличные для закупки материалов.', '2018-07-07 00:00:00.000', @ClientId, @CashboxId, NULL, NULL, '2018-07-07 00:00:00.000', N'31864', NULL, N'003')

SET @Category = 'AC03D0B4-8060-4E8D-BEF2-6B2382500DD0'

INSERT dbo.Payment(Oid, Amount, Category, Project, Justification, Comment, Date, Payer, Payee, OptimisticLockField, GCRecord, CreateDate, CheckNumber, IsAuthorized, Number) 
	VALUES (@Payment4Id, 100000, @Category, @ProjectId, NULL, N'Частично гасим кредит.', '2018-08-08 00:00:00.000', @CashboxId, @BankId, NULL, NULL, '2018-08-08 00:00:00.000', N'31865', NULL, N'004')

SET @BankBalance = (SELECT Balance FROM PaymentParticipant WHERE Oid = @BankId)
SET @SupplierBalance = (SELECT Balance FROM PaymentParticipant WHERE Oid = @SupplierId)
SET @ClientBalance = (SELECT Balance FROM PaymentParticipant WHERE Oid = @ClientId)
SET @CashboxBalance = (SELECT Balance FROM PaymentParticipant WHERE Oid = @CashboxId)

RAISERROR (N'LOG: Balances after operations:', 10, 1) WITH NOWAIT;

declare @b NVARCHAR(50) = N'LOG: Баланс банка: ' + CONVERT(varchar(10), @BankBalance);
declare @c NVARCHAR(50) = N'LOG: Баланс клиента: ' + CONVERT(varchar(10), @ClientBalance);
declare @k NVARCHAR(50) = N'LOG: Баланс кассы: ' + CONVERT(varchar(10), @CashboxBalance);
declare @p NVARCHAR(50) = N'LOG: Баланс поставщика: ' + CONVERT(varchar(10), @SupplierBalance);
RAISERROR (@b, 10, 1) WITH NOWAIT;
RAISERROR (@c, 10, 1) WITH NOWAIT;
RAISERROR (@k, 10, 1) WITH NOWAIT;
RAISERROR (@p, 10, 1) WITH NOWAIT;


IF((@balance_supplier_start - @bank_to_supplier + @cashbox_to_bank) = @BankBalance)
	RAISERROR (N'LOG: Balance of bank: True', 10, 1) WITH NOWAIT;
ELSE
	RAISERROR (N'LOG: Balance of bank: False', 10, 1) WITH NOWAIT;

IF((@balance_bank_start - @supplier_to_client  + @bank_to_supplier ) = @SupplierBalance)
	RAISERROR (N'LOG: Balance of supplier: True', 10, 1) WITH NOWAIT;
ELSE
	RAISERROR (N'LOG: Balance of supplier: False', 10, 1) WITH NOWAIT;

IF((@balance_client_start - @client_to_cashbox  + @supplier_to_client ) = @ClientBalance)
	RAISERROR (N'LOG: Balance of client: True', 10, 1) WITH NOWAIT;
ELSE
	RAISERROR (N'LOG: Balance of client: False', 10, 1) WITH NOWAIT;

IF((@balance_cashbox_start - @cashbox_to_bank  + @client_to_cashbox) = @CashboxBalance)
	RAISERROR (N'LOG: Balance of cashbox: True', 10, 1) WITH NOWAIT;
ELSE
	RAISERROR (N'LOG: Balance of cashbox: False', 10, 1) WITH NOWAIT;



DELETE FROM dbo.Payment WHERE Oid = @Payment4Id
DELETE FROM dbo.Payment WHERE Oid = @Payment3Id
DELETE FROM dbo.Payment WHERE Oid = @Payment2Id
DELETE FROM dbo.Payment WHERE Oid = @Payment1Id

DELETE FROM dbo.Project WHERE Oid = @ProjectId
DELETE FROM dbo.Employee WHERE Oid = @ForemanId
DELETE FROM dbo.Employee WHERE Oid = @ManagerId

DELETE FROM dbo.Cashbox WHERE Oid = @CashboxId
DELETE FROM dbo.Client WHERE Oid = @ClientId
DELETE FROM dbo.Supplier WHERE Oid = @SupplierId
DELETE FROM dbo.Bank WHERE Oid = @BankId

DELETE FROM dbo.PaymentParticipant WHERE Oid = @ForemanId
DELETE FROM dbo.PaymentParticipant WHERE Oid = @ManagerId
DELETE FROM dbo.PaymentParticipant WHERE Oid = @CashboxId
DELETE FROM dbo.PaymentParticipant WHERE Oid = @ClientId
DELETE FROM dbo.PaymentParticipant WHERE Oid = @SupplierId
DELETE FROM dbo.PaymentParticipant WHERE Oid = @BankId

ROLLBACK TRAN T1;