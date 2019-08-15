/****** Object:  Procedure [dbo].[uspGetFlaggedForUserCreationEmployees]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetFlaggedForUserCreationEmployees]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT e.id, e.displayname, e.accountname, ec.workemail FROM Employee e 
	INNER JOIN EmployeeContact ec ON ec.employeeid = e.id
	WHERE e.accountname NOT IN (SELECT accountname FROM [User]) AND e.CreateUserAccount = 1
END


