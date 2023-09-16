                                 --REHBER EKLEME/CIKARMA/GUNCELLEME ISLEMLERI 
--REHBER ISLEMLERI PROCEDURE(Admin rehber ekler,çýkarýr ve ya günceller. Yapmak istediði iþlemi @islem= 'Yapmak istediði iþlem' þeklinde seçer.)
ALTER PROCEDURE sp_RehberIslemleri(
	@islem AS NVARCHAR(30),
	@rehberID AS INT ,
	@isim AS NVARCHAR(20),
	@Soyisim AS NVARCHAR(50),
	@dogumtarihi AS DATETIME,
	@cinsiyet AS NVARCHAR(1),
	@uyruk AS NVARCHAR (20),
	@numara AS INT,
	@bildigidiller1 AS NVARCHAR(50) = '',
	@bildigidiller2 AS NVARCHAR(50) = '',
	@bildigidiller3 AS NVARCHAR(50) = '',
	@bildigidiller4 AS NVARCHAR(50) = '',
	@degisecekdil AS NVARCHAR(50),
	@günceldil AS NVARCHAR (50)
)
AS 
BEGIN 
	--REHBER EKLEME
		IF @islem = 'Rehber Ekleme'
		BEGIN
			DECLARE @YeniRehberinID AS INT
			DECLARE @sayi AS INT
			SET @sayi = 0
			INSERT INTO Rehberler(Ad,SoyAd,DogumTarihi,Cinsiyet,Uyruk,TelefonNo)
			VALUES(@isim,@Soyisim,@dogumtarihi,@cinsiyet,@uyruk,@numara)
			SET @YeniRehberinID = (SELECT IDENT_CURRENT('Rehberler'))
			
			IF @bildigidiller1 != ''
			BEGIN
				INSERT INTO RehberlerinDilleri
				VALUES(@YeniRehberinID,@bildigidiller1)
			END
			IF @bildigidiller2 != ''
			BEGIN
				INSERT INTO RehberlerinDilleri
				VALUES(@YeniRehberinID,@bildigidiller2)
			END
			IF @bildigidiller3 != ''
			BEGIN
				INSERT INTO RehberlerinDilleri
				VALUES(@YeniRehberinID,@bildigidiller3)
			END
			IF @bildigidiller4 != ''
			BEGIN
				INSERT INTO RehberlerinDilleri
				VALUES(@YeniRehberinID,@bildigidiller4)
			END
			END
		

	--REHBER SILME
		IF @islem = 'Rehber Silme'
		BEGIN
			DELETE FROM Rehberler WHERE RehberID = @rehberID
			DELETE FROM RehberlerinDilleri WHERE RehberID = @rehberID
		END
	--REHBER GUNCELLEME
		IF @islem = 'Rehber Guncelleme' or @islem= 'Rehber Güncelleme'
		BEGIN
			UPDATE Rehberler 
			SET Ad = @isim,SoyAd = @Soyisim,DogumTarihi=@dogumtarihi,Cinsiyet=@cinsiyet,Uyruk = @uyruk,TelefonNo = @numara 
			WHERE RehberID = @rehberID
			
			UPDATE RehberlerinDilleri 
			SET KonustuguDil = @günceldil
			WHERE KonustuguDil = @degisecekdil

		END
END
-------------------------------------------------------------------------------------------------------------------------------------------
--Rehber islemleri Triggerleri(iþlem yapan admin deðilse sistem iþlem yapan kiþiye kýzar.)

-- REHBER EKLEME
ALTER TRIGGER RehberEkleme ON REHBERLER
INSTEAD OF INSERT
AS
BEGIN
	IF SUSER_NAME() != 'admin'
	BEGIN
		DECLARE @eklenenrehber AS int
		SELECT @eklenenrehber = COUNT(*) from inserted
		IF @eklenenrehber>0
		BEGIN
			PRINT 'REHBER EKLEME YETKINIZ YOK'
		END
	END
END
-------------------------------------------------------------------------------------------
--REHBER SILME
ALTER TRIGGER RehberSilme ON REHBERLER
INSTEAD OF DELETE
AS
BEGIN
	IF SUSER_NAME() != 'admin'
	BEGIN
		DECLARE @silinenrehber AS int
		SELECT @silinenrehber = COUNT(*) from deleted
		IF @silinenrehber>0
		BEGIN
			PRINT 'REHBER SILME YETKINIZ YOK'
		END
	END
END
----------------------------------------------------------------------------------------------
--REHBER GUNCELLEME
ALTER TRIGGER RehberGuncelleme ON REHBERLER
INSTEAD OF UPDATE
AS
BEGIN
	IF SUSER_NAME() != 'admin' and (SELECT COUNT(*) FROM deleted)>0 AND (SELECT COUNT(*) FROM inserted) >0
	BEGIN
		
			PRINT 'REHBER GUNCELLEME YETKINIZ YOK'
		
	END
END