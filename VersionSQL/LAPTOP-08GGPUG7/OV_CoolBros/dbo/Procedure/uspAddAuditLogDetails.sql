/****** Object:  Procedure [dbo].[uspAddAuditLogDetails]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspAddAuditLogDetails](@auditLogID int, @attributeID int, @oldValue varchar(max), @newValue varchar(max), @description varchar(max))
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    INSERT INTO AuditLogDetails(AuditLogID, AttributeID, OldValue, NewValue, [Description])
		VALUES(@auditLogID, @attributeID, @oldValue, @newValue, @description);
END


