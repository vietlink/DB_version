/****** Object:  Function [dbo].[GetTimesheetAdjustmentCount]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[GetTimesheetAdjustmentCount](@headerId int)
RETURNS int
AS
BEGIN
	DECLARE @count int = 0;
    SELECT @count = COUNT(*) FROM TimeSheetAdjustments WHERE HeaderID = @headerId;
	RETURN @count;
END

