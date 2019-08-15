/****** Object:  Procedure [dbo].[uspAddEmployeeGroupAdmin]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspAddEmployeeGroupAdmin](@userid int, @groupid int, @createdBy varchar(100), @createdDate datetime)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    IF NOT EXISTS(SELECT id FROM EmployeeGroupAdmin WHERE userid = @userid AND employeegroupid = @groupid) BEGIN
		INSERT INTO EmployeeGroupAdmin(userid, employeegroupid, createdby, createddate)
			VALUES(@userid, @groupid, @createdBy, @createdDate)
	END
END

