create view view_plata_Naknada as

select * from (
select ime, prezime , cenaPoSatu,
case kvalif
when 'KV' then cenaPoSatu * 1.15
when 'VKV' then cenaPoSatu*1.3
else cenaPoSatu
end as Naknada 
from IZVRSILAC )
as Tabelanaknade
where cenaPoSatu <> Naknada


UNION --> spajanje ne dupliarni
UNION ALL --> spajanje i duplirani
INTERSECT --> ZAJEDNICI ZA OBA
EXCEPT --> Razlika


select ime, prezime
from IZVRSILAC
where  idIzvrsilac in (
select idIzvrsilac
from UCESCE 
where idProjekat in (select idProjekat
from PROJEKAT where naziv in ('Uvoz')))

except

select ime, prezime
from IZVRSILAC
where  idIzvrsilac in (
select idIzvrsilac
from UCESCE 
where idProjekat in (select idProjekat
from PROJEKAT where naziv !='Uvoz'))



/**/
insert into profesor 
(ime,PREZIME,ZVANJE ,DATUM_ZAP)
values ('Vesna', 'Veselinovic', 'dr' , GETDATE())

select* from profesor
where ime in ('Vesna')

/*1.Променити професора на предмету Аналогна електроника и поставити Владимира
Вулетића.v*/

update predmet
set ID_PROFESORA = (select ID_PROFESORA
from profesor
where ime in ('Vladimir')
and PREZIME in ('Vuletic'))
where ID_PREDMETA in (select ID_PREDMETA
from predmet
where NAZIV in ('Analogna elektronika'))


/*Приказати студенте који су изабрали предмете у вредности од 30 или више ЕСПБ у
школској години 2019/20.*/

select student.IME , student.PREZIME , sum(espb)
from student , student_predmet ,predmet
where student.ID_STUDENTA = student_predmet.ID_STUDENTA and
predmet.ID_PREDMETA = student_predmet.ID_PREDMETA
and SKOLSKA_GODINA in ('2019/20')
group by student.IME , student.PREZIME
having sum(espb)>=30



/*4. Приказати предмет са најнижом просечном оценом*/
SELECT predmet.NAZIV , AVG(zapisnik.ocena)
FROM predmet , ispit, zapisnik
where
predmet.ID_PREDMETA = ispit.ID_PREDMETA and
ispit.ID_ISPITA = zapisnik.ID_ISPITA
GROUP BY predmet.NAZIV
ORDER BY AVG(zapisnik.ocena) asc


/*Професору који предаје предмет Објектно програмирање 2 доделити и предмет
Микропроцесорски софтвер*/
UPDATE predmet
set ID_PROFESORA = (select profesor.ID_PROFESORA
from predmet , profesor
where predmet.ID_PROFESORA = profesor.ID_PROFESORA
and NAZIV in ('Objektno programiranje 2'))
where ID_PREDMETA = (select ID_PREDMETA
from predmet
where NAZIV in ('Mikroprocesorski softver')
)



/*Написати функцију која враћа просечну оцену на смеру.*/
create function prosecaOcena (@smer nchar(5))
returns float
as begin
declare @prosecnaOcena float
select @prosecnaOcena =  AVG(ocena)
from zapisnik , student
where zapisnik.ID_STUDENTA = student.ID_STUDENTA
and smer = @smer
return @prosecnaOcena
end

/*Приказати студенте РТ смера чија је оцена већа од просечне оцене на том смеру.*/
select ime,PREZIME, SMER , OCENA
from student, zapisnik 
where student.ID_STUDENTA = zapisnik.ID_STUDENTA	and
SMER in ('RT')
group by ime,PREZIME, SMER ,OCENA
having OCENA > (select avg(ocena)
from zapisnik, student
where zapisnik.ID_STUDENTA = student.ID_STUDENTA
and SMER in ('RT'))


/*8. Приказати укупна исплаћена средства извршиоцима који су ангажовани на пројекту
Имплементација*/


select idIzvrsilac
from IZVRSILAC
where 


/*Написати функцију која враћа просечну цену рада по сату*/
create function po_satu ()
returns float
as begin
declare @prosek float
select @prosek = AVG(cenaPoSatu)
from IZVRSILAC
return @prosek
end



/*иказати извршиоце чија је цена рада по сату већа од просечне цене рада по сату.*/

select *
from IZVRSILAC
where cenaPoSatu > (select AVG(cenaPoSatu)
from IZVRSILAC
)






