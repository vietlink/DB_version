/****** Object:  Procedure [dbo].[uspGetLeaveTypeByClassification]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[uspGetLeaveTypeByClassification] 
	-- Add the parameters for the stored procedure here
	@classification int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT * FROM LeaveType WHERE LeaveClassify = @classification
END

