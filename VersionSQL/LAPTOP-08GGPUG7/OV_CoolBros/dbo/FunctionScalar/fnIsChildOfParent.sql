/****** Object:  Function [dbo].[fnIsChildOfParent]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fnIsChildOfParent](@parentPos int, @childPos int)
RETURNS int
AS
BEGIN
DECLARE @itemFound int = null;

IF(@parentPos = @childPos) BEGIN
	RETURN 0;
END;

WITH grandchildren as
(
    SELECT p.ID ID
    FROM position p
    WHERE p.ID = @parentPos
    UNION ALL
    SELECT p2.ID
    FROM position p2  
    INNER JOIN grandchildren g ON p2.parentid = g.id
)

SELECT @itemFound = id
FROM grandchildren WHERE id = @childPos

IF @itemFound IS NOT NULL BEGIN
	RETURN 1
END
RETURN 0
END


