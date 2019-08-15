/****** Object:  Procedure [dbo].[uspGetPrimaryPositionByEmpId]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetPrimaryPositionByEmpId](@empId int, @posId int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @unassignedId int;
	SELECT @unassignedId = id FROM Position WHERE IsUnassigned = 1
    SELECT * FROM EmployeePosition WHERE (EmployeeID = @empId AND PositionID <> @posId) AND primaryposition = 'Y' AND PositionID <> @unassignedId AND IsDeleted = 0
END

