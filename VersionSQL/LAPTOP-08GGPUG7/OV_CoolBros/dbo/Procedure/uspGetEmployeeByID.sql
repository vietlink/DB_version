/****** Object:  Procedure [dbo].[uspGetEmployeeByID]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[uspGetEmployeeByID]      
(      
 @id udtId      
)      
/* ----------------------------------------------------------------------------------------------------------------      
 Name:  : uspGetEmployeeByID      
 Description : Retrieve all information for a given Employee ID from the Employee, EmployeeContact and EmployeeReference tables.      
 Author(s) : Alrie Coetzee      
 Date  : 03-April-2012      
 Notes  :      
-------------------------------------------------------------------------------------------------------------------      
 REVISIONS :      
 $Author  : Raji Prasad     
 $Date  : 16-01-2013      
 $History : If employee not entered his contact/reference information, system will throw an error      
 $Revision : Allow to show other details and allow to edit/delete employee, if there is no contact/referenc information.    
------------------------------------------------------------------------------------------------------------------- */      
       
       
AS      
      
       
       
 SELECT      
 e.[id],       
 e.[firstname],      
 e.[secondname],      
 e.[thirdname],      
 e.[surname],      
 e.[displayname],      
 e.[firstnamepreferred],      
 e.[title],      
 e.[picture],      
 e.[accountname],      
 e.[status],      
 e.[type],      
 CONVERT(VARCHAR(10), e.[dob], 111) as [dob],      
 --CONVERT(VARCHAR(10), e.[hired], 111) as [hired],      
 CONVERT(VARCHAR(10), e.[commencement], 111) as [commencement],      
 --CONVERT(VARCHAR(10), e.[service], 111) as [service],      
 CONVERT(VARCHAR(10), e.[termination], 111) as [termination],      
-- CONVERT(VARCHAR(10), e.[retirement], 111) as [retirement],      
 CONVERT(VARCHAR(10), e.[suspended], 111) as [suspended],      
 e.[gender],      
 e.[maritalstatus],      
 --e.[dependents],      
 e.[ethnicity],      
 e.[nationality],      
 --e.[healthnumber],      
 e.[annualleavedue],      
 e.[lsldue],      
 e.[location],      
 e.[age],      
 e.[companyserviceyears],      
 --e.[groupserviceyears],      
 e.[availabilitystatusid],      
 e.[availabilitymessage],      
 e.[identifier],      
ec.[employeeid],      
 ec.[homeline1],      
 ec.[homeline2],      
 ec.[homeline3],      
 ec.[homecity],      
 ec.[homestate],      
 ec.[homepostcode],      
 ec.[homecountry],      
 ec.[homephone],      
 --ec.[homefax],      
 ec.[homemobile],      
-- ec.[homepager],      
 ec.[homeemail],      
 ec.[homepostalline1],      
 ec.[homepostalline2],      
 ec.[homepostalline3],      
 ec.[homepostalcity],      
 ec.[homepostalstate],      
 ec.[homepostalpostcode],      
 ec.[homepostalcountry],      
 ec.[workline1],      
 ec.[workline2],      
 ec.[workline3],      
 ec.[workcity],      
 ec.[workstate],      
 ec.[workpostcode],      
 ec.[workcountry],      
 ec.[workphone],      
 ec.[workextension],      
 ec.[workfax],      
 ec.[workmobile],      
 ec.[workpager],      
 ec.[workemail],      
 ec.[workwebpage],      
 ec.[nokprimaryname],      
 ec.[nokprimaryrelationship],      
 ec.[nokprimaryline1],      
 ec.[nokprimaryline2],      
 ec.[nokprimaryline3],      
 ec.[nokprimarycity],      
 ec.[nokprimarystate],      
 ec.[nokprimarypostcode],      
 ec.[nokprimarycountry],      
 ec.[nokprimaryphone],      
 ec.[nokprimaryextension],      
 --ec.[nokfax],      
 ec.[nokprimarymobile],      
 --ec.[nokpager],      
 ec.[nokprimaryemail],
 e.originalcommencement,
 e.isplaceholder,
 e.isdeleted,
 e.availabilitymessage,
 avs.name as availabilitystatus,
 avs.icon as availabilityiconurl,
 e.PayrollID
--er.[employeeid],      
      , case when exists (select ep.id from EmployeePosition ep inner join position p on p.id = ep.positionid where ep.employeeid = @id AND p.IsUnassigned = 0 and ep.isdeleted = 0) then 1 else 0 end as hasposition
 FROM [dbo].[Employee] as e     
 left outer join      
 [dbo].[EmployeeContact] ec on e.id=ec.employeeid     
 left outer join AvailabilityStatus avs on avs.id = e.availabilitystatusid
 --left outer join  [dbo].[EmployeeReference] er  on er.employeeid=e.id    
 WHERE e.id =@id      
       
 IF @@error != 0      
 BEGIN      
        
RAISERROR ('General Error', 18, 1)      
      
  RETURN 1        
 END      
       
 RETURN 0
