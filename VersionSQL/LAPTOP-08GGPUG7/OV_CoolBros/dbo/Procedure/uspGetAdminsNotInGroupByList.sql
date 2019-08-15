/****** Object:  Procedure [dbo].[uspGetAdminsNotInGroupByList]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetAdminsNotInGroupByList] (@groupid int, @list varchar(max))
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @idTable TABLE(id int);

	IF CHARINDEX(',', @list, 0) > 0 BEGIN
		INSERT INTO @idTable -- split the text by , and store in temp table
		SELECT CAST(splitdata AS int) FROM fnSplitString(@list, ',');
    END
    ELSE IF LEN(@list) > 0 BEGIN -- if text existst without a , then assume 1 id
		INSERT INTO @idTable(id) VALUES(CAST(@list AS int));
    END
	SELECT *
	FROM [User] u
	WHERE u.IsDeleted = 0 and u.id in (select * from @idTable)
	ORDER By displayname 
END

