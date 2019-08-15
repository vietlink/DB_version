/****** Object:  Procedure [dbo].[uspAddOrUpdateExpenseClaimSettings]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		uspAddOrUpdateTimesheetSetting
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[uspAddOrUpdateExpenseClaimSettings]
	-- Add the parameters for the stored procedure here
	@id int, @approver1 int, @approver1positionid int, 
	@costcentrereq bit, @costcentretext varchar(15),
	@expensecode varchar(15),
	@accountcodereq bit, @accountcodetext varchar(15),
	@taxreq bit, @taxtext varchar(15),
	@sendapproveremailflag bit, @sendapproveremailtext varchar(max),
	@sendemailflag bit, @sendemailtext varchar(max),
	@sendemailrejectflag bit, @sendemailrejecttext varchar(max),
	@taxValue decimal(5,2), @paidRate decimal(5,2), @govRate decimal(5,2), @unit varchar(5),
	@expenseClaimMsg varchar(200), @mileageClaimMsg varchar(200), @expenseMileageClaimAs varchar(7), @isExpenseReceiptRequire bit, @defaultExpenseCodeID int, @taxCode varchar(20), @noTaxCode varchar(20), @currencyCode varchar(20), @mileageNonTaxCostCentreID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF (@id>0) BEGIN
		UPDATE ExpenseClaimSettings
		SET 
			Approver1 = @approver1,
			Approver1PositionID = @approver1positionid,
			CostCentreReqFlag = @costcentrereq,
			CostCentreText = @costcentretext,
			ExpenseCodeText = @expensecode,
			AccountCodeReqFlag = @accountcodereq,
			AccountCodeText = @accountcodetext,
			TaxReqFlag = @taxreq,
			TaxText = @taxtext,
			SendApproverEmailFlag = @sendapproveremailflag,
			SendApproverEmailText = @sendapproveremailtext,
			SendEmailApproverFlag = @sendemailflag,
			SendEmailApproverText = @sendemailtext,
			SendEmailRejectFlag = @sendemailrejectflag,
			SendEmailRejectText = @sendemailrejecttext,
			TaxValue = @taxValue,
			MileageRatePaid = @paidRate,
			MileageRateGov= @govRate,
			MilesKm = @unit,
			ExpClaimMsg = @expenseClaimMsg,
			MileageClaimMsg= @mileageClaimMsg,
			ExportMileageClaimAs= @expenseMileageClaimAs,
			IsExpenseRecieptRequired = @isExpenseReceiptRequire,
			DefaultExpenseCodeID = @defaultExpenseCodeID,
			TaxCode= @taxCode,
			NoTaxCode= @noTaxCode,
			CurrencyCode= @currencyCode,
			MileageNonTaxExpenseCodeID= @mileageNonTaxCostCentreID
		WHERE ID = @id
	END
	ELSE BEGIN
		INSERT INTO ExpenseClaimSettings (Approver1, Approver1PositionID, CostCentreReqFlag, CostCentreText, ExpenseCodeText, AccountCodeReqFlag, AccountCodeText, TaxReqFlag, TaxText,
		 SendApproverEmailFlag, SendApproverEmailText, SendEmailApproverFlag, SendEmailApproverText, SendEmailRejectFlag, SendEmailRejectText, TaxValue, MileageRatePaid, mileageRateGov, MilesKm, ExpClaimMsg, MileageClaimMsg,
		 ExportMileageClaimAs, IsExpenseRecieptRequired, DefaultExpenseCodeID, TaxCode, NoTaxCode, CurrencyCode, MileageNonTaxExpenseCodeID)
		VALUES (@approver1, @approver1positionid, @costcentrereq, @costcentretext, 
		@expensecode, @accountcodereq, @accountcodetext, @taxreq, @taxtext,
		  @sendapproveremailflag, @sendapproveremailtext, @sendemailflag, @sendemailtext, @sendemailrejectflag, @sendemailrejecttext, @taxValue, @paidRate, @govRate, @unit, @expenseClaimMsg, @mileageClaimMsg, @expenseMileageClaimAs,@isExpenseReceiptRequire, @defaultExpenseCodeID, @taxCode, @noTaxCode, @currencyCode, @mileageNonTaxCostCentreID)
	END
END

