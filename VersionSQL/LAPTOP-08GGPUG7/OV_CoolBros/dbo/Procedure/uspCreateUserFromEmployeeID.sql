/****** Object:  Procedure [dbo].[uspCreateUserFromEmployeeID]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspCreateUserFromEmployeeID](@id int, @password varchar(max))
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @accountName varchar(256);
	DECLARE @displayName varchar(256);
	DECLARE @employeeIdentifier varchar(256);

	SELECT @accountName = accountname, @displayName = displayname, @employeeIdentifier = identifier from Employee
	WHERE id = @id;

	DECLARE @loadRoleID int;

	IF NOT EXISTS(SELECT accountname FROM [user] WHERE accountname = @accountName) BEGIN
		INSERT INTO [User](authenticationmethodid, accountname, [password], displayname, [enabled], usereditable, [type], RequiresPasswordReset, HasBeenEmailed, EmployeeIdentifier)
			VALUES(2, @accountName, @password, @displayName, 'Y', 'Y', 'Employee User', 1, 0, @employeeIdentifier);	
		
		SELECT @loadRoleID = id FROM Role WHERE IsLoadRole = 1
		INSERT INTO RoleUser(roleid, userid) VALUES(@loadRoleID, @@IDENTITY);
	END
	ELSE BEGIN
		UPDATE
			[user]
		SET
			IsDeleted = 0,
			[Password] = @password,
			RequiresPasswordReset = 1,
			HasBeenEmailed = 0
		WHERE
			accountname = @accountName

		DECLARE @userId int = 0;
		SELECT @userId = id FROM [user] WHERE accountname = @accountName
		SELECT @loadRoleID = id FROM Role WHERE IsLoadRole = 1
		INSERT INTO RoleUser(roleid, userid) VALUES(@loadRoleID, @userId);
	END

END

