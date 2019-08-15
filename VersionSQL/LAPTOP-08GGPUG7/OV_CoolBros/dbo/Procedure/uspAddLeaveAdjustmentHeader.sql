/****** Object:  Procedure [dbo].[uspAddLeaveAdjustmentHeader]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspAddLeaveAdjustmentHeader](@date datetime, @leaveTypeId int, @creditAmount decimal(25,15), @debitAmount decimal(25, 15),
	@reason varchar(max), @createdBy int, @createdDate datetime, @isPayout bit)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	INSERT INTO LeaveAdjustmentHeader([Date], LeaveTypeID, CreditAmount, DebitAmount, Reason, CreatedBy, CreatedDate, isPayout)
		VALUES(@date, @leaveTypeId, @creditAmount, @debitAmount, @reason, @createdBy, @createdDate, @isPayout);

	RETURN @@IDENTITY;
END

