/****** Object:  Procedure [dbo].[uspAddTimesheetComment]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspAddTimesheetComment](@id int, @dateFor datetime, @dateAdded datetime, @comment varchar(max), @displayName varchar(255),
	@timesheetHeaderId int, @week int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF @id > 0 BEGIN
		UPDATE
			TimesheetComments
		SET
			Comment = @comment,
			DisplayName = @displayName
		WHERE
			ID = @id;
	END ELSE BEGIN
		INSERT INTO TimesheetComments(DateFor, DateAdded, Comment, DisplayName, TimesheetHeaderID, [Week])
			VALUES(@dateFor, @dateAdded, @comment, @displayName, @timesheetHeaderId, @week);
	END
END

