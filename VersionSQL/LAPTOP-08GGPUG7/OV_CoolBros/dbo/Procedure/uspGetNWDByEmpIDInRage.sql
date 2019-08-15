/****** Object:  Procedure [dbo].[uspGetNWDByEmpIDInRage]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[uspGetNWDByEmpIDInRage] 
	-- Add the parameters for the stored procedure here
	@empID int, @fromDate datetime, @toDate datetime
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @NWD TABLE (_date datetime)
	WHILE (@fromDate <= @toDate) BEGIN
		DECLARE @hour decimal = isnull (dbo.fnGetHoursInDay(@empID, @fromDate),0)
		IF (@hour = 0) BEGIN
			INSERT INTO @NWD VALUES (@fromDate)
		END
		SET @fromDate = DATEADD(day, 1, @fromDate);
	END
	SELECT * FROM @NWD
END

