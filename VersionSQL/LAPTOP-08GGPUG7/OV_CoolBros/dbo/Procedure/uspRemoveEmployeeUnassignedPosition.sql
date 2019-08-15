/****** Object:  Procedure [dbo].[uspRemoveEmployeeUnassignedPosition]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspRemoveEmployeeUnassignedPosition](@empId int)
AS
BEGIN
	DECLARE @positionId int = 0;
	SELECT TOP 1 @positionId = id FROM Position WHERE IsUnassigned = 1;
	DELETE FROM EmployeePosition WHERE employeeid = @empId AND positionid = @positionId;
END


