/****** Object:  Procedure [dbo].[uspDeletePositionRows]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE procedure [dbo].[uspDeletePositionRows]      
as      
begin      
delete from employeepositioninfo where positionid in (select id from position where iflag=0)  
  
delete from employeeposition where positionid in (select id from position where iflag=0)  
  
--delete from positionReference where Positionid in (select id from positionreference where iflag=0)  
        
delete from position where id in (select id from position where iflag=0)     
      
end
