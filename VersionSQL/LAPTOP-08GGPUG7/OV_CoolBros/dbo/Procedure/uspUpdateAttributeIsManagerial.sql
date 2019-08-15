/****** Object:  Procedure [dbo].[uspUpdateAttributeIsManagerial]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspUpdateAttributeIsManagerial](@attid int, @granted varchar(1))
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    UPDATE
		Attribute
	SET
		ismanagerial = @granted
	WHERE
		id = @attid
END


