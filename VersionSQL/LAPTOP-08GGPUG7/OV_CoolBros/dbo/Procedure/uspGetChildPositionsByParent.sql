/****** Object:  Procedure [dbo].[uspGetChildPositionsByParent]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetChildPositionsByParent](@positionId int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SELECT
		p.*
	FROM
		Position p
	WHERE
		parentid = @positionId AND p.IsDeleted = 0 AND p.IsUnassigned = 0
END


