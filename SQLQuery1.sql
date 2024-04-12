
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



/*Kreirati pogled View_Prof_Predmet_>2 koji prikazuje imena i prezimena profesora koji
predaju 2 ili više predmeta.*/
create view pogledneki as
select ime, prezime
from profesor
where ID_PROFESORA in (select ID_PROFESORA
from predmet
group by ID_PROFESORA
having COUNT(*) >=2)

/*Kreirati pogled koji prikazuje ime,prezime i kvalifikaciju izvršilaca i 
nazive projekata na kojima
rade.*/
create view nekiPogled as 
select ime , prezime, kvalif , naziv
from IZVRSILAC, PROJEKAT , UCESCE
where IZVRSILAC.idIzvrsilac = UCESCE.idIzvrsilac and
PROJEKAT.idProjekat = UCESCE.idProjekat

/*Kreirati pogled koji prikazuje izvršioce koji ne rade ni na jednom projektu*/
select * 
from IZVRSILAC
where idIzvrsilac NOT IN (select idIzvrsilac from UCESCE)


/*8. Kreirati pogled koji prikazuje projekte na kojima ne radi nijedan izvršilac*/
select *
from PROJEKAT
where idProjekat not in ( select idProjekat from UCESCE )



/*10. Kreirati pogled koji prikazuje naručioce i ukupan broj njihovih projekata.*/

select NARUCILAC.idNarucilac, nazivFirme, COUNT(*) as BrojProjekata
from NARUCILAC, PROJEKAT
where NARUCILAC.idNarucilac = PROJEKAT.idNarucilac
group by NARUCILAC.idNarucilac, nazivFirme




/*Kreirati funkciju fun_profesor_predmet koja za prosleđeni id profesora vraća listu njegovih
predmeta.*/

create function fun_profesor_predmet (@idprofe int)
returns table
as return
( select * 
 from predmet
 where ID_PROFESORA = @idprofe)

 select * from fun_profesor_predmet (102)



 /*Kreirati funkciju fun_prosek_predmet koja prihavata id_predmeta i vraća prosečnu
 ocenu
studenata na tom predmetu.*/
create function fun_student_predmet_godina(@predmetID int) 
returns float
as begin
declare @prosek float 
select @prosek=avg(ocena)
from zapisnik where
ocena >5 and
id_ispita in (select id_ispita
from ispit
where id_predmeta=@predmetID)
return @prosek
end



/*Kreirati funkciju fun_student_predmet_godina koja prihvata indeks studenta i
školsku godinu, a vraća spisak predmeta koje je student izabrao u toj školskoj godini.*/

create function fun_student_predmet (@smer nvarchar(5) , @broj int , @godina nvarchar (4),
@skolskagodina nvarchar(10))
returns table
as return
(
select predmet.ID_PREDMETA, NAZIV 
from predmet , student, student_predmet
where predmet.ID_PREDMETA = student_predmet.ID_PREDMETA and
student.ID_STUDENTA = student_predmet.ID_STUDENTA
and smer = @smer and BROJ = @broj and GODINA_UPISA = @godina and
SKOLSKA_GODINA = @skolskagodina
)

select * from fun_student_predmet('NRT',15,'2019', '2019/20')



/*Kreirati funkciju fun_Student_prosek koja za prosleđeni indeks studenta vraća
njegovu prosečnu ocenu.*/

create function fun_Student_prosek(@smer nvarchar(5), @broj int, @godina
nvarchar(4))
returns float
as begin
declare @prosek float
select @prosek =AVG(OCENA)
from zapisnik
where ID_STUDENTA in
(select ID_STUDENTA 
from student
where SMER = @smer and BROJ = @broj and GODINA_UPISA = @godina)
return @prosek
end

select dbo.fun_Student_prosek ('IS',25,2019)




/*Kreirati funkciju fun_narucilac_projekat koja za zadati id naručioca 
vraća listu njegovih
projekata.*/create function fun_narucilac_projekat (@idnarcioca int)returns tableas return(select idProjekat , nazivfrom PROJEKATwhere idNarucilac = @idnarcioca)select * from fun_narucilac_projekat ('1')/*Kreirati funkciju fun_isplacena_sredstva koja za zadati jmbg izvršioca vraća ukupna
isplaćena sredstva tom izvršiocu.*/Create function un_isplacena_sredstva (@jmbg char(13))
returns float
as begin
DECLARE @Ukupno float
Select @UKUPNO=SUM(iznos)
FROM ISPLATA
WHERE idIzvrsilac= (SELECT idIzvrsilac FROM IZVRSILAC WHERE jmbg=@jmbg)
return @UKUPNO
end


/*Kreirati funkciju fun_Mesec koja za zadati mesec prikazuje ime i prezime i jmbg
izvršilaca koji su se zaposlili tog meseca.*/

create function fun_Mesec (@mesec int)
returns table
as return
(select ime , prezime, jmbg
from IZVRSILAC
where MONTH(dat_zap) = @mesec)


/* Kreirati funkciju fun_Staz koja vraća godine staza izvršioca čije se 
ime i prezime zadaju.
*/

create function fun_staza (@ime nchar(30) , @prezime nchar(30))
returns int
as begin
declare @sumaStaza int
select @sumaStaza =  sum(datediff(yy,dat_zap,getdate())) 
from IZVRSILAC
where ime = @ime 
and prezime = @prezime
return @sumaStaza
end