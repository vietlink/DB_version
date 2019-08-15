/****** Object:  Procedure [dbo].[uspGetExcelFileDetails]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[uspGetExcelFileDetails]
AS
BEGIN

select id,code,value from Setting where code in ('ELF','PLF','EPLF','AELF','APLF','AEPLF')

END


