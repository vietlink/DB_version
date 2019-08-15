/****** Object:  Procedure [dbo].[uspCheckCompetencyGroupContainsCompetency]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspCheckCompetencyGroupContainsCompetency](@groupid int, @description varchar(500), @code varchar(50), @currentId int = 0)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF EXISTS(
		SELECT 
			g.Id 
		FROM 
			CompetencyList l
		INNER JOIN 
			CompetencyGroups g
		ON 
			g.Id = l.CompetencyGroupId
		INNER JOIN
			Competencies c
		ON
			c.Id = l.CompetencyId
		WHERE
			c.[Description] LIKE @description AND g.Id = @groupid AND c.Id <> @currentId
	) BEGIN
		RETURN 1;
	END
	IF EXISTS(
		SELECT 
			g.Id 
		FROM 
			CompetencyList l
		INNER JOIN 
			CompetencyGroups g
		ON 
			g.Id = l.CompetencyGroupId
		INNER JOIN
			Competencies c
		ON
			c.Id = l.CompetencyId
		WHERE
			(c.[Code] <> '' AND c.[Code] LIKE @code) AND g.Id = @groupid AND c.Id <> @currentId
	) BEGIN
		RETURN 2;
	END
	ELSE
		RETURN 0;	
	END

