/****** Object:  Procedure [dbo].[uspGetPublicEmployeeGroups]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetPublicEmployeeGroups]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT Id, Name FROM EmployeeGroup WHERE PermissionLevel = 0 OR PermissionLevel = 1
END


