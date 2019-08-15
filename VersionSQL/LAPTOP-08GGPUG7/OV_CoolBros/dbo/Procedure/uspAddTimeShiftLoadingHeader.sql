/****** Object:  Procedure [dbo].[uspAddTimeShiftLoadingHeader]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[uspAddTimeShiftLoadingHeader]
	-- Add the parameters for the stored procedure here
	@id int, @code varchar(10), @description varchar(100), @returnVal int out
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF (@id>0) BEGIN
		UPDATE TimeShiftLoadingHeader 
		SET
		Code= @code,
		Description=@description
		WHERE ID=@id
		SET @returnVal=0
	END 
	ELSE BEGIN
		INSERT INTO TimeShiftLoadingHeader(Code, Description, IsDeleted, IsCustom) 
		VALUES (@code, @description, 0, 0)
		SET @returnVal=@@IDENTITY
	END
END

