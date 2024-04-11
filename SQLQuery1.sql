
/* Kreirati pogled sa nazivom View_Student_2020 koji vra?a podatke o studentima (ime,prezime i indeks) koji su
upisani 2020. godine.*/
create view Pogledi_Student 
as
select ime, prezime , smer , broj 
from student
where GODINA_UPISA in ('2020')

select * from Pogledi_Student
where smer in ('NRT')



/*Kreirati funkciju fun_Prosek_predmet koja vra?a prose?nu 
ocenu studenata za zadati naziv predmeta.Prose?nu
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
	

