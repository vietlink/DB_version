/****** Object:  Procedure [dbo].[uspAddUpdateTimesheetRateAdjustmentItem]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspAddUpdateTimesheetRateAdjustmentItem](@timesheetRateAdjustmentID int, @rate decimal(10,5), @balance decimal(10,5))
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @rateID int = 0;
	SELECT @rateID = ID FROM LoadingRate WHERE Value = @rate;

	DECLARE @id int;
	SELECT @id = ID FROM TimesheetRateAdjustmentItem WHERE TimesheetRateAdjustmentID = @timesheetRateAdjustmentID AND RateID = @rateID
	print @id
    IF @id > 0 BEGIN
	print 'a'
		UPDATE
			TimesheetRateAdjustmentItem
		SET
			Balance = @balance
		WHERE
			id = @id;
	END
	ELSE BEGIN
	print 'b'
		INSERT INTO
			TimesheetRateAdjustmentItem(TimesheetRateAdjustmentID, RateID, Balance)
				VALUES(@timesheetRateAdjustmentID, @rateID, @balance)
	END

	DECLARE @tsHeaderId int = 0;
	SELECT @tsHeaderId = TimeSheetHeaderID FROM TimesheetRateAdjustment WHERE ID = @timesheetRateAdjustmentID

	IF dbo.fnGetTimesheetAdjustmentCount(@tsHeaderId) > 0 BEGIN
		UPDATE TimesheetHeader SET RequiresAdditionalApproval = 1
	END
END

