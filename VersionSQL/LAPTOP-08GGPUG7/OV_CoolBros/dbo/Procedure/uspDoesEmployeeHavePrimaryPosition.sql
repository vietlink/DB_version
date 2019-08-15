/****** Object:  Procedure [dbo].[uspDoesEmployeeHavePrimaryPosition]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspDoesEmployeeHavePrimaryPosition](@empId int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @unassignedId int = 0;
	SELECT TOP 1 @unassignedId = id FROM position WHERE isunassigned = 1
    SELECT primaryposition, positionid FROM EmployeePosition WHERE employeeid = @empId AND IsDeleted = 0 AND (primaryposition = 'Y' AND positionid <> @unassignedId)
END

