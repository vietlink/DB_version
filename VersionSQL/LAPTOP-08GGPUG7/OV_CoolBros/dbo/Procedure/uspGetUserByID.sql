/****** Object:  Procedure [dbo].[uspGetUserByID]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetUserByID](@id int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT TOP 1 u.id, u.authenticationmethodid, u.accountname, u.password, u.displayname, u.enabled, u.usereditable,
	u.[type], u.ClientId, u.RequiresPasswordReset, u.HasBeenEmailed, isnull(ec.workemail, u.workemail) as workemail,
	u.LastLoginDate, u.EmployeeIdentifier FROM [User] u
	LEFT OUTER JOIN Employee e
	ON e.accountname = u.accountname
	LEFT OUTER JOIN
	EmployeeContact ec
	ON ec.employeeid = e.id
	WHERE u.id = @id;
END

