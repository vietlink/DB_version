/****** Object:  Procedure [dbo].[uspDeleteCompetency]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspDeleteCompetency](@id int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DELETE FROM Competencies WHERE Id = @id;
	DELETE FROM CompetencyList WHERE CompetencyId = @id
END

