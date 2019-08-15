/****** Object:  Procedure [dbo].[uspGetEmployeeUnderPosition]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[uspGetEmployeeUnderPosition] 
	-- Add the parameters for the stored procedure here
	@positionID int, @statusString varchar(max)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @statusTable TABLE (status varchar(max));

	IF CHARINDEX(',', @statusString, 0) > 0 BEGIN
		INSERT INTO @statusTable -- split the text by , and store in temp table
		SELECT CAST(splitdata AS varchar) FROM fnSplitString(@statusString, ',');	
    END
    ELSE IF LEN(@statusString) > 0 BEGIN -- if text existst without a , then assume 1 id
		INSERT INTO @statusTable(status) VALUES(@statusString);	
    END;
    -- Insert statements for procedure here
	WITH RPL (Id, ParentId, EmpPosId,employeeid, displayname, _status, ExclFromSubordCount,EpIsDeleted,PIsDeleted,IsPlaceHolder) AS
  (  select P.id,P.parentid,EP.id,EP.employeeid, e.displayname, e.status, EP.ExclFromSubordCount, ep.isdeleted, p.isdeleted, p.isplaceholder    
  from EmployeePosition EP 
  inner join employee e on e.id = ep.employeeid 
  inner join Position  P on P.id=EP.positionid 
  Where e.isdeleted = 0 and p.isdeleted = 0 and ep.isdeleted = 0 and p.IsUnassigned = 0 and P.parentid =@positionID 

     UNION ALL
       select P.id,P.parentid,EP.id,EP.employeeid, e.displayname, e.status, EP.ExclFromSubordCount, ep.isdeleted, p.isdeleted, p.isplaceholder    
	   from EmployeePosition EP, Employee e, Position P, RPL PARENT  
	   WHERE (P.id=EP.positionid and p.isdeleted = 0 and ep.isdeleted = 0) and e.id = ep.employeeid and e.isdeleted = 0 and p.IsUnassigned = 0 and PARENT.Id=P.parentid
  )
  SELECT distinct RPL.employeeid AS id, RPL.displayname
  FROM RPL
  WHERE ((SELECT COUNT(*) FROM @statusTable) = 0 OR _status IN (SELECT * FROM @statusTable))
  AND RPL.displayname !='Vacant'
END

