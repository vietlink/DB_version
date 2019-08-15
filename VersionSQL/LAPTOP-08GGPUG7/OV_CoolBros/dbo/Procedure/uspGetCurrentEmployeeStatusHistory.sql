/****** Object:  Procedure [dbo].[uspGetCurrentEmployeeStatusHistory]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetCurrentEmployeeStatusHistory](@empId int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT TOP 1 * FROM EmployeeStatusHistory WHERE EmployeeID = @empId ORDER BY StartDate DESC
    
END


