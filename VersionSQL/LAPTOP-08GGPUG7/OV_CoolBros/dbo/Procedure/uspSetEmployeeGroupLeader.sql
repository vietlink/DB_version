/****** Object:  Procedure [dbo].[uspSetEmployeeGroupLeader]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspSetEmployeeGroupLeader](@groupid int, @employeeid int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    UPDATE EmployeeGroupEmployee SET IsLeader = 0 WHERE employeegroupid = @groupid
	UPDATE EmployeeGroupEmployee SET IsLeader = 1 WHERE employeegroupid = @groupid AND employeeid = @employeeid
END


