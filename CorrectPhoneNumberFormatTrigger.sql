USE Northwind
  
  CREATE FUNCTION Correct_Format_Phone_Number(@Number NVARCHAR(24))
  RETURNS NVARCHAR(24) AS
  BEGIN

  DECLARE @CorrectFormat NVARCHAR(24)
  
IF(LEN(@Number)=10)
BEGIN
 SET @CorrectFormat = '+94'+ '('+(SUBSTRING(@Number,1,3))+')'+' ' +(SUBSTRING(@Number,4,3))+' '+ (SUBSTRING(@Number,7,2))+' '
+ (SUBSTRING(@Number,9,2))
END
ELSE IF(LEN(@Number)=11)
BEGIN
 SET @CorrectFormat ='+9'+(SUBSTRING(@Number,1,1))+ '('+(SUBSTRING(@Number,2,3))+')'+' ' +(SUBSTRING(@Number,5,3))+' '+ (SUBSTRING(@Number,8,2))+' '
+ (SUBSTRING(@Number,10,2))
END
ELSE IF(LEN(@Number)=12)
BEGIN
 SET @CorrectFormat ='+'+(SUBSTRING(@Number,1,2))+ '('+(SUBSTRING(@Number,2,3))+')'+' ' +(SUBSTRING(@Number,5,3))+' '+ (SUBSTRING(@Number,8,2))+' '
+ (SUBSTRING(@Number,10,2))
END
ELSE IF(LEN(@Number)=13 AND SUBSTRING(@Number,1,3)='+994' OR SUBSTRING(@Number,1,3)='+94'  )
BEGIN
 SET @CorrectFormat =(SUBSTRING(@Number,1,3))+ '('+(SUBSTRING(@Number,4,3))+')'+' ' +(SUBSTRING(@Number,7,3))+' '+ (SUBSTRING(@Number,10,2))+' '
+ (SUBSTRING(@Number,12,2))
END
  RETURN @CorrectFormat
  END

  go

CREATE TRIGGER TRG_PhoneFormatInstead
on SHIPPERS 
INSTEAD OF INSERT
as
DECLARE @Number NVARCHAR(24)
SELECT @Number=PHONE from INSERTED

IF((SELECT  DBO.Correct_Format_Phone_Number(@Number) FROM INSERTED) IS NOT  NULL)
BEGIN
  insert SHIPPERS VALUES('Codeacademy',(SELECT  DBO.Correct_Format_Phone_Number(@Number) FROM INSERTED))
END
ELSE
BEGIN
  PRINT 'Dont insert record'
END
select * from Shippers

-----------------------Test------------------------------
delete from Shippers where CompanyName='Codeacademy'
--Correct format example
insert Shippers values('Codeacademy','+940505940409')
insert Shippers values('Codeacademy','940505940409')
insert Shippers values('Codeacademy','40505940409')
insert Shippers values('Codeacademy','0505940409')
--Incorrect format example
insert Shippers values('Codeacademy','505940409')
insert Shippers values('Codeacademy','5940409')