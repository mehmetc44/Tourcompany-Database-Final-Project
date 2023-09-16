					--BOLGE ISLEMLERI (Admin bölge adýný ve bölge ücretini silip-ekleyip-günceller.)

--BOLGE SILME EKLEME GUNCELLEME PROCEDURE (Admin yapmak istediði iþlemi @iþlem = 'yapmak istediði iþlem' þeklinde belirtir.)
ALTER PROCEDURE sp_BölgeIslem(
	@islem AS NVARCHAR(20),
	@bölgeadi AS NVARCHAR(50),
	@bölgeturucreti AS INT,
	@bölgeID AS INT
)
AS
BEGIN
	IF @islem = 'Bolge Ekleme' or @islem='Bölge Ekleme'
	BEGIN
		INSERT INTO BolgeDetaylari(BolgeAdi,BolgeTurUcreti)
		VALUES(@bölgeadi,@bölgeturucreti)
	END
	IF @islem = 'Bolge silme' or @islem = 'Bölge Silme'
	BEGIN
		DELETE FROM BolgeDetaylari WHERE BolgeAdi = @bölgeadi or BolgeID = @bölgeID 
	END
	IF @islem = 'Bölge güncelleme' or @islem = 'Bolge Guncelleme'
	BEGIN
		UPDATE BolgeDetaylari SET BolgeAdi = @bölgeadi ,BolgeTurUcreti = @bölgeturucreti WHERE BolgeID = @bölgeID
	END
END

----------------------------------------------------------------------------------------------------------------------------------------------
						-- Bolge silme-ekleme-ücret güncelleme triggerleri (Ýþlem yapan admin deðilse sistem, iþlem yapana kýzar.)
-- 1-)Bolge fiyat güncelleme 
ALTER TRIGGER BolgeGuncelleme ON Bolgedetaylari
INSTEAD OF UPDATE
AS
BEGIN
	IF SUSER_NAME() != 'admin'
	BEGIN
		DECLARE @eskiücret AS int
		DECLARE @yeniücret AS int
		
		SELECT @eskiücret = BolgeTurUcreti from deleted
		SELECT @yeniücret = BolgeTurUcreti from inserted

		IF @eskiücret <> @yeniücret
		BEGIN
			PRINT 'BOLGE UCRETI GUNCELLEME YETKINIZ YOK'
		END
	END
END
-----------------------------------------------------------------------

--2-) Bölge Silme
ALTER TRIGGER BolgeSilme ON Bolgedetaylari
INSTEAD OF Delete
AS
BEGIN
	IF SUSER_NAME() != 'admin'
	BEGIN
		DECLARE @silinenkayitsayisi AS int
		
		SELECT @silinenkayitsayisi = COUNT(*) from deleted
		

		IF @silinenkayitsayisi>0
		BEGIN
			PRINT 'BOLGE SILME YETKINIZ YOK'
		END
	END
END
-----------------------------------------------------------------------

--3_)Bölge Ekleme
ALTER TRIGGER BolgeEkleme ON Bolgedetaylari
INSTEAD OF INSERT
AS
BEGIN
	IF SUSER_NAME() != 'admin'
	BEGIN
		DECLARE @eklenenkayitsayisi AS int
		
		SELECT @eklenenkayitsayisi = COUNT(*) from inserted
		

		IF @eklenenkayitsayisi>0
		BEGIN
			PRINT 'BOLGE EKLEME YETKINIZ YOK'
		END
	END

END
----------------------------------------------------------------------------