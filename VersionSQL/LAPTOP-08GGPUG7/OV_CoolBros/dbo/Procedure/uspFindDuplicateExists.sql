/****** Object:  Procedure [dbo].[uspFindDuplicateExists]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE procedure [dbo].[uspFindDuplicateExists](@Tablename varchar(50),@Columnname varchar(50),@Value varchar(50),@Id int)
as
begin

Declare @ParamDefinition AS NVarchar(2000)   
declare @SQL nvarchar(1000)

SET  @ParamDefinition = ' @Tablename NVarchar(50),  
    @Columnname nvarchar(50),  
                @Value NVarchar(50),  
                @Id int'  
if(@Id =0)

SET @SQL='select '+@Columnname+' from '+@tablename+' where '+@Columnname+'='''+@Value +''''
else

SET @SQL='select '+@Columnname+' as Id from '+@tablename+' where '+@Columnname+'='''+@Value +''' and Id <> '+convert(varchar,@Id)+''


print @SQL
Execute sp_Executesql @SQL,  
    @ParamDefinition,   
                @Tablename,  
                @Columnname,  
                @Value,   
                @Id  
end

