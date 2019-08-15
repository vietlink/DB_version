/****** Object:  Procedure [dbo].[uspGetTimesheetSetting]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[uspGetTimesheetSetting] 
	-- Add the parameters for the stored procedure here
	@id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
		SELECT t.*, 
		isnull(p.Title + ' - (' + p.identifier + ')','') as EscalatePosition1,
		isnull(p1.Title + ' - (' + p1.identifier + ')','') as EscalatePositionTOIL 
		FROM TimesheetSettings t
		LEFT OUTER JOIN Position p ON t.Approver1PositionID= p.id
		LEFT OUTER JOIN Position p1 ON t.TOILApprover1PositionID= p1.id
		--WHERE t.ID = @id	
END

