/****** Object:  Procedure [dbo].[uspGetAllTimeShiftLoadingHeader]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[uspGetAllTimeShiftLoadingHeader] 
	-- Add the parameters for the stored procedure here
	@chkDelete bit, @filter varchar(max)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT *
	FROM TimeShiftLoadingHeader
	WHERE IsDeleted=@chkDelete
	AND IsCustom=0
	AND Description LIKE '%' +@filter +'%'

END

