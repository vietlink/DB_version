/****** Object:  Procedure [dbo].[uspGetTimeShiftLoadingHeaders]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetTimeShiftLoadingHeaders](@profileId int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @customId int = 0;
	SELECT @customId = timeshiftloadingheaderid FROM EmployeeWorkHoursHeader WHERE id = @profileId
    SELECT * FROM TimeShiftLoadingHeader WHERE IsDeleted = 0 AND (IsCustom = 0 OR ID = @customId)
	ORDER BY [Description]
END

