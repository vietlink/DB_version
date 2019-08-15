/****** Object:  Procedure [dbo].[uspUpdateCompetency]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspUpdateCompetency](@id int, @groupid int, @code varchar(50), @description varchar(500), @sortOrder int, @enabled char(1), @type int, @scoreType int, @scoreValue int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @retVal int = -1;
	EXEC @retVal = uspCheckCompetencyGroupContainsCompetency @groupid, @description, @code, @id;
	
	IF @retVal = 0 BEGIN
		-- update the competency record
		UPDATE 
			Competencies
		SET
			Code = @code,
			[Description] = @description,
			SortOrder = @sortOrder,
			[Enabled] = @enabled,
			[Type] = @type,
			ComplianceScoreType = @scoreType,
			ComplianceScoreRange = @scoreValue
		WHERE
			Id = @id;
			
		-- update the list item
		UPDATE
			CompetencyList
		SET
			CompetencyGroupId = @groupid
		WHERE
			CompetencyId = @id AND CompetencyGroupId = @groupid;
	    
		RETURN 0;
    END
	ELSE IF @retVal = 1 BEGIN
		RETURN -1;
	END
	ELSE IF @retVal = 2 BEGIN
		RETURN -2;
	END
END

