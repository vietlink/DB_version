/****** Object:  Procedure [dbo].[uspGetCurrentWorkHoursHeader]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetCurrentWorkHoursHeader](@empId int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    DECLARE @id int;
	SELECT @id = ISNULL(id, 0) FROM EmployeeWorkHoursHeader WHERE EmployeeID = @empId AND DateFrom <= GETDATE()
	ORDER BY DateFrom ASC

	RETURN @id;
	
END

