/****** Object:  Procedure [dbo].[uspGetPositionEntryGroups]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetPositionEntryGroups] (@search varchar(max), @type int = 0) -- 0 = all, 1 = edit only, 2 = add
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	
	SET NOCOUNT ON;
	SELECT
		eeg.*,
		(SELECT COUNT(*) FROM PositionEntryGroupRelations _eeg WHERE _eeg.PositionEntryGroupID = eeg.ID) as fieldcount
	FROM
		PositionEntryGroups eeg
	WHERE
		(code like '%'+@search +'%' or [description]  like '%'+@search +'%')
		AND
		(@type = 0 OR ((@type = 1 AND eeg.IsAddGroup = 0) OR (@type = 2 AND eeg.IsAddGroup = 1)))
	ORDER BY
		SortOrder
END


