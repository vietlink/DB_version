/****** Object:  Procedure [dbo].[uspAddCompetency]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspAddCompetency](@groupid int, @code varchar(50), @description varchar(500), @sortOrder int, @enabled char(1), @type int, @scoreType int, @scoreValue int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @retVal int = -1;
	EXEC @retVal = uspCheckCompetencyGroupContainsCompetency @groupId, @description, @code, 0
	IF @retVal = 0 BEGIN
		INSERT INTO Competencies(Code, [Description], [Enabled], SortOrder, [Type], ComplianceScoreType, ComplianceScoreRange)
			VALUES(@code, @description, @enabled, @sortOrder, @type, @scoreType, @scoreValue);
		INSERT INTO CompetencyList(CompetencyGroupId, CompetencyId, [Enabled], SortOrder)
			VALUES(@groupId, @@IDENTITY, @enabled, @sortOrder);
		RETURN 0;
	END
	ELSE IF @retVal = 1 BEGIN
		RETURN -1;
	END
	ELSE IF @retVal = 2 BEGIN
		RETURN -2;
	END
END

