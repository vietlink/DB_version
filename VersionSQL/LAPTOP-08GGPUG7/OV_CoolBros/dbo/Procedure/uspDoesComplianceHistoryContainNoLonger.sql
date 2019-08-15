/****** Object:  Procedure [dbo].[uspDoesComplianceHistoryContainNoLonger]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspDoesComplianceHistoryContainNoLonger](@employeeid int, @listid int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT TOP 1 * FROM EmployeeComplianceHistory WHERE EmployeeID = @employeeid AND ListID = @listid AND NoLongerRequiredDate IS NOT NULL
END


