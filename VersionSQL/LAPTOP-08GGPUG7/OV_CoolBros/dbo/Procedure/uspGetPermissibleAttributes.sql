/****** Object:  Procedure [dbo].[uspGetPermissibleAttributes]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetPermissibleAttributes](@userId int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @IsManager varchar(1) = 'N';
	DECLARE @loggedInEmpId int = 0;
	DECLARE @accessPermId int = 0;
	DECLARE @entryGroupId int = 0;
	DECLARE @noteUsedId int = 0;
	SELECT
		@loggedInEmpId = e.id
	FROM
		Employee e
	INNER JOIN
		[User] u
	ON
		u.accountname = e.accountname
	WHERE u.id = @userId

	SET @IsManager = ISNULL((SELECT Managerial FROM EmployeePosition WHERE employeeid = @loggedInEmpId AND Managerial = 'Y'), 'N');
	SELECT @accessPermId = id FROM Entity WHERE name = 'Access Permissions';
	SELECT @entryGroupId = id FROM Entity WHERE name = 'Employee Data Entry Forms';
	SELECT @noteUsedId = id from AttributeSource WHERE Code = 'notused'

	SELECT
		DISTINCT a.id as attributeid,
		CASE WHEN ISNULL(ra.granted, 'N') = 'N' THEN 
			CASE WHEN @IsManager = 'Y' AND a.ispersonal = 'Y' 
			THEN
				'Y'
			ELSE
				CASE WHEN @IsManager = 'Y' AND a.ismanagerial = 'Y'
				THEN 
					'Y'
				ELSE
					'N'
				END
			END
		ELSE
			ra.granted
		END as granted,
		a.columnname, 
		a.shortname, 
		e.code + '.' + a.columnname as newcolumnname, 
		e.code + a.columnname as gridcolumnField,
		'' as Modetype,
		case when tab = 0 then 99 else tab end as tab,
		isnull(tabbasedsort, 99) as tabbasedsort
	FROM
		Attribute a
	LEFT OUTER JOIN
		RoleAttribute ra
	ON
		a.id = ra.attributeid
	LEFT OUTER JOIN
		RoleUser ru
	ON
		ru.roleid = ra.roleid
	INNER JOIN
		Entity e
	ON
		e.id = a.entityid
	WHERE
		a.attributesourceid <> @noteUsedId AND (ru.userid = @userId OR a.ispersonal = 'Y' OR a.ismanagerial = 'Y') AND e.id <> @accessPermId AND e.id <> @entryGroupId AND a.usereditable = 'Y'
	AND
		CASE WHEN ISNULL(ra.granted, 'N') = 'N' THEN 
			CASE WHEN @IsManager = 'Y' AND a.ispersonal = 'Y' 
			THEN
				'Y'
			ELSE
				CASE WHEN @IsManager = 'Y' AND a.ismanagerial = 'Y'
				THEN 
					'Y'
				ELSE
					'N'
				END
			END
		ELSE
			ra.granted
		END = 'Y'
	ORDER BY tab, tabbasedsort
END

