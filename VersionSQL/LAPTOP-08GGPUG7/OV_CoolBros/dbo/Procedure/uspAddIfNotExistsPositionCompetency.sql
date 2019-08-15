/****** Object:  Procedure [dbo].[uspAddIfNotExistsPositionCompetency]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspAddIfNotExistsPositionCompetency](@compListId int, @positionId int, @isMandatory bit, @rankingId int = null)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF NOT EXISTS (SELECT CompetencyListId FROM PositionCompetencyList WHERE CompetencyListId = @compListId
	AND Positionid = @positionId) BEGIN -- add, it doesn't exist
		INSERT INTO PositionCompetencyList(Positionid, CompetencyListId, IsMandatory, RankingId)
			VALUES(@positionId, @compListId, @isMandatory, @rankingId);
	END
	ELSE -- update as it exists
		UPDATE
			PositionCompetencyList
		SET
			Rankingid = @rankingId,
			IsMandatory = @isMandatory
		WHERE
			CompetencyListId = @compListId AND Positionid = @positionid
	END


