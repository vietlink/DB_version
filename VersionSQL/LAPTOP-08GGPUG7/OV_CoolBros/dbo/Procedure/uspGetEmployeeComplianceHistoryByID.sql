/****** Object:  Procedure [dbo].[uspGetEmployeeComplianceHistoryByID]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetEmployeeComplianceHistoryByID](@id int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT ech.* FROM EmployeeComplianceHistory ech
	 WHERE ech.id = @id;
END


