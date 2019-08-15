/****** Object:  Procedure [dbo].[uspGetParentPositions]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetParentPositions](@positionId int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	WITH parents(id, title, parentid, parentLevel)
	AS
		(
		SELECT
			id,
			title,
			parentid,
			0 as parentLevel
		FROM
			Position
		WHERE id = @positionId AND IsDeleted = 0
		UNION ALL
		SELECT
			p.id,
			p.title,
			p.parentid,
			_p.parentLevel + 1
		FROM
			Position p
		INNER JOIN
			parents _p
		ON
			p.id = _p.parentid
		WHERE
			p.IsDeleted = 0
		)

	SELECT * from parents WHERE parentLevel <> 0 ORDER BY parentLevel desc
END


