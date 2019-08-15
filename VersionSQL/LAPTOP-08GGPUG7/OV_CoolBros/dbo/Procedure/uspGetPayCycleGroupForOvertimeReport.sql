/****** Object:  Procedure [dbo].[uspGetPayCycleGroupForOvertimeReport]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[uspGetPayCycleGroupForOvertimeReport] 
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT distinct pg.ID,
	pg.Description
	FROM PayrollCycleGroups pg
	INNER JOIN PayrollCycle pc ON pg.id= pc.PayrollCycleGroupID
	INNER JOIN PayrollStatus ps ON pc.PayrollStatusID= ps.ID
	WHERE ps.Code!='C'
	AND pg.IsDeleted=0
END

