/****** Object:  Procedure [dbo].[uspCheckDoesCompetencyTypeExist]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspCheckDoesCompetencyTypeExist](@description varchar(500), @code varchar(50), @currentId int = 0)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    IF EXISTS (SELECT Id FROM CompetencyTypes WHERE [Description] LIKE @description AND Id <> @currentId) BEGIN
		RETURN 1;
	END
	IF EXISTS (SELECT Id FROM CompetencyTypes WHERE ([Code] <> '' AND [Code] LIKE @code) AND Id <> @currentId) BEGIN
		RETURN 2;
	END
	ELSE
		RETURN 0;
	END

