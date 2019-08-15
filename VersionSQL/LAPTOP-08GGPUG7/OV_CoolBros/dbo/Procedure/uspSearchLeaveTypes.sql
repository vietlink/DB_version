/****** Object:  Procedure [dbo].[uspSearchLeaveTypes]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspSearchLeaveTypes](@search varchar(255))
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT * FROM LeaveType WHERE [Description] LIKE '%' + @search + '%' OR [ReportDescription] LIKE '%' + @search + '%'
	ORDER BY [Description]
END

