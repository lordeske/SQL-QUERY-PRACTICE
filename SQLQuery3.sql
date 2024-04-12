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



/*1. ?????? ????? ????????? ?????? ???????????? ?? ?? ??????.*/
insert into profesor 
(ime,PREZIME,ZVANJE ,DATUM_ZAP)
values ('Vesna', 'Veselinovic', 'dr' , GETDATE())

select* from profesor
where ime in ('Vesna')

/*2. ????????? ????????? ?? ???????? ???????? ??????????? ? ????????? ?????????
????????*/

update predmet
set ID_PROFESORA = (select ID_PROFESORA
from profesor
where ime in ('Vladimir')
and PREZIME in ('Vuleti?'))
where ID_PREDMETA in (select ID_PREDMETA
from predmet
where NAZIV in ('Analogna elektronika'))


