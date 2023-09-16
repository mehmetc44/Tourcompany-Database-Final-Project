                                          
											--TUR SATISI YAPMA

--TUR SATISI EKRANI ICIN PROCEDURE(Admin Sadece Tur ID ve Turist ID yi girer. Gerisi triggerlere ait.)
ALTER PROCEDURE sp_TurSatisi(
@turID as int,
@TuristID AS INT)
AS
BEGIN

	IF SUSER_NAME() = 'admin'
	BEGIN
		INSERT INTO Faturadetay(TurID,TuristID)
		VALUES(@turID,@TuristID)
	END
END



--TurSatisi TRÝGGERÝ (SATIÞ YAPILDIKTAN SONRA OTAMATIK OLARAK NET UCRETI HESAPLAR. [60 YASINDAN BUYUKLER %15 INDIRIM ALIR]. FATURANUMARASI SOYLER. KESIM TARIHINI DE YAZAR.)
ALTER TRIGGER TurSatisi ON FaturaDetay
INSTEAD OF INSERT
AS
BEGIN
    IF SUSER_NAME()='Admin'
    BEGIN
		DECLARE @yil AS VARCHAR(4)
		DECLARE @Ay AS VARCHAR(2)
		DECLARE @gün AS VARCHAR(2)
		DECLARE @faturanumarasi AS nVARCHAR(25)
		DECLARE @kayitSayisi AS NVARCHAR(3)
		DECLARE @Netücret AS INT
		DECLARE @TuristID AS INT
		DECLARE @turID AS INT

		SET @turID = (SELECT TOP 1 TURID FROM inserted)

		SET @TuristID = (SELECT top 1 TuristID FROM inserted)
--FATURA NUMARASI OLUÞTURMA ISLEMI
		IF (SELECT TOP 1 CONVERT(DATE,KesimTarihi,104) FROM FaturaDetay ORDER BY KesimTarihi DESC) < (SELECT CONVERT(DATE,GETDATE(),104)) 
			OR (SELECT COUNT(*) FROM FaturaDetay) <=1
		BEGIN
			SET @kayitSayisi = '0'
		END

		ELSE
		BEGIN
			SET @kayitSayisi = CAST(CAST((SELECT TOP 1 SUBSTRING(FaturaNumarasý,12,3) FROM FaturaDetay ORDER BY KesimTarihi DESC) AS INT) + 1 AS NVARCHAR(3))
		END

		IF CAST((SELECT Month(GETDATE()))AS nvarchar(2)) LIKE '_' AND CAST((SELECT DAY(GETDATE())) AS nvarchar(2)) LIKE '_'
		BEGIN
			SET @Ay = '0' + CAST((SELECT Month(GETDATE())) AS nvarchar(2))
			SET @gün = '0' + CAST((SELECT day(GETDATE())) AS nvarchar(2))
		END
		ELSE 
		BEGIN
			SET @Ay = CAST((SELECT Month(GETDATE())) AS nvarchar(2))
			SET @gün = + CAST((SELECT day(GETDATE())) AS nvarchar(2))
		END
			SET @yil = CAST((SELECT YEAR(GETDATE())) AS VARCHAR(4)) 
			SET @kayitsayisi = CAST(@kayitsayisi AS NVARCHAR(9))
			SET @Faturanumarasi = CONCAT('FTR',@yil,@Ay,@gün,replicate('0', (3-len(@kayitSayisi))),@kayitSayisi)

--NET UCRETN HESAPLANDIGI YER	
		IF (SELECT top 1  YEAR(GETDATE())-year(dogumTarihi) FROM  Turistler WHERE TuristID = @TuristID)  > 60
		BEGIN
			SET @Netücret = (SELECT SUM(BolgeTurUcreti)
							 FROM inserted d
							 JOIN TurDetay Td ON d.TurID = td.TurID
							 JOIN BolgeDetaylari b on b.BolgeID = td.BolgeID
							 JOIN Turistler t ON t.TuristID = d.TuristID
							 WHERE t.turistID = @turistID AND td.TurID= @turID
							 GROUP BY d.TurID,t.TuristID
								 )*(0.85)
		END
		ELSE
		BEGIN
			SET @Netücret = (SELECT SUM(BolgeTurUcreti)
					         FROM inserted d
							 JOIN TurDetay Td ON d.TurID = td.TurID
							 JOIN BolgeDetaylari b on b.BolgeID = td.BolgeID
							 JOIN Turistler t ON t.TuristID = d.TuristID
							 WHERE t.turistID = @turistID AND td.TurID= @turID
							 GROUP BY d.TurID,t.TuristID)
		END	
-- ELDE EDILEN VERILERIN INSERT EDILMESI
		INSERT INTO FaturaDetay(KesimTarihi,FaturaNumarasý,NetUcret,TuristID,TurID)
		VALUES(GETDATE(),@faturanumarasi,@Netücret,@TuristID,@turID)
    END
	ELSE
	BEGIN
		PRINT 'TUR SATISI ICIN YETKINIZ YOKTUR'
	END
END