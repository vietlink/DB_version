/****** Object:  Procedure [dbo].[uspDeleteWorkProfileTemplate]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspDeleteWorkProfileTemplate](@id int, @isDeleted bit, @hardDelete bit)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	-- This has no integrity, just delete it
	--IF @hardDelete = 1 BEGIN
		DELETE FROM TimeWorkProfileTemplate WHERE ID = @id;
	--	RETURN;
--	END
	
--	UPDATE TimeWorkProfileTemplate SET IsDeleted = @isDeleted WHERE ID = @id;

		
		
END

