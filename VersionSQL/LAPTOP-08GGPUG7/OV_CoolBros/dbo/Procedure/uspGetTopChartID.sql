/****** Object:  Procedure [dbo].[uspGetTopChartID]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetTopChartID]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @id int = 0;
	SELECT TOP 1 @id = ID FROM EmployeePositionInfo WHERE positionparentid IS NULL AND IsVisible = 1 AND displayname <> 'Vacant';
	IF ISNULL(@id, 0) < 1 BEGIN
		SELECT TOP 1 @id = ID FROM EmployeePositionInfo WHERE positionparentid IS NULL AND IsVisible = 1;
	END

	SELECT @id AS ID
END

