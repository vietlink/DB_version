/****** Object:  Procedure [dbo].[uspAddDataFileUpload]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspAddDataFileUpload](@fileName varchar(250), @filePath varchar(250), @type varchar(50), @CreatedDate DateTime, @CreatedBy varchar(100), @BatchID uniqueidentifier = null)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	INSERT INTO DataFileUpload([FileName], FilePath, [Type], CreatedDate, ProcessedDate, IsProcessed, CreatedBy, BatchID)
		VALUES(@fileName, @filePath, @type, @createdDate, NULL, 0, @CreatedBy, @BatchID);
	RETURN @@IDENTITY;
END

