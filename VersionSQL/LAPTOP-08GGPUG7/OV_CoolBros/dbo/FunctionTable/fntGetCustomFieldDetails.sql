/****** Object:  Function [dbo].[fntGetCustomFieldDetails]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION [dbo].[fntGetCustomFieldDetails](@code varchar(20))
RETURNS TABLE 
AS
RETURN 
(
	
	SELECT
		a.id, a.shortname--, dbo.fnGetFieldDetailsByIDs(a.id, @empPosId, @employeeId, @positionId) as value
	FROM
		ChartCustomFields ccf
	INNER JOIN
		Attribute a
	ON
		ccf.AttributeId = a.id
--	WHERE ccf.code = @code

)


