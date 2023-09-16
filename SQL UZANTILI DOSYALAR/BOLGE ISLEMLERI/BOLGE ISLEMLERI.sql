					--BOLGE ISLEMLERI (Admin b�lge ad�n� ve b�lge �cretini silip-ekleyip-g�nceller.)

--BOLGE SILME EKLEME GUNCELLEME PROCEDURE (Admin yapmak istedi�i i�lemi @i�lem = 'yapmak istedi�i i�lem' �eklinde belirtir.)
ALTER PROCEDURE sp_B�lgeIslem(
	@islem AS NVARCHAR(20),
	@b�lgeadi AS NVARCHAR(50),
	@b�lgeturucreti AS INT,
	@b�lgeID AS INT
)
AS
BEGIN
	IF @islem = 'Bolge Ekleme' or @islem='B�lge Ekleme'
	BEGIN
		INSERT INTO BolgeDetaylari(BolgeAdi,BolgeTurUcreti)
		VALUES(@b�lgeadi,@b�lgeturucreti)
	END
	IF @islem = 'Bolge silme' or @islem = 'B�lge Silme'
	BEGIN
		DELETE FROM BolgeDetaylari WHERE BolgeAdi = @b�lgeadi or BolgeID = @b�lgeID 
	END
	IF @islem = 'B�lge g�ncelleme' or @islem = 'Bolge Guncelleme'
	BEGIN
		UPDATE BolgeDetaylari SET BolgeAdi = @b�lgeadi ,BolgeTurUcreti = @b�lgeturucreti WHERE BolgeID = @b�lgeID
	END
END

----------------------------------------------------------------------------------------------------------------------------------------------
						-- Bolge silme-ekleme-�cret g�ncelleme triggerleri (��lem yapan admin de�ilse sistem, i�lem yapana k�zar.)
-- 1-)Bolge fiyat g�ncelleme 
ALTER TRIGGER BolgeGuncelleme ON Bolgedetaylari
INSTEAD OF UPDATE
AS
BEGIN
	IF SUSER_NAME() != 'admin'
	BEGIN
		DECLARE @eski�cret AS int
		DECLARE @yeni�cret AS int
		
		SELECT @eski�cret = BolgeTurUcreti from deleted
		SELECT @yeni�cret = BolgeTurUcreti from inserted

		IF @eski�cret <> @yeni�cret
		BEGIN
			PRINT 'BOLGE UCRETI GUNCELLEME YETKINIZ YOK'
		END
	END
END
-----------------------------------------------------------------------

--2-) B�lge Silme
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

--3_)B�lge Ekleme
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