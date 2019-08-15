/****** Object:  Procedure [dbo].[uspGetEmpWeekByDate]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetEmpWeekByDate](@empId int, @date datetime)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    DECLARE @headerId int;
	SELECT @headerId = dbo.fnGetWorkHourHeaderIDByDay(@empId, @date);

	DECLARE @week int;
	EXEC @week = dbo.fnGetWeekByHeaderDate @headerId, @date;

	RETURN @week;
END

