/****** Object:  Procedure [dbo].[uspAddTimesheetApproverComment]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspAddTimesheetApproverComment](@id int, @displayName varchar(255), @dateAdded datetime, @comment varchar(max),
	@timesheetHeaderId int, @rejectedComment bit)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF @id > 0 BEGIN
		UPDATE
			TimesheetApproverComments
		SET
			Comment = @comment,
			DisplayName = @displayName
		WHERE
			ID = @id;
	END ELSE BEGIN
		INSERT INTO TimesheetApproverComments(DateAdded, Comment, TimesheetHeaderID, DisplayName, RejectedComment)
			VALUES(@dateAdded, @comment, @timesheetHeaderId, @displayName, @rejectedComment);
	END
END

