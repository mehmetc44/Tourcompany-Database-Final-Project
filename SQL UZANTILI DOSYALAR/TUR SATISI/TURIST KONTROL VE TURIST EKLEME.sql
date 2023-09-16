
									--TURSIT KONTROLU YAPMA 
		--(tursitin telefon numaras� ile Turist kontrol� yap�l�r. Turist sistemde kay�tl�ysa Kolayca bulunmas� i�in Ekrana ID si �a�r�l�r.)
		--(Kay�lt� de�ilse sp_TuristKayd�Yapma proced�r� ile turist kayd� kolayca yap�l�r.)

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
ALTER PROCEDURE sp_TuristKayd�Yapma (
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