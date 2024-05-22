CREATE TABLE predmet_profesor_log (
id INT IDENTITY(1,1) PRIMARY KEY,
id_predmeta INT NOT NULL,
stari_profesor_id INT NOT NULL,
novi_profesor_id INT NOT NULL,
datum_promene DATETIME NOT NULL);
-- Kreiranje trigera trig_UpdatePredmetProfesor
CREATE TRIGGER trig_UpdatePredmetProfesor
ON predmet
AFTER UPDATE
AS
BEGIN
-- Provera da li se UPDATE koji je okinuo triger odnosi na id_profesora
IF UPDATE(ID_PROFESORA)
BEGIN
INSERT INTO predmet_profesor_log (id_predmeta, stari_profesor_id, novi_profesor_id, datum_promene)
SELECT deleted.ID_PREDMETA, deleted.ID_PROFESORA, inserted.ID_PROFESORA, GETDATE()
FROM inserted JOIN deleted ON inserted.ID_PREDMETA = deleted.ID_PREDMETA;
END END;Kreirati triger koji sprečava brisanje zapisa iz tabele Student. Korisniku ispisati poruku o zabrani brisanja zapisa.
CREATE TRIGGER trgInsteadOfDeleteStudent
ON Student
INSTEAD OF DELETE
AS
BEGIN
-- Poruka korisniku
print ('Brisanje studenata nije dozvoljeno.')
END;


Kreirati uskladištenu proceduru sa primenom transakcije koja smanjuje budzet projekta za zadati procenat i tako dobijena sredstva
dodaje drugom projektu.Procedura prihavat id projekta kome se smanjuju sredstva,id projekta kome se dodaju sredstva i procenat.
Create procedure sp_PrebaciSredstva1234(@idProjekta1 int, @idProjekta2 int, @procenat float) as
begin
declare @pom float
begin tran
Select @pom=budzet-budzet*@procenat/100
FROM projekat
WHERE idProjekat=@idProjekta1;
update Projekat
SET budzet=@pom
WHERE idProjekat=@idProjekta1;
if @@ROWCOUNT =0
begin
rollback /* ponistenje transakcije */
print('NEUSPEŠNO');
end
else
begin
update Projekat
SET budzet+=@pom
WHERE idProjekat=@idProjekta2;
if @@ROWCOUNT =0
begin
rollback
print('NEUSPEŠNO');
end
else
begin
commit /* potvrda transakcije */
print('USPEŠNO');
end
end
end




CREATE PROCEDURE sp_smanji_cene_i_dodeli
    @NoviIzvrsilacID INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;

    BEGIN TRY
        DECLARE @UkupnoSmanjenje DECIMAL(18, 2);
        DECLARE @BrojIzvrsioca INT;

        -- Izračunavanje ukupnog smanjenja od 1% za sve izvršioce
        SELECT @UkupnoSmanjenje = SUM(CenaRada * 0.01)
        FROM Izvrsioci
        WHERE IzvrsilacID <> @NoviIzvrsilacID;

        -- Smanjujemo cenu rada za 1% za sve izvršioce osim novog
        UPDATE Izvrsioci
        SET CenaRada = CenaRada * 0.99
        WHERE IzvrsilacID <> @NoviIzvrsilacID;

        -- Dodajemo ukupno smanjenje cene rada novom izvršiocu
        UPDATE Izvrsioci
        SET CenaRada = CenaRada + @UkupnoSmanjenje
        WHERE IzvrsilacID = @NoviIzvrsilacID;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;




CREATE TRIGGER trig_IzmenaOcene
ON Zapisnik
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO Zapisnik_history (id_studenta, id_ispita, bodovi, ocena, datum_izmene)
    SELECT 
        deleted.id_studenta,
        deleted.id_ispita,
        deleted.bodovi,
        deleted.ocena,
        GETDATE()
    FROM 
        deleted
    WHERE 
        deleted.ocena <> inserted.ocena;
END;


CREATE TRIGGER trig_Dodaj_OJ
ON organizaciona_jedinica
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO OJ_LOG (grad, adresa, datumDodavanja)
    SELECT 
        inserted.grad,
        inserted.adresa,
        GETDATE()
    FROM 
        inserted;
END;
