/****** Object:  Procedure [dbo].[uspUpdateGroupIdentifier]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspUpdateGroupIdentifier](@empId int, @identifier varchar(100))
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @posId int = 0;
	SELECT @posId = id FROM Position WHERE identifier = (SELECT TOP 1 Identifier FROM Employee WHERE ID = @empId)

	IF @posId > 0 BEGIN
		UPDATE Position SET identifier = @identifier WHERE id = @posId;
		UPDATE Employee SET identifier = @identifier WHERE id = @empId;
	END
    
END


