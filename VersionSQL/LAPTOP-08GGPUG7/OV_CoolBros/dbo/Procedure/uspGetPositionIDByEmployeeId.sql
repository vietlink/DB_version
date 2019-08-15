/****** Object:  Procedure [dbo].[uspGetPositionIDByEmployeeId]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetPositionIDByEmployeeId](@employeeId int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @id int = 0;
	SELECT @id = id FROM EmployeePosition WHERE employeeid = @employeeId AND primaryposition = 'Y' AND IsDeleted = 0
	IF @id > 0 BEGIN
		SELECT TOP 1 id FROM EmployeePosition WHERE employeeid = @employeeId AND primaryposition = 'Y' AND IsDeleted = 0
	END
	ELSE BEGIN
		SELECT TOP 1 id FROM EmployeePosition WHERE employeeid = @employeeId AND primaryposition = 'Y'
	END
END


