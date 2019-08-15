/****** Object:  Procedure [dbo].[uspGetPreferenceIcons]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetPreferenceIcons]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT * FROM 
		Preference p
	INNER JOIN 
		ApplicationPreference ap
	ON 
		p.id = ap.preferenceid
	WHERE
		code IN ('customicon1url', 'customicon2url', 'customicon3url', 'customicon4url', 'customicon5url')
END


