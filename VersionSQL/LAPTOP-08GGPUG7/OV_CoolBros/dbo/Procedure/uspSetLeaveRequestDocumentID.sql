/****** Object:  Procedure [dbo].[uspSetLeaveRequestDocumentID]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspSetLeaveRequestDocumentID](@leaveRequestId int, @documentId int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    UPDATE LeaveRequest SET DocumentID = @documentId WHERE id = @leaveRequestId;
END

