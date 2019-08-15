/****** Object:  Procedure [dbo].[uspAddOrUpdateExpenseClaimDetail]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[uspAddOrUpdateExpenseClaimDetail]
	-- Add the parameters for the stored procedure here
	@id int, @claimHeaderID int, @expenseTypeID int, @claimDate datetime, @description varchar(200),
	 @expenseAmount decimal(10,2), @taxFlag bit, @taxAmount decimal(8,2), @source varchar(max), @destination varchar(max), 
	 @startMileage decimal(8,2), @endMileage decimal(8,2), @totalMileage decimal(8,2), @companyRate decimal(8,2), @govRate decimal(8,2), 
	 --@costCentreFlag bit, @accountFlag bit,
	  @costCentreID int, @expenseCodeID int, @expenseStatusID int, @isLocked bit,
	   @docAttached bit, @createdByUserID int, @createdDate datetime, @lastEditByUserID int, @lastEditDate datetime, @ReturnValue int output
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @costCentreFlag BIT =(SELECT CostCentreReqFlag FROM ExpenseClaimSettings);
	DECLARE @accountFlag BIT =(SELECT AccountCodeReqFlag FROM ExpenseClaimSettings);
    -- Insert statements for procedure here
	IF (@id=0) BEGIN
		INSERT INTO ExpenseClaimDetail(ExpenseClaimHeaderID, ExpenseTypeID, ExpenseDate, Description, ExpenseAmount, TaxFlag, TaxAmount, Source, Destination, StartMileage, EndMileage, TotalMileage, CompanyTravelRate, GovernmentTravelRate, CostCentreExpenseFlag, AccountFlag, CostCentreID, ExpenseCodeID, ExpenseStatusID, isLocked, IsDocAttached, CreatedByUserID, CreatedDate, LastEditedByUserID, LastEditedDate)
		VALUES (@claimHeaderID, @expenseTypeID, @claimDate, @description, @expenseAmount, @taxFlag, @taxAmount, @source, @destination, @startMileage, @endMileage, @totalMileage, @companyRate, @govRate,  @costCentreFlag, @accountFlag, @costCentreID, @expenseCodeID, @expenseStatusID,  @isLocked, @docAttached, @createdByUserID, @createdDate, @lastEditByUserID, @lastEditDate)
		SET @ReturnValue = @@IDENTITY
	END
	ELSE BEGIN
		UPDATE ExpenseClaimDetail
		SET 
			ExpenseClaimHeaderID = @claimHeaderID,
			ExpenseTypeID= @expenseTypeID,
			ExpenseDate= @claimDate,			
			Description= @description,
			ExpenseAmount = @expenseAmount,
			TaxFlag = @taxFlag,
			TaxAmount = @taxAmount,
			Source = @source,
			Destination = @destination,			
			StartMileage = @startMileage,
			EndMileage = @endMileage,
			TotalMileage = @totalMileage,
			CompanyTravelRate = @companyRate,
			GovernmentTravelRate = @govRate,
			CostCentreExpenseFlag = @costCentreFlag,
			AccountFlag = @accountFlag,
			CostCentreID = @costCentreID,
			ExpenseCodeID = @expenseCodeID,
			ExpenseStatusID= @expenseStatusID,
			isLocked = @isLocked,
			IsDocAttached = @docAttached,
			LastEditedByUserID= @lastEditByUserID,
			LastEditedDate= @lastEditDate
		WHERE ID= @id
		SET @ReturnValue = @id
	END
END

