/****** Object:  Procedure [dbo].[uspGetEmployeeStatusHistory]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetEmployeeStatusHistory](@employeeId int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT esh.*, s.[description] as [status] FROM EmployeeStatusHistory esh
	INNER JOIN [Status] s ON s.id = esh.StatusID
	WHERE employeeid = @employeeId
	ORDER BY esh.StartDate DESC, id DESC
END


