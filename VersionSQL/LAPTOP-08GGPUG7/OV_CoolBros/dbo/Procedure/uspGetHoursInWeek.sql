/****** Object:  Procedure [dbo].[uspGetHoursInWeek]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetHoursInWeek](@empId int, @date datetime)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @result decimal(18,8)
	SELECT @result = dbo.fnGetHoursInWeek(@empId, @date);

	SELECT ISNULL(@result, 0) as [Hours]
END

