/****** Object:  Procedure [dbo].[uspGetPositionsParent]    Committed by VersionSQL https://www.versionsql.com ******/

  
CREATE PROCEDURE [dbo].[uspGetPositionsParent]     
 (  
  @PositionId int,
  @ParentId int output    
 )    
     
AS    
BEGIN    
    
set @ParentId =(select parentid  from Position where id =@PositionId  )    
if(@ParentId is null)    
 set @ParentId =0    
return @ParentId    
    
END 



