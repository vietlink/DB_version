/****** Object:  Procedure [dbo].[uspUpdateEmployeeAvailabilityStatus]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[uspUpdateEmployeeAvailabilityStatus](@EmpPosId int,@StatusId int,@Message varchar(1000))  
AS  
BEGIN  
DECLARE @ICONURL varchar(100)  
SET @ICONURL=(select icon  from AvailabilityStatus where id=@StatusId )  
  
Update EmployeePositionInfo SET availabilityiconurl =@ICONURL ,availabilitymessage =@Message ,availabilitystatus=@StatusId, UpdatedAvailabilityMessageDateTime=GETUTCDATE()  where ID =@EmpPosId   
update Employee set availabilitymessage =@Message,availabilitystatusid=@StatusId,UpdatedAvailabilityMessageDateTime=GETUTCDATE() where id=(select employeeid from EmployeePositionInfo where id=@EmpPosId)
END

