/****** Object:  Procedure [dbo].[uspGetEmployeeGroupAdmins]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetEmployeeGroupAdmins](@groupid int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT isnull(SUBSTRING(
		(SELECT ',' + cast(userid as varchar)
		FROM EmployeeGroupAdmin
		WHERE employeegroupid = @groupid
		FOR XML PATH('')),2,200000), '') AS idList

END

