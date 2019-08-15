/****** Object:  Procedure [dbo].[uspGetDefaultWorkHour]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[uspGetDefaultWorkHour](@filter varchar(50))
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF @filter = '' BEGIN
    SELECT * FROM DefaultWorkHours;
	END
	ELSE BEGIN
	SELECT * FROM DefaultWorkHours WHERE Day = @filter;
	END
END

