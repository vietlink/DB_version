/****** Object:  Procedure [dbo].[uspGetPayrollByCode]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[uspGetPayrollByCode] 
	-- Add the parameters for the stored procedure here
	@id int	   
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT 
	p.ID as id,
	p.Code as code,
	p.FromDate as FromDate,
	p.ToDate as ToDate,
	p.ClosedDate as ClosedDate,
	p.ClosedByEmpID as empID,
	ps.Code as statuscode,
	ps.Description as status,
	u.displayname as ClosedBy		
	from PayrollCycle p
	inner join PayrollStatus ps on p.PayrollStatusID=ps.ID		
	left outer join [User] u on p.ClosedByEmpID= u.id
	where p.ID= @id
END
