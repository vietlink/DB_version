/****** Object:  Procedure [dbo].[uspDeleteComments]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspDeleteComments](@headerId int, @newIdList varchar(max))
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @idTable TABLE(id int);
	IF CHARINDEX(',', @newIdList, 0) > 0 BEGIN
		INSERT INTO @idTable -- split the text by , and store in temp table
		SELECT CAST(splitdata AS int) FROM fnSplitString(@newIdList, ',');	
    END ELSE IF LEN(@newIdList) > 0 BEGIN
		INSERT INTO @idTable SELECT CAST(@newIdList AS int)
	END

    DELETE FROM TimesheetComments WHERE TimesheetHeaderID = @headerId AND id NOT IN (SELECT id FROM @idTable)
END

