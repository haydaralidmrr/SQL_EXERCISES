/*
Elimizde urunlerin karliligini hesaplamak uzere yazmis oldgumuz bir stored procedure var. bu procedure
icine ITEMID parametresini aliyor ve bir urun icin maliyet hesaplamasi yapiyor

Sadece GIDA kategorisindeki urunlerin ortalama karliligini hesaplamak istiyoruz
bunun icin cursor ile gida kategorsindeki herbir urun icin bu stored proceduru calistirip sonucunu bir tabloya
atacak sekilde ve ortalama karliligi hesaplayacak bir TSQL cumlesi yaziniz.
*/

ALTER PROC GETITEMINCOME
@ITEMID AS INT
AS
BEGIN
SELECT I.ID, I.ITEMCODE,I.ITEMNAME,I.CATEGORY1,I.CATEGORY2,I.CATEGORY3,
I.UNITPRICE, SUM(OD.AMOUNT)TOTALAMOUNT, SUM(OD.LINETOTAL)TOTALSALES,
I.UNITPRICE*SUM(OD.AMOUNT) COST, SUM(OD.LINETOTAL) /(I.UNITPRICE*SUM(OD.AMOUNT))-1 INCOMEPERCENT
FROM ORDERDETAILS OD
JOIN ITEMS I ON I.ID= OD.ITEMID
WHERE I.ID=@ITEMID
GROUP BY  I.ID, I.ITEMCODE,I.ITEMNAME,I.CATEGORY1,I.CATEGORY2,I.CATEGORY3,
I.UNITPRICE
END

EXEC GETITEMINCOME @ITEMID =12