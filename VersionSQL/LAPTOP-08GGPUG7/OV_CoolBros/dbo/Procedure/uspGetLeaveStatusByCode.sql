/****** Object:  Procedure [dbo].[uspGetLeaveStatusByCode]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetLeaveStatusByCode](@code varchar(5))
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	IF (@code!='') BEGIN
		SELECT TOP 1 * FROM LeaveStatus WHERE code = @code;
	END ELSE BEGIN
		SELECT * FROM LeaveStatus
	END
END
