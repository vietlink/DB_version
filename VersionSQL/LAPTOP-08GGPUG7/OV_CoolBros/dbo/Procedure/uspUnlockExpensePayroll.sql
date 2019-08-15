/****** Object:  Procedure [dbo].[uspUnlockExpensePayroll]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[uspUnlockExpensePayroll] 
	-- Add the parameters for the stored procedure here
	@payrollID int, @expenseHeaderID varchar(max), @expenseDetailID varchar(max)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	declare @expenseHeader Table (headerID int);
	declare @expenseDetail Table (detailID int);
	IF CHARINDEX(',', @expenseHeaderID, 0) > 0 BEGIN
		INSERT INTO @expenseHeader -- split the text by , and store in temp table
		SELECT CAST(splitdata AS int) FROM fnSplitString(@expenseHeaderID, ',');	
		END
    ELSE IF LEN(@expenseHeaderID) > 0 BEGIN -- if text existst without a , then assume 1 id
		INSERT INTO @expenseHeader(headerID) VALUES(CAST(@expenseHeaderID as int));	
	end
	IF CHARINDEX(',', @expenseDetailID, 0) > 0 BEGIN
		INSERT INTO @expenseDetail-- split the text by , and store in temp table
		SELECT CAST(splitdata AS int) FROM fnSplitString(@expenseDetailID, ',');	
		END
    ELSE IF LEN(@expenseDetailID) > 0 BEGIN -- if text existst without a , then assume 1 id
		INSERT INTO @expenseDetail(detailID) VALUES(CAST(@expenseDetailID as int));	
		end   
    -- Insert statements for procedure here
	declare @index int= (SELECT ID FROM ExpenseStatus WHERE Code='A')
	UPDATE ExpenseClaimHeader 
	SET PayCycleID= null,
	isLocked=0,
	ExpenseClaimStatusID= @index
	WHERE ID IN (SELECT * FROM @expenseHeader)

	UPDATE ExpenseClaimDetail
	SET PayCycleID= null,
	ExpenseStatusID= @index
	WHERE ID IN (SELECT * FROM @expenseDetail)

	--UPDATE ExpenseClaimDetail
	--SET IsLocked=0
	--WHERE ExpenseClaimHeaderID IN (SELECT * FROM @expenseHeader)

	UPDATE PayrollCycle
	SET ExpenseFinalisedDate=null,
	ExpenseFinalisedByEmpID= null,
	ExpensePayrollStatusID= 1
	WHERE ID= @payrollID
END

