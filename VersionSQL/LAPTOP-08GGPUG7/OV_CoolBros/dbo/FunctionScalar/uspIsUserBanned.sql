/****** Object:  Function [dbo].[uspIsUserBanned]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[uspIsUserBanned](@UserID int)
RETURNS INT

AS
BEGIN
    IF EXISTS (SELECT ID FROM LoginBannedList WHERE UserID = @UserID)
		RETURN 1;
	RETURN 0;

END


