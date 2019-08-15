/****** Object:  Procedure [dbo].[uspGetUnassignedUserEmployees]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetUnassignedUserEmployees](@search varchar(256))
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT 
		e.id, e.firstname, e.surname, e.displayname, e.accountname, e.identifier
	FROM
		Employee e
	LEFT OUTER JOIN
		[User] u
	ON
		u.accountname = e.accountname
	WHERE
		e.isdeleted = 0 and
		((u.accountname IS NULL AND e.accountname <> 'vacant') OR u.IsDeleted = 1)
		AND
		((isnull(e.displayname, u.displayname) LIKE '%' + @search + '%') OR (e.accountname LIKE '%' + @search + '%'))
		AND
		e.accountname <> '' AND e.accountname is not null
	ORDER BY surname
END

