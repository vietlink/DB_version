/****** Object:  Procedure [dbo].[uspGetNewUsersToEmail]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetNewUsersToEmail](@search varchar(max))
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT u.id, e.displayname, u.accountname, isnull(ec.workemail, u.workemail) as workemail FROM [User] u
	LEFT OUTER JOIN Employee e ON e.accountname = u.accountname
	LEFT OUTER JOIN EmployeeContact ec ON ec.employeeid = e.id
	WHERE u.RequiresPasswordReset = 1 AND u.HasBeenEmailed = 0 AND isnull(e.[Type], '') <> 'BuiltIn'
	AND (@search = '' OR (u.accountname = @search))
END

