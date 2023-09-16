
									--TURSIT KONTROLU YAPMA 
		--(tursitin telefon numarasý ile Turist kontrolü yapýlýr. Turist sistemde kayýtlýysa Kolayca bulunmasý için Ekrana ID si çaðrýlýr.)
		--(Kayýltý deðilse sp_TuristKaydýYapma procedürü ile turist kaydý kolayca yapýlýr.)

CREATE PROCEDURE sp_TuristKontrol(
	@telefonno AS INT
)
AS
BEGIN
	DECLARE @a AS NVARCHAR(10) SET @a=  CAST((SELECT TOP 1 turistID FROM Turistler where TelefonNo = @telefonno) AS NVARCHAR(10))
	IF EXISTS(select * from Turistler where TelefonNo = @telefonno)
	BEGIN
		PRINT 'TURIST KAYITLI VE ID SI: ' + @a
	END
	ELSE 
	BEGIN
		PRINT 'KAYITLI OLMAYAN TURIST. LUTFEN TURIST KAYDI YAPINIZ.'
	END
END
------------------------------------------------------------------------------------------------------------------------------
ALTER PROCEDURE sp_TuristKaydýYapma (
	@Ad AS NVARCHAR(20),
	@Soyad AS NVARCHAR(50),
	@DogumTarihi AS DATETIME,
	@cinsyet AS CHAR(1),
	@Uyruk AS NVARCHAR(15),
	@GeldigiUlke AS NVARCHAR(15),
	@TelNo AS INT
)
AS
BEGIN
	IF SUSER_NAME() = 'Admin'
	BEGIN
		INSERT INTO Turistler(AD,SoyAd,DogumTarihi,Cisiyet,Uyruk,GeldigiUlke,TelefonNo)
		VALUES(@Ad,@Soyad,@DogumTarihi,@cinsyet,@Uyruk,@GeldigiUlke,@TelNo)
	END
	ELSE
	BEGIN
		PRINT 'BU ISLEM ICIN YETKINIZ YOK.'
	END
END