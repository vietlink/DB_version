/****** Object:  Procedure [dbo].[upsGetAllLeaveType]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Linh Ngo
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[upsGetAllLeaveType] 
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT l.ID, l.ReportDescription, l.BackgroundColour, l.FontColour, l.PaidLeave, l.Enabled, l.Code, l.AccrueLeave
	from LeaveType l 
	where l.Enabled=1
END

