/****** Object:  Function [dbo].[fnConvertDayIndexToDate]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE FUNCTION [dbo].[fnConvertDayIndexToDate] 
(
	-- Add the parameters for the function here
	@index int
)
RETURNS varchar(9)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Result varchar(9)

	-- Add the T-SQL statements to compute the return value here
	
		IF @index=1 BEGIN SET @Result= 'Monday' END
		IF @index=2 BEGIN SET @Result='Tuesday' END
		IF @index=3 BEGIN SET @Result='Wednesday' END
		IF @index=4 BEGIN SET @Result='Thursday' END
		IF @index=5 BEGIN SET @Result='Friday' END
		IF @index=6 BEGIN SET @Result='Saturday' END
		IF @index=7 BEGIN SET @Result='Sunday' END
	-- Return the result of the function
	RETURN @Result

END

