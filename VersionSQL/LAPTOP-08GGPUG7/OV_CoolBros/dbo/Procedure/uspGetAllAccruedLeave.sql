/****** Object:  Procedure [dbo].[uspGetAllAccruedLeave]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[uspGetAllAccruedLeave] 
	-- Add the parameters for the stored procedure here	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT l.ID, l.ReportDescription, l.BackgroundColour, l.FontColour, l.Enabled, l.Code
	from LeaveType l where AccrueLeave=1;
END

