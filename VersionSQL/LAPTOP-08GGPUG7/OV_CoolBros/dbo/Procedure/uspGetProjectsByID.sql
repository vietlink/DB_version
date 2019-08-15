/****** Object:  Procedure [dbo].[uspGetProjectsByID]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[uspGetProjectsByID] 
	-- Add the parameters for the stored procedure here
	@id int, @filter varchar(300), @status bit
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	if (@id=0) begin
		select *, c.Description as client from Projects p
		inner join Clients c on p.ClientID= c.ID
		where (p.Description like '%'+@filter+'%' or p.Code like '%'+@filter+'%')
		and p.IsDeleted= @status
	end
	else begin
		SELECT *, c.Description as client from Projects p
		inner join Clients c on p.ClientID= c.ID
		where p.ID=@id and p.IsDeleted= @status
	end
END

