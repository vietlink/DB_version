/****** Object:  Procedure [dbo].[uspAddUpdateComplianceNotificationDetails]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspAddUpdateComplianceNotificationDetails](@emailTo varchar(2000), @emailEmployeeExpired bit,
	@emailDue bit, @emailExpired bit, @emailAfter bit, @emailAfterDays int, @headerExpired varchar(2000), @checkNotificationDays int, @dueDays int, @headerDue varchar(2000), @headerExpireAfter varchar(2000),
	@headerEmpExpired varchar(2000), @headerEmpDue varchar(2000), @headerEmpExpireAfter varchar(2000), @emailEmployeeDue bit, @emailEmployeeExpireAfter bit)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    IF NOT EXISTS (SELECT ID FROM ComplianceNotificationDetails) BEGIN
		INSERT INTO ComplianceNotificationDetails(emailTo, emailEmployeeExpired, emailDue, emailExpired, emailAfter, emailAfterDays, headerExpired, checkNotificationDays, dueDays, headerDue, headerExpireAfter, HeaderEmpExpired, HeaderEmpDue, HeaderEmpExpireAfter, EmailEmployeeDue, EmailEmployeeExpireAfter)
			VALUES(@emailTo, @emailEmployeeExpired, @emailDue, @emailExpired, @emailAfter, @emailAfterDays, @headerexpired, @checkNotificationDays, @dueDays, @headerDue, @headerExpireAfter, @headerEmpExpired, @headerEmpDue, @headerEmpExpireAfter, @emailEmployeeDue, @emailEmployeeExpireAfter)
	END 
	ELSE BEGIN
		UPDATE
			ComplianceNotificationDetails
		SET
			emailTo = @emailTo,
			emailEmployeeExpired = @emailEmployeeExpired,
			emailDue = @emailDue,
			emailExpired = @emailExpired,
			emailAfter = @emailAfter,
			emailAfterDays = @emailAfterDays,
			headerexpired = @headerExpired,
			checkNotificationDays = @checkNotificationDays,
			dueDays = @dueDays,
			headerDue = @headerDue,
			headerExpireAfter = @headerExpireAfter,
			HeaderEmpExpired = @headerEmpExpired,
			HeaderEmpDue = @headerEmpDue,
			HeaderEmpExpireAfter = @headerEmpExpireAfter,
			EmailEmployeeDue = @emailEmployeeDue,
			EmailEmployeeExpireAfter = @emailEmployeeExpireAfter
	END
END


