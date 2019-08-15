/****** Object:  Procedure [dbo].[uspCheckChildExists]    Committed by VersionSQL https://www.versionsql.com ******/

  
CREATE PROCEDURE [dbo].[uspCheckChildExists]     
 (  
  @PositionId int,
  @Allocated int output    
 )    
     
AS    
BEGIN    
    
set @Allocated =(select COUNT(id) from Position where parentid =@PositionId  )    
if(@Allocated is null)    
 set @Allocated =0    
return @Allocated    
    
END 



