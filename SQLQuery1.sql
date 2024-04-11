
/* Kreirati pogled sa nazivom View_Student_2020 koji vraća podatke o studentima (ime,prezime i indeks) koji su
upisani 2020. godine.*/
create view Pogledi_Student 
as
select ime, prezime , smer , broj 
from student
where GODINA_UPISA in ('2020')

select * from Pogledi_Student
where smer in ('NRT')



/*Kreirati funkciju fun_Prosek_predmet koja vraća prosečnu 
ocenu studenata za zadati naziv predmeta.Prosečnu
ocenu zaokružiti na dve decimale.*/

create function fun_Prosek_predmeta (@nazivPredmeta nchar(30))
returns float 
as begin
declare @PROSEK_OCENA float
 select @PROSEK_OCENA  = AVG(ocena) 
 from zapisnik
 where ID_ISPITA in 
 (select ID_ISPITA from ispit 
 where ID_PREDMETA in (select ID_PREDMETA from predmet where NAZIV = @nazivPredmeta))
 return @PROSEK_OCENA
 end;

 select dbo.fun_Prosek_predmeta('Baze podataka') as Prosek
	

/*◾ Kreirati funkciju fun_Student_Smer koja za prosleđeni naziv smera vraća studente tog smera. TABELARNA*/create function fun_Student_smer (@smer nchar(10))returns tableas returnselect * from studentwhere smer in (@smer)select * from dbo.fun_Student_smer('NRT')/*Kreirati pogled View_Student_Ocena koji prikazuje ime, prezime, indeks i prosečnu
ocenu studenata.
create view View_Student*/
create view  view_student_ocena as
select ime , prezime , CONCAT(smer, '-' , broj , '/', godina_upisa) as indeks ,AVG(ocena)
from zapisnik , student
where zapisnik.ID_STUDENTA = student.ID_STUDENTA
group by ime , prezime , CONCAT(smer, '-' , broj , '/', godina_upisa)


/*Kreirati pogled View_Profesor_predmet koji prikazuje id profesora, ime, prezime i
nazive predmeta koji su mu dodeljeni.*/create view_Profesor_predmet asselect  profesor.ID_PROFESORA , ime , PREZIME ,  NAZIVfrom profesor , predmetwhere profesor.ID_PROFESORA = predmet.ID_PROFESORA/*Kreirati pogled View_Student_predmet koji prikazuje
ime, prezime, indeks studenata i nazive
predmeta koji su birali u školskoj 2020/21 godini*/

create view View_Student_predmet as
select ime, prezime, concat(smer,'-', broj,'/', godina_upisa),
naziv from student, predmet, student_predmet
where
student.ID_STUDENTA=student_predmet.ID_STUDENTA
and
predmet.ID_PREDMETA=student_predmet.ID_PREDMETA
and SKOLSKA_GODINA = '2020/21'

/*4. Kreirati pogled View_Ispitni_rok koji prikazuje spisak redovnih ispitnih rokova.*/
create view view_ispitni_rok
as
select * 
from ispitni_rok
where STATUS_ROKA in ('redovni')



6. Kreirati pogled koji prikazuje ime,prezime i kvalifikaciju izvršilaca i nazive projekata na kojima
rade.
CREATE VIEW Izvrsioci_projekti
as
SELECT ime,prezime,kvalif,naziv
FROM IZVRSILAC,UCESCE,PROJEKAT
WHERE IZVRSILAC.idIzvrsilac=UCESCE.idIzvrsilac AND
UCESCE.idProjekat=PROJEKAT.idProjekat
7. Kreirati pogled koji prikazuje izvršioce koji ne rade ni na jednom projektu.
CREATE VIEW izvrsioci_bez_projekta
as
SELECT *
FROM IZVRSILAC
WHERE idIzvrsilac NOT IN (SELECT idIzvrsilac FROM UCESCE)
8. Kreirati pogled koji prikazuje projekte na kojima ne radi nijedan izvršilac.
CREATE VIEW projekti_bez_izvrsilaca
as
SELECT *
FROM PROJEKAT
WHERE idProjekat NOT IN (SELECT idProjekat FROM UCESCE)



1. Kreirati funkciju fun_Staz koja vraća godine staza izvršioca čije se ime i prezime zadaju.
● Prikazati koliko godina staža ima Rastko Simić koristeći funkciju fun_Radnik_Staz.
● Kreirati upit koji prikazuje ime,prezime i godine staža svih izvršilaca primenom
funkcije.
Create function fun_SumStaz(@ime nchar(30), @prezime nchar(30)) returns int
as begin
declare @sumStaza int
Select @sumStaza = SUM(datediff(yy,dat_zap,getdate())) FROM IZVRSILAC
WHere ime=@ime and prezime=@prezime
return @sumStaza end
----------------------------------------------------------------------------------------------------------------
SELECT dbo.fun_SumStaz('Rastko','Simić') as UkupanStaz
—-------------------------------------------------------------------------------------------------------------
select ime,prezime, dbo.fun_SumStaz(ime,prezime) as GodineStaza from IZVRSILAC



