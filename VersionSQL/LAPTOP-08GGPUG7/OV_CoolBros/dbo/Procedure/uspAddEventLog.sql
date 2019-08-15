/****** Object:  Procedure [dbo].[uspAddEventLog]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspAddEventLog](@type int, @source varchar(50), @message varchar(8000), @createuser varchar(50), @createdatetime datetime, @datafileid int, @rownumber int, @action varchar(50)) 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    INSERT INTO EventLog(type, source, message, createuser, createdatetime, datafileid, rownumber, action)
		VALUES(@type, @source, @message, @createuser, @createdatetime, @datafileid, @rownumber, @action)
END


