/****** Object:  Procedure [dbo].[uspGetAdminsNotInGroup]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[uspGetAdminsNotInGroup](@groupid int, @search varchar(100))
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	--SELECT e.id, e.firstname, e.surname, e.displayname, e.accountname, ec.workemail FROM Employee e
	--INNER JOIN EmployeeContact ec ON ec.employeeid = e.id
	--INNER JOIN [User] u on u.accountname = e.accountname
	SELECT u.id, u.displayname, u.accountname, u.workemail
	FROM [User] u
	WHERE
	u.IsDeleted = 0 AND (@search = '' OR (u.displayname like '%' + @search + '%' OR u.accountname like '%' + @search + '%')) -- e.firstname <> 'vacant' and (e.displayname like '%'+@search +'%' or e.accountname  like '%'+@search +'%' or e.firstname like '%'+@search +'%' or e.surname  like '%'+@search +'%' or e.secondname like '%'+@search +'%' or e.thirdname like '%'+@search +'%')
	ORDER BY u.displayname
END

