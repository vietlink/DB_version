/****** Object:  Procedure [dbo].[uspAddAuditLogHeader]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspAddAuditLogHeader](@employeeId int, @positionId int, @dataId int, @createdBy varchar(255), @createdDate datetime, @auditLogTypeId int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    INSERT INTO AuditLog(EmployeeID, PositionID, DataID, CreatedBy, CreatedDate, AuditLogTypeID)
		VALUES(@employeeId, @positionId, @dataId, @createdBy, @createdDate, @auditLogTypeId)

	RETURN @@IDENTITY;
END


