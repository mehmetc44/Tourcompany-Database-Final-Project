--TURUN TANIMLANMASI  (ADMÝN TUR TANIMI YAPAR VE BÖLGELERÝ ID ARACILIÐIYLA SEÇER. TURLARI ADMIN , TUR DETAYI SISTEM DOLDURULMUÞ OLUR.)


			--TUR TANIMLAMA S.PROCEDURE
ALTER PROCEDURE sp_TurTanýmlama (
	 @bölgeID1 AS INT = '',
	 @bölgeID2 AS INT = '',
	 @bölgeID3 AS INT = '',
	 @rehberID AS INT,
	 @turtarihi AS DATETIME,
	 @turadý AS NVARCHAR (150))
AS
BEGIN
		DECLARE @TurId AS INT 
--BOLGE GIRISI
		IF SUSER_NAME() = 'Admin'
		BEGIN
		
			INSERT INTO Turlar(TurAdý,RehberID,TurTarihi)
			VALUES(@turadý,@rehberID, @turtarihi)

			SET @TurId = SCOPE_IDENTITY()
			
			IF @bölgeID1 != ''
			BEGIN
			INSERT INTO TurDetay
			Values(@TurId,@bölgeID1)
			END

			IF @bölgeID2 != ''
			BEGIN
			INSERT INTO TurDetay
			Values(@TurId,@bölgeID2)
			END

			IF @bölgeID3 != ''
			BEGIN
			INSERT INTO TurDetay
			Values(@TurId,@bölgeID3)
			END
		END
		ELSE
		BEGIN
			PRINT 'Bu iþilem için yetkiniz yoktur.'
		END
END

