/****** Object:  Procedure [dbo].[uspGetPositionByEmployee]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[uspGetPositionByEmployee] 
	-- Add the parameters for the stored procedure here
	@empID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT p.id AS PositionID
	FROM 
	EmployeePosition ep 
	INNER JOIN Position p ON ep.positionid= p.id
	WHERE 
	ep.employeeid=@empID
	AND ep.IsDeleted=0
	AND ep.primaryposition='Y'
END

