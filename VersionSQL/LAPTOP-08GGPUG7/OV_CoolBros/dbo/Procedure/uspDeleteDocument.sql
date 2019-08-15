/****** Object:  Procedure [dbo].[uspDeleteDocument]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspDeleteDocument](@id int, @deletedBy varchar(100), @deletedDate DateTime)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	UPDATE Documents SET IsDeleted = 1, DeletedBy = @deletedBy, DeletedDate = @deletedDate WHERE ID = @id;
END


