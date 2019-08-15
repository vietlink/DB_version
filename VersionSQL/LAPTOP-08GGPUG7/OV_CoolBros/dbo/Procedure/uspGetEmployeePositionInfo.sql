/****** Object:  Procedure [dbo].[uspGetEmployeePositionInfo]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE  PROCEDURE [dbo].[uspGetEmployeePositionInfo]  
   
(  
 @id int)  
  
  
/* ----------------------------------------------------------------------------------------------------------------  
 Name:  : uspGetEmployeePositionInfo  
 Description : Get record in the EmployeePositionInfo table with the matching primary key.  
 Author(s) : Clark Sayers  
 Date  : 01-October-2004  
 Notes  :  
-------------------------------------------------------------------------------------------------------------------  
 REVISIONS :  
 $Author  : $  
 $Date  : $  
 $History : $  
 $Revision  : $  
------------------------------------------------------------------------------------------------------------------- */  
    
AS  
  
SELECT EP.[id],   
 [employeeid],   
 [positionid],   
 [displaynameid],  
 EP.[displayname],
 E.picture,    
 [employeeimageurlid],   
 [employeeimageurl],   
 [positiontitleid],   
 [positiontitle],   
 [customfield1id],   
 [customfield1],   
 [customfield1value],   
 [customfield2id],   
 [customfield2],   
 [customfield2value],   
 [customfield3id],   
 [customfield3],   
 [customfield3value],   
 [customfield4id],   
 [customfield4],   
 [customfield4value],   
 [customicon1id],   
 [customicon1url],   
 [customicon1tooltip],   
 [customnavigate1url],   
 [customicon2id],   
 [customicon2url],   
 [customicon2tooltip],   
 [customnavigate2url],   
 [customicon3id],   
 [customicon3url],   
 [customicon3tooltip],   
 [customnavigate3url],   
 [customicon4id],   
 [customicon4url],   
 [customicon4tooltip],   
 [customnavigate4url],   
 [customicon5id],   
 [customicon5url],   
 [customicon5tooltip],   
 [customnavigate5url],   
 [emailid],   
 [email],   
 [haschildren],   
 [childcount],   
 isnull([directheadcount], 0) as directheadcount,
 isnull([totalheadcount], 0) as [totalheadcount],
 isnull([directftecount], 0) as [directftecount],
 isnull([totalftecount], 0) as [totalftecount], 
 [positionparentid],   
 AvS.name as availabilitystatus,   
 EP.[availabilitymessage],   
 [availabilityiconurl],
 IsVisible,
 IsAssistant,
 e.isplaceholder
FROM [dbo].[EmployeePositionInfo] EP INNER JOIN Employee E on E.id =EP.employeeid   LEFT OUTER JOIN AvailabilityStatus AvS on AvS.id=EP.availabilitystatus
WHERE EP.[id] = @id  
   
IF @@error != 0  
BEGIN  
 RAISERROR ('uspGetEmployeePositionInfo: Error reading record from [dbo].[EmployeePositionInfo]', 18, 1)  
 RETURN 1    
END  
   
RETURN 0


