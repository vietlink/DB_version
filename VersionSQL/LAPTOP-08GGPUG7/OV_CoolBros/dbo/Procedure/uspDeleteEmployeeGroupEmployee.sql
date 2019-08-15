/****** Object:  Procedure [dbo].[uspDeleteEmployeeGroupEmployee]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspDeleteEmployeeGroupEmployee](@empGroupId int, @empId int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DELETE FROM EmployeeGroupEmployee WHERE employeegroupid = @empGroupId AND employeeid = @empId;
END


