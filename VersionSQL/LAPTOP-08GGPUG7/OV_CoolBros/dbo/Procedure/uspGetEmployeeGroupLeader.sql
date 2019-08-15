/****** Object:  Procedure [dbo].[uspGetEmployeeGroupLeader]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetEmployeeGroupLeader](@groupid int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT TOP 1 e.id, e.firstname, e.surname FROM EmployeeGroupEmployee ege
	INNER JOIN Employee e ON ege.employeeid = e.id
	WHERE ege.IsLeader = 1 AND ege.employeegroupid = @groupid AND e.IsDeleted = 0
END

