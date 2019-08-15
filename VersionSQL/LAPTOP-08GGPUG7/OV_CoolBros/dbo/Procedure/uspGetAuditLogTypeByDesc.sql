/****** Object:  Procedure [dbo].[uspGetAuditLogTypeByDesc]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetAuditLogTypeByDesc](@group varchar(255), @desc varchar(255))
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT TOP 1 * FROM AuditLogType WHERE [description] = @desc AND [grouping] = @group;
END


