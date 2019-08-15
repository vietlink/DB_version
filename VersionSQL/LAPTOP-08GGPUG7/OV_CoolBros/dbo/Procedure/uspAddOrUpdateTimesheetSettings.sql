/****** Object:  Procedure [dbo].[uspAddOrUpdateTimesheetSettings]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		uspAddOrUpdateTimesheetSetting
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[uspAddOrUpdateTimesheetSettings] 
	-- Add the parameters for the stored procedure here
	@id int, @approver1 int, @approver1positionid int, 
	@sendoverdueemailflag bit, @sendoverdueemailtext varchar(max),
	@sendapproveremailflag bit, @sendapproveremailtext varchar(max),
	@sendemailrejectflag bit, @sendemailrejecttext varchar(max),
	@sendemailapproveflag bit, @sendemailapprovetext varchar(max),
	@toilApprover1 int, @toilApproverPositionID int,
	@sendTOILApproverEmailFlag bit, @sendTOILApproverEmailText varchar(max),
	@sendTOILEmailRejectFlag bit, @sendTOILEmailRejectText varchar(max),
	@sendTOILEmailApproveFlag bit, @sendTOILEmailApproveText varchar(max),
	@allowToAdjust bit
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF (@id>0) BEGIN
		UPDATE TimesheetSettings
		SET 
			Approver1 = @approver1,
			Approver1PositionID = @approver1positionid,
			SendTSOverdueEmailFlag = @sendoverdueemailflag,
			SendTSOverdueEmailText = @sendoverdueemailtext,
			SendTSApproverEmailFlag = @sendapproveremailflag,
			SendTSApproverEmailText = @sendapproveremailtext,
			SendTSEmailRejectFlag = @sendemailrejectflag,
			SendTSEmailRejectText = @sendemailrejecttext,
			SendTSEmailApproveFlag = @sendemailapproveflag,
			SendTSEmailApproveText = @sendemailapprovetext,
			TOILApprover1 = @toilApprover1,
			TOILApprover1PositionID = @toilApproverPositionID,
			SendTOILApproverEmailFlag= @sendTOILApproverEmailFlag,
			SendTOILApproverEmailText = @sendTOILApproverEmailText,
			SendTOILEmailRejectFlag = @sendTOILEmailRejectFlag,
			SendTOILEmailRejectText = @sendTOILEmailRejectText,
			SendTOILEmailApproveFlag = @sendTOILEmailApproveFlag,
			SendTOILEmailApproveText = @sendTOILEmailApproveText,
			CanTimesheetApproverAdjust = @allowToAdjust
		WHERE ID = @id
	END
	ELSE BEGIN
		INSERT INTO TimesheetSettings (Approver1, Approver1PositionID, SendTSOverdueEmailFlag, SendTSOverdueEmailText, SendTSApproverEmailFlag, SendTSApproverEmailText, 
		SendTSEmailRejectFlag, SendTSEmailRejectText, SendTSEmailApproveFlag, SendTSEmailApproveText,
		TOILApprover1, TOILApprover1PositionID,SendTOILApproverEmailFlag, SendTOILApproverEmailText, SendTOILEmailRejectFlag, SendTOILEmailRejectText, SendTOILEmailApproveFlag, SendTOILEmailApproveText,CanTimesheetApproverAdjust )
		VALUES (@approver1, @approver1positionid, @sendoverdueemailflag, @sendoverdueemailtext, @sendapproveremailflag, @sendapproveremailtext, @sendemailrejectflag, @sendemailrejecttext, @sendemailapproveflag, @sendemailapprovetext,
		@toilApprover1, @toilApproverPositionID, @sendapproveremailflag, @sendTOILApproverEmailText, @sendTOILEmailRejectFlag, @sendTOILEmailRejectText, @sendTOILEmailApproveFlag, @sendTOILEmailApproveText, @allowToAdjust)
	END
END

