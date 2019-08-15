/****** Object:  Procedure [dbo].[uspUpdateAccountName]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspUpdateAccountName](@empId int, @newValue varchar(255))
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @oldValue VARCHAR(255);
	SELECT @oldValue = accountname FROM Employee WHERE id = @empId;
    UPDATE [user] SET accountname = @newValue WHERE accountname = @oldValue
END


