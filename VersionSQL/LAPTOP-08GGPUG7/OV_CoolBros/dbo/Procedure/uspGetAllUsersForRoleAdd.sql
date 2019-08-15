/****** Object:  Procedure [dbo].[uspGetAllUsersForRoleAdd]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetAllUsersForRoleAdd](@search varchar(255), @type varchar(255), @status varchar(255), @orderBy varchar(50), @roleId int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT U.[id],       
	U.[authenticationmethodid],       
	U.[accountname],       
	U.[password],       
	U.[displayname],       
	U.[enabled],      
	U.[usereditable],      
	case when u.[type] = 'BuiltIn' THEN 'System Admin' ELSE u.[Type] END as type,    
	AM.name as [authentication],
	U.RequiresPasswordReset,
	U.WorkEmail,
	U.EmployeeIdentifier,
	CASE WHEN ru.id is null then 0 else 1 end as IsUserOnRole	         
	FROM [dbo].[User] U     
	INNER JOIN [dbo].[AuthenticationMethod] AM ON AM.id=U.authenticationmethodid
	LEFT OUTER JOIN
	RoleUser ru ON ru.userid = u.id and ru.roleid = @roleId
	WHERE U.IsDeleted = 0 AND (U.displayname like '%'+@search +'%' or U.accountname  like '%'+@search +'%')
	AND
	(@type = '' OR u.[type] = @type)
	AND
	(@status = '' OR
		(@status = 'HasLoggedIn' AND u.LastLoginDate IS NOT NULL) OR
		(@status = 'HasNeverLoggedIn' AND u.LastLoginDate IS NULL) OR
		(@status = 'EmailNotificationSent' AND u.HasBeenEmailed = 1) OR
		(@status = 'EmailNotificationNotSent' AND u.HasBeenEmailed = 0)
	)
	
	ORDER BY isnull(ru.roleid, 0) DESC, CASE @orderBy WHEN '' THEN U.accountname
		WHEN 'AccountName' THEN U.accountname
		WHEN 'DisplayName' THEN U.displayname
		WHEN 'Identifier' THEN U.EmployeeIdentifier
		WHEN 'Type' THEN CASE WHEN U.type = 'BuiltIn' THEN 'System Admin' ELSE U.type END
	END
END

