/****** Object:  Procedure [dbo].[uspDeleteEmployeeGroupAdmin]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspDeleteEmployeeGroupAdmin](@userid int, @groupid int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    DELETE FROM EmployeeGroupAdmin WHERE employeegroupid = @groupid AND userid = @userid
END

