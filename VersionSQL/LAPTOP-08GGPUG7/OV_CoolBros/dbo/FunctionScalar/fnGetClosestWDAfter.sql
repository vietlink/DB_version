/****** Object:  Function [dbo].[fnGetClosestWDAfter]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE FUNCTION [dbo].[fnGetClosestWDAfter] 
(
	-- Add the parameters for the function here
	@sickLeaveDate datetime, @empID int
)
RETURNS datetime
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Result datetime;
	DECLARE @currentDate datetime;
	SET @currentDate= DATEADD(DAY, 1, @sickLeaveDate);
	DECLARE @isFound bit;
	SET @isFound=0;
	
	-- Add the T-SQL statements to compute the return value here
	WHILE (@isFound <>1)
	BEGIN
		IF ((dbo.fnGetHoursInDay(@empID, @currentDate)>0) AND (dbo.fnIsSickLeaveDay(@currentDate, @empID)=0)) BEGIN 
			SET @isFound=1;
			SET @Result= @currentDate;
		END ELSE BEGIN 
			SET @isFound=0 ;
			SET @currentDate = DATEADD(DAY, 1, @currentDate);
		END
	END	

	-- Return the result of the function
	RETURN @Result

END

