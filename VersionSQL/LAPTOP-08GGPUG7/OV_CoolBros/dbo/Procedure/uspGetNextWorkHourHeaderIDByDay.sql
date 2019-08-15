/****** Object:  Procedure [dbo].[uspGetNextWorkHourHeaderIDByDay]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetNextWorkHourHeaderIDByDay](@empId int, @date datetime)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    DECLARE @id int;

	SELECT TOP 1 @id = ISNULL(id, 0) FROM EmployeeWorkHoursHeader WHERE EmployeeID = @empId AND (DateFrom > @date)
	ORDER BY DateFrom ASC

	RETURN @id;
END

