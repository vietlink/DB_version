/****** Object:  Procedure [dbo].[uspCreateCustomShiftLoadingHeader]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspCreateCustomShiftLoadingHeader](@description varchar(255))
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    INSERT INTO TimeShiftLoadingHeader([Description], IsDeleted, IsCustom)
		VALUES(@description, 0, 1)

	RETURN @@IDENTITY;
END

