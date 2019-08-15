/****** Object:  Procedure [dbo].[uspGetMyManagerByMyEmpPosID]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetMyManagerByMyEmpPosID](@empPosId int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    DECLARE @managerEmpPosId int = 0;
	SELECT @managerEmpPosId = ManagerID FROM EmployeePosition WHERE id = @empPosId;
	IF @managerEmpPosId IS NOT NULL BEGIN
		SELECT
			ep.id, e.id as employeeid, ep.positionid, e.displayname [name]
		FROM
			EmployeePosition ep
		INNER JOIN
			Employee e
		ON
			e.id = ep.employeeid
		WHERE
			ep.id = @managerEmpPosId
		RETURN;
	END


	SELECT '' as [name], 0 as id, 0 as employeeid, 0 as positionid
END
