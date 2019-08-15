/****** Object:  Procedure [dbo].[uspGetAverageDayWorkHours]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetAverageDayWorkHours](@empId int, @date DateTime)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @dateHeaderId int;
	EXEC @dateHeaderId = dbo.uspGetWorkHourHeaderIDByDay @empId, @date
    SELECT dbo.fnGetAverageDayWorkHours(@empId, @dateHeaderId) AS Average
END

