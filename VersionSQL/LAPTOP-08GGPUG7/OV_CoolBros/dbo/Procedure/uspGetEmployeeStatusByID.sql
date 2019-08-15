/****** Object:  Procedure [dbo].[uspGetEmployeeStatusByID]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetEmployeeStatusByID](@id int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT esh.*, s.[description] as [status], s.code, s.DoSoftDelete, s.IsVisibleChart FROM EmployeeStatusHistory esh
	INNER JOIN [Status] s ON s.id = esh.StatusID
	WHERE esh.id = @id;
END


