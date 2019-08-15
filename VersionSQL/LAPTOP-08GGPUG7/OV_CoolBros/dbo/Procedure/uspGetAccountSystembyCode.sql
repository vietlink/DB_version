/****** Object:  Procedure [dbo].[uspGetAccountSystembyCode]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[uspGetAccountSystembyCode] 
	-- Add the parameters for the stored procedure here
	@code varchar(20)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF (@code='') BEGIN
		SELECT * FROM AccountsSystem WHERE isDeleted=0
	END ELSE BEGIN
		SELECT * FROM AccountsSystem WHERE Code= @code AND isDeleted=0
	END
END

