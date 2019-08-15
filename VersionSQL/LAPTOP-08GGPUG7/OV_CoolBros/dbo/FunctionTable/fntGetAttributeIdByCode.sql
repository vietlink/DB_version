/****** Object:  Function [dbo].[fntGetAttributeIdByCode]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION [dbo].[fntGetAttributeIdByCode](@code varchar(50))
RETURNS TABLE 
AS
RETURN 
(
	SELECT TOP 1 id FROM Attribute WHERE code = @code
)


