/****** Object:  Procedure [dbo].[uspGetParentEmpPosId]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[uspGetParentEmpPosId]       
 (    
  @EmpPosId int,  
  @ParentEmpPosId int output      
 )      
       
AS      
BEGIN      
      
set @ParentEmpPosId =(
	select id from EmployeePositionInfo where id=
		(
			select top 1 epi.id from EmployeePositionInfo epi 
			inner join
			employeeposition ep
			on
			ep.id = epi.id
			inner join employee e
			on
			e.id = ep.employeeid
			inner join
			position p
			on
			p.id = ep.positionid
			where epi.positionid =(
				select positionparentid from EmployeePositionInfo where id=@EmpPosId 
			)
			and
			e.isdeleted = 0 and p.isdeleted = 0 and ep.isdeleted = 0 and epi.isvisible = 1

		)
	)
if(@ParentEmpPosId is null)      
 set @ParentEmpPosId =0      
return @ParentEmpPosId      
      
END

