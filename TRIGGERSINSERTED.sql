CREATE TRIGGER THERMOVALUES_INSERT
ON THERMOVALUES
AFTER INSERT
AS
BEGIN

DECLARE @DEVICEID AS INT
DECLARE @VALUE AS FLOAT
DECLARE @DATE AS DATETIME

SELECT @DEVICEID=DEVICEID, @VALUE=VALUE_, @DATE=DATE_ FROM INSERTED

UPDATE THERMOMETERS
SET LASTVALUE=@VALUE, LASTDATE=@DATE
WHERE ID = @DEVICEID


END


DECLARE @I AS INT =0

WHILE @I<1000
BEGIN
	DECLARE @DEVICEID AS INT
	DECLARE @CURRENTVALUE AS FLOAT
	DECLARE @RAND AS FLOAT
	DECLARE @RAND2 AS INT
	SET @DEVICEID = 1+ RAND()*101
	DECLARE @DATE AS DATETIME

SELECT @DATE=MAX(DATE_) FROM THERMOVALUES WHERE DEVICEID=@DEVICEID

SET @DATE = ISNULL(@DATE,'2022-01-01')
SET @DATE = DATEADD(MINUTE,5,@DATE)
SET @RAND = 15+(15*(-0.5 + RAND()))
SET @CURRENTVALUE = ROUND(@RAND,2)

INSERT INTO THERMOVALUES (DEVICEID,VALUE_,DATE_)
VALUES(@DEVICEID,@CURRENTVALUE,@DATE)

SET @I = @I+1

END


select * from THERMOMETERS
