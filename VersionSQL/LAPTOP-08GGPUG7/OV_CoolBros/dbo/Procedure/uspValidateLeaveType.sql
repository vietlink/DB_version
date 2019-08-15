/****** Object:  Procedure [dbo].[uspValidateLeaveType]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspValidateLeaveType](@description varchar(100), @id int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    IF EXISTS (SELECT ID FROM LeaveType WHERE [Description] = @description AND id <> @id) BEGIN
		return -1;
	END

	return 0;
END

