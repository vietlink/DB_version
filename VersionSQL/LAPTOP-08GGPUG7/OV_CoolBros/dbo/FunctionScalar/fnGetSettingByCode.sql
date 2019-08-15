/****** Object:  Function [dbo].[fnGetSettingByCode]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fnGetSettingByCode](@code varchar(50))
RETURNS varchar(255)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @value varchar(255);
	SELECT @value = value FROM Setting WHERE code = @code
	RETURN @value;
END

