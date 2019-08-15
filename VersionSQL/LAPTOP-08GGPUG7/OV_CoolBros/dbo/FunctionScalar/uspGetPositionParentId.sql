/****** Object:  Function [dbo].[uspGetPositionParentId]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE FUNCTION [dbo].[uspGetPositionParentId](@PosId int)
RETURNs INT
AS
BEGIN

DECLARE @ParentId int
SET @ParentId =0
SET @ParentId =(select parentid  from Position  where id=@PosId) 
RETURN @ParentId
END


