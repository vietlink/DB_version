/****** Object:  Procedure [dbo].[uspGetEmployeeTypes]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetEmployeeTypes]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT DISTINCT case when isnull([type], '') = '' then '(Blank)' else [Type] end as [Type] FROM Employee WHERE IsDeleted = 0 ORDER BY [type]
END


