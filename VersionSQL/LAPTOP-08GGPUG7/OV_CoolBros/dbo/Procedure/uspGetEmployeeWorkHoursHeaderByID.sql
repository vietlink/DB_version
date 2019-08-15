/****** Object:  Procedure [dbo].[uspGetEmployeeWorkHoursHeaderByID]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetEmployeeWorkHoursHeaderByID](@id int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT 
		h.*, th.IsCustom as IsShiftLoadingCustom, r.Value as DefaultOvertimeRate
	FROM 
		EmployeeWorkHoursHeader h 
	LEFT OUTER JOIN
		TimeShiftLoadingHeader th
	ON
		th.ID = h.TimeShiftLoadingHeaderID
	LEFT OUTER JOIN
		LoadingRate r
	ON
		r.ID = NormalOvertimeRate
	WHERE 
		h.id = @id;
END
