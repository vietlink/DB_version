/****** Object:  Procedure [dbo].[uspAddDocument]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspAddDocument](@fileName varchar(260), @storeName varchar(100), @directory varchar(260), @dataId int, @type varchar(50), @size varchar(20), @enabled bit, @isDeleted bit, @createdDate DateTime, @createdBy varchar(100))
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	IF NOT EXISTS (SELECT TOP 1 * FROM Documents WHERE (DataID = @dataId AND [FileName] LIKE @fileName) AND IsDeleted = 0) BEGIN
		INSERT INTO Documents([FileName], StoreName, Directory, DataID, PageType, Size, [Enabled], [IsDeleted], CreatedDate, CreatedBy)
			VALUES(@fileName, @storeName, @directory, @dataId, @type, @size, @enabled, @isDeleted, @createdDate, @createdBy)
		RETURN @@IDENTITY;
	END
	ELSE
		RETURN -1;
	END
	RETURN 0;

