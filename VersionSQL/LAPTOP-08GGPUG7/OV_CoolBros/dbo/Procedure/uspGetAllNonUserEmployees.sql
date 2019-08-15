/****** Object:  Procedure [dbo].[uspGetAllNonUserEmployees]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetAllNonUserEmployees]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SELECT e.id, e.firstname, e.surname, e.displayname, e.accountname, ec.workemail FROM Employee e
	INNER JOIN EmployeeContact ec ON ec.employeeid = e.id
	 WHERE e.id not in
	(
		SELECT e.id FROM [User] u
		INNER JOIN Employee e
		ON u.accountname = e.accountname    
	) and len(e.accountname) > 1 and e.isplaceholder = 0
END

