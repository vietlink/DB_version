/****** Object:  Function [dbo].[fnGetAttributeIdByCode]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fnGetAttributeIdByCode](@code varchar(100))
RETURNS int
AS
BEGIN
	-- Declare the return variable here
	DECLARE @id int = 0;
	SELECT @id = id FROM Attribute WHERE code = @code
	RETURN @id;

END


