/****** Object:  Procedure [dbo].[uspFinalisedExpensePayroll]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[uspFinalisedExpensePayroll] 
	-- Add the parameters for the stored procedure here
	@payrollID int, @expenseHeaderID varchar(max), @expenseDetailID varchar(max), @finalisedDate datetime, @finalisedBy int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
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
	--DECLARE @index int= (SELECT ID FROM ExpenseStatus WHERE Code='Pd')
	UPDATE ExpenseClaimHeader 
	SET PayCycleID= @payrollID,
	isLocked=1
	--ExpenseClaimStatusID= @index
	WHERE ID IN (SELECT * FROM @expenseHeader)

	UPDATE ExpenseClaimDetail
	SET PayCycleID= @payrollID
	--ExpenseStatusID= @index
	WHERE ID IN (SELECT * FROM @expenseDetail)

	UPDATE ExpenseClaimDetail
	SET IsLocked=1
	WHERE ExpenseClaimHeaderID IN (SELECT * FROM @expenseHeader)

	UPDATE PayrollCycle
	SET ExpenseFinalisedDate=@finalisedDate,
	ExpenseFinalisedByEmpID= @finalisedBy,
	ExpensePayrollStatusID= 2
	WHERE ID= @payrollID
END

