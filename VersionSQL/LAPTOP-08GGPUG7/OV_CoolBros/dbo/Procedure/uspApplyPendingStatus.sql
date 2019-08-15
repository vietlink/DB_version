/****** Object:  Procedure [dbo].[uspApplyPendingStatus]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspApplyPendingStatus](@empId int, @nowDate datetime)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    DECLARE @commencement DATETIME;
	DECLARE @pendingDesc varchar(255);

	SELECT @pendingDesc = [description] FROM [status] WHERE code = 'pc';

	SELECT @commencement = commencement FROM Employee where ID = @empId;
	IF @commencement > @nowDate BEGIN
		UPDATE Employee SET [status] = @pendingDesc WHERE ID = @empId AND IsPlaceholder = 0;
	END
END

