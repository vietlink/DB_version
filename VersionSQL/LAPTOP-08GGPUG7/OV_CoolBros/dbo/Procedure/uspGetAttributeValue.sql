/****** Object:  Procedure [dbo].[uspGetAttributeValue]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[uspGetAttributeValue](@AttributeId int,@EmpId int,@EntityId int)
AS
BEGIN

declare @ColumnCode nvarchar(100)
declare @ParamDefinition nvarchar(100)
declare @SQL nvarchar(1000)
declare @TableName varchar(50)

SET @TableName =(select tablename from Entity where id =@EntityId )
SET  @ParamDefinition = ' @ColumnF NVarchar(50),@EmpId int,@TableName nvarchar(50)'  
set @ColumnCode =(select columnname  from Attribute where id=@AttributeId)
SET @SQL ='select '+ @ColumnCode +' from '+@TableName+' where ID='''+convert(varchar,@EmpId)+''''
PRINT @sql
Execute sp_Executesql @SQL,  
    @ParamDefinition,   
                @ColumnCode,@EmpId,@TableName
END
