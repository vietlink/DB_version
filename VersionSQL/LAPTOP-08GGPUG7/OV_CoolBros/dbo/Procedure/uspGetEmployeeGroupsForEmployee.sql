/****** Object:  Procedure [dbo].[uspGetEmployeeGroupsForEmployee]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetEmployeeGroupsForEmployee](@employeeId int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT ec.* FROM
	EmployeeGroup ec
	INNER JOIN
	EmployeeGroupEmployee ege
	ON ege.employeegroupid = ec.id
	WHERE ege.employeeid = @employeeId
END


