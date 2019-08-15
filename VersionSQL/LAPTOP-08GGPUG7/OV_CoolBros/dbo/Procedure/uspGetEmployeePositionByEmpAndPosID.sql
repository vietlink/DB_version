/****** Object:  Procedure [dbo].[uspGetEmployeePositionByEmpAndPosID]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetEmployeePositionByEmpAndPosID](@employeeId int, @positionId int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT * FROM EmployeePosition WHERE employeeid = @employeeId AND positionid = @positionId
END


