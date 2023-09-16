--TURUN TANIMLANMASI  (ADM�N TUR TANIMI YAPAR VE B�LGELER� ID ARACILI�IYLA SE�ER. TURLARI ADMIN , TUR DETAYI SISTEM DOLDURULMU� OLUR.)


			--TUR TANIMLAMA S.PROCEDURE
ALTER PROCEDURE sp_TurTan�mlama (
	 @b�lgeID1 AS INT = '',
	 @b�lgeID2 AS INT = '',
	 @b�lgeID3 AS INT = '',
	 @rehberID AS INT,
	 @turtarihi AS DATETIME,
	 @turad� AS NVARCHAR (150))
AS
BEGIN
		DECLARE @TurId AS INT 
--BOLGE GIRISI
		IF SUSER_NAME() = 'Admin'
		BEGIN
		
			INSERT INTO Turlar(TurAd�,RehberID,TurTarihi)
			VALUES(@turad�,@rehberID, @turtarihi)

			SET @TurId = SCOPE_IDENTITY()
			
			IF @b�lgeID1 != ''
			BEGIN
			INSERT INTO TurDetay
			Values(@TurId,@b�lgeID1)
			END

			IF @b�lgeID2 != ''
			BEGIN
			INSERT INTO TurDetay
			Values(@TurId,@b�lgeID2)
			END

			IF @b�lgeID3 != ''
			BEGIN
			INSERT INTO TurDetay
			Values(@TurId,@b�lgeID3)
			END
		END
		ELSE
		BEGIN
			PRINT 'Bu i�ilem i�in yetkiniz yoktur.'
		END
END

