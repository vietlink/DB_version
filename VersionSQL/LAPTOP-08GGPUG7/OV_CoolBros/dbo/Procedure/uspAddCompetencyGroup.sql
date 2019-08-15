/****** Object:  Procedure [dbo].[uspAddCompetencyGroup]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspAddCompetencyGroup](@typeid int, @description varchar(500), @code varchar(50), @enabled char(1))
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @retValue int = -1;
    EXEC @retValue = uspCheckCompetencyTypeContainsGroup @typeid, @description, @code, 0
    
	DECLARE @maxSort int = 1;
	SELECT @maxSort = MAX(SortOrder) + 1 FROM CompetencyGroups WHERE TypeId = @typeid;

    IF(@retValue = 1) BEGIN
		RETURN -1; -- Group already exists under the given type
	END
	ELSE IF(@retValue = 2) BEGIN
		RETURN -2;
	END
	ELSE IF(@retValue = 0) BEGIN
		INSERT INTO CompetencyGroups(TypeId, Code, [Description], SortOrder, [Enabled])
			VALUES (@typeid, @code, @description, ISNULL(@maxSort, 1), @enabled);
		RETURN 0; -- success, group data
	END
	RETURN -1;
END

