/****** Object:  Procedure [dbo].[uspGetPositionInfoByEmployeeId]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetPositionInfoByEmployeeId](@employeeId int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @id int = 0;
	SELECT @id = id FROM EmployeePosition WHERE employeeid = @employeeId AND primaryposition = 'Y' AND IsDeleted = 0
	IF @id > 0 BEGIN
		SELECT TOP 1 id, employeeid, positionid, primaryposition FROM EmployeePosition WHERE employeeid = @employeeId AND primaryposition = 'Y' AND IsDeleted = 0
	END
	ELSE BEGIN
		SELECT TOP 1 id, employeeid, positionid, primaryposition FROM EmployeePosition WHERE employeeid = @employeeId AND primaryposition = 'Y'
	END
END

