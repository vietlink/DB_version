/****** Object:  Procedure [dbo].[uspCheckPositionIsSubordinateorSuperior]    Committed by VersionSQL https://www.versionsql.com ******/


CREATE PROCEDURE [dbo].[uspCheckPositionIsSubordinateorSuperior](@LogedInUserPositionId int,@PositionId int,@Returnvalue int output)
AS
BEGIN
WITH RPL (Id, ParentId) AS
  (  select P.id,P.parentid  from EmployeePosition EP inner join Position  P on P.id=EP.positionid  Where P.parentid =@LogedInUserPositionId

     UNION ALL
       select P.id,P.parentid  from EmployeePosition EP, Position P, RPL PARENT  WHERE P.id=EP.positionid  and PARENT.Id=P.parentid 
  )select @Returnvalue = COUNT(id) from RPL where id=@PositionId
  if(@Returnvalue is null)
  SET @Returnvalue =0
  RETURN @Returnvalue
END
