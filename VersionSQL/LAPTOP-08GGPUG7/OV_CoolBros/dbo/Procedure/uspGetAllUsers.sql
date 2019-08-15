/****** Object:  Procedure [dbo].[uspGetAllUsers]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetAllUsers](@search varchar(255), @type varchar(255), @status varchar(255), @orderBy varchar(50))
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
	u.LastLoginDate		  
	,u.HasBeenEmailed       
	FROM [dbo].[User] U     
	LEFT OUTER JOIN Employee e ON U.accountname= e.accountname
	INNER JOIN [dbo].[AuthenticationMethod] AM ON AM.id=U.authenticationmethodid     
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
	
	ORDER BY 
	CASE WHEN @orderBy = 'accountname' THEN U.accountname END,
	CASE WHEN @orderBy = 'empid' THEN U.EmployeeIdentifier END,
	CASE WHEN @orderBy = 'loggedIn' THEN U.LastLoginDate END ASC,
	CASE WHEN @orderBy = 'loggedInDesc' THEN U.LastLoginDate END DESC,
	CASE WHEN @orderBy = 'name' THEN U.displayname END,
	CASE WHEN @orderBy = 'surname' THEN e.surname END,
	CASE WHEN @orderBy = 'accountType' THEN CASE WHEN U.type = 'BuiltIn' THEN 'System Admin' ELSE U.type END
	END 
END
