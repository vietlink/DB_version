/****** Object:  Procedure [dbo].[uspUpdateTerminatedFields]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspUpdateTerminatedFields](@empId int, @date datetime, @reason varchar(50), @regretLoss varchar(10))
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    UPDATE
		Employee
	SET
		termination = @date,
		TerminationReason = @reason,
		RegrettableLoss = @regretLoss
	WHERE
		id = @empId
END


