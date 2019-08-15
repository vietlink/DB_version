/****** Object:  Procedure [dbo].[uspDeleteEmployeeWorkHoursHeader]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspDeleteEmployeeWorkHoursHeader](@headerId int, @empId int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    DELETE FROM EmployeeWorkHours WHERE EmployeeWorkHoursHeaderID = @headerId;
	DELETE FROM EmployeeWorkHoursHeader WHERE id = @headerId;

	DECLARE @id int = 0;
	SELECT TOP 1 @id = id FROM EmployeeWorkHoursHeader WHERE EmployeeID = @empId ORDER BY DateFrom DESC
	UPDATE EmployeeWorkHoursHeader SET DateTo = NULL WHERE ID = @id;
END

