/****** Object:  Function [dbo].[fnCheckPermission]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Dale Gillin
-- Certain bits of data could be retrieved at SQL level
-- but due to how often this function gets called it has
-- been optimized for speed, we know some details like
-- is the user a manager and what not at the code level
-- so rather than fetching this at sql, we grab it once off
-- from the session
-- =============================================
CREATE FUNCTION [dbo].[fnCheckPermission](@loggedInPositionId int, @userId int, @attId int, @empId int, @posId int, @iAmManager bit)
RETURNS int
AS
BEGIN
	DECLARE @loggedInEmpId int = 0;

	-- find the logged in emp id by userid
	SELECT
		@loggedInEmpId = e.id
	FROM
		Employee e
	INNER JOIN
		[User] u
	ON
		u.accountname = e.accountname
	WHERE u.id = @userId

	DECLARE @granted varchar(1) = 'N';
	-- Get the attribute list for logged in user
	SELECT 
		@granted = ra.granted 	
	FROM 
		RoleAttribute ra
	INNER JOIN
		[Role] r
	ON
		ra.roleid = r.id
	INNER JOIN
		RoleUser ru
	ON
		ru.roleid = r.id
	WHERE
		ru.userid = @userid AND attributeid = @attId AND granted = 'Y'

	-- Check is personal/manager
	IF(@granted = 'N') BEGIN
		DECLARE @isPersonal varchar(1) = 'N';
		DECLARE @isManagerial varchar(1) = 'N';

		SELECT
			@isPersonal = IsPersonal,
			@isManagerial = IsManagerial
		FROM
			Attribute
		WHERE
			id = @attId

		IF(@isPersonal = 'Y' AND @loggedInEmpId = @empId)
			RETURN 1
		IF(@iAmManager = 1 AND @isManagerial = 'Y' AND dbo.fnIsChildOfParent(@loggedInPositionId, @posId) = 1)
			RETURN 1
		RETURN 0
	END
	-- Is granted
	RETURN 1
END


