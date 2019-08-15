/****** Object:  Procedure [dbo].[uspCheckPositionIsAssistant]    Committed by VersionSQL https://www.versionsql.com ******/

  
CREATE PROCEDURE [dbo].[uspCheckPositionIsAssistant]     
 (  
  @PositionId int,
  @Allocated int output    
 )    
     
AS    
BEGIN    
    
set @Allocated =(select case(Isassistant) when 'Y' then '1' when 'N' then '0' end as Isassistant  from Position where id =@PositionId  )    
if(@Allocated is null)    
 set @Allocated =0    
return @Allocated    
    
END 



