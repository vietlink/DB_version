/****** Object:  Procedure [dbo].[uspGetCustomFieldDetails]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetCustomFieldDetails](@code varchar(20), @empPosId int, @employeeId int, @positionId int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT
		a.id, a.shortname, dbo.uspMiniGetFieldDetailsByIDs(a.id, @empPosId, @employeeId, @positionId) as value
	FROM
		ChartCustomFields ccf
	INNER JOIN
		Attribute a
	ON
		ccf.AttributeId = a.id
	WHERE ccf.code = @code
END


