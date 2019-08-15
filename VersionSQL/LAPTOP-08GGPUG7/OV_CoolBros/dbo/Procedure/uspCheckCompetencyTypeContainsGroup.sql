/****** Object:  Procedure [dbo].[uspCheckCompetencyTypeContainsGroup]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Dale>
-- Create date: <29/10/2014>
-- Description:	<Check if a type contains a group by name>
-- =============================================
CREATE PROCEDURE [dbo].[uspCheckCompetencyTypeContainsGroup] (@typeid int, @typeDescription varchar(500), @code varchar(50), @currentId int = 0)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    IF EXISTS (SELECT Id FROM CompetencyGroups WHERE TypeId = @typeid AND [Description] LIKE
    @typeDescription AND Id <> @currentId) BEGIN
		RETURN 1;
	END
	IF EXISTS (SELECT Id FROM CompetencyGroups WHERE TypeId = @typeid AND ([Code] <> '' AND [Code] LIKE
    @code) AND Id <> @currentId) BEGIN
		RETURN 2;
	END
	ELSE
		RETURN 0;
	END

