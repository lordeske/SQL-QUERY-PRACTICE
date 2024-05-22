/* Studenti koji studiraju siti smer kao Milos Petkovic */


select * 
from student
where SMER in (

select smer
from student
where ime in ('Miloš')

)


/* Ukupan broj studenata po smeru kojih ima vise od 2 upisanih 2020*/
select COUNT(*) as ukupanBrojStudeana , SMER
from student
where GODINA_UPISA = '2020'
group by SMER
having COUNT(*) > 2 

/*Studente cija je ocena iz predmeta PROGARMSKI JEZICI veca od prosecne ocene na tom 
premdetu u ispitnom roku JUNSKOM* 18/19 */

select ime, prezime, smer , OCENA
from zapisnik , student
where zapisnik.ID_STUDENTA = student.ID_STUDENTA
and
OCENA > (select AVG(ocena)
from zapisnik
where ID_ISPITA in (select ID_ISPITA
from ispit
where ID_ROKA in (select  ID_ROKA
from ispitni_rok
where NAZIV in ('Jun') and SKOLSKA_GOD in ('2018/19'))
and ID_PREDMETA in (select ID_PREDMETA
from predmet
where NAZIV in ('Programski jezici'))))



/* Imena i prezimena studenata i njihovu prosecnu ocenu*/

select ime, prezime, AVG(ocena)
from student , zapisnik
where	student.ID_STUDENTA = zapisnik.ID_STUDENTA
group by ime , PREZIME



/*Написати SQL упит који приказује име, презиме
и индекс свих студената који су положили предмет “Интеракција човек-рачунар”.*/

select ime, prezime , CONCAT(smer,'-',broj,'/', godina_upisa) as indeks , OCENA
from student, zapisnik
where student.ID_STUDENTA = zapisnik.ID_STUDENTA and
ID_ISPITA in (
select ID_ISPITA
from ispit
where
ID_PREDMETA in (select id_predmeta
from predmet
where NAZIV in ('Interakcija čovek-računar')))
and OCENA > 5



/*Prikazati spisak svih ispita (naziv predmeta i datum ispita) održanih u junu 2019/20.*/

select CONCAT(predmet.NAZIV , '-' , datum) as SpisakPredmeta
from ispit , predmet

where ID_ROKA in (
select ID_ROKA
from ispitni_rok
where NAZIV in ('Jun')
and SKOLSKA_GOD in ('2019/20')
) and predmet.ID_PREDMETA = predmet.ID_PREDMETA

select CONCAT (predmet.NAZIV  , ' ' ,datum) as ispitTrazeni
from ispit, predmet ,ispitni_rok
where ispit.ID_PREDMETA = predmet.ID_PREDMETA 
and ispit.ID_ROKA = ispitni_rok.ID_ROKA
and ispit.ID_ROKA  in (
select ID_ROKA
from ispitni_rok
where NAZIV = 'Jun' 
and SKOLSKA_GOD = '2019/20'

)


SELECT CONCAT(predmet.NAZIV , '-' , datum) AS SpisakPredmeta
FROM ispit , predmet
WHERE ID_ROKA in (
    SELECT ID_ROKA
    FROM ispitni_rok
    WHERE NAZIV in ('Jun')
    AND SKOLSKA_GOD in ('2019/20')
) AND predmet.ID_PREDMETA = predmet.ID_PREDMETA;









/*Prikazati studente koji iz predmeta Programski jezici imaju manju 
ocenu od prosečne ocene na tom predmetu.*/
select ime, prezime , smer , ocena 
from student ,zapisnik 
where zapisnik.ID_STUDENTA = student.ID_STUDENTA
and ocena < (select avg(ocena) 
from zapisnik
where ID_ISPITA in (select ID_ISPITA
from ispit	
where ID_PREDMETA in (select ID_PREDMETA
from predmet where NAZIV ='Programski jezici'))
)


/*Prikazati naziv predmeta, zvanje, ime i prezime profesora i datum održavanja
ispita za sve ispite koji su se održali u vanrednim ispitnim rokovima*/

select predmet.NAZIV, profesor.IME, profesor.PREZIME , datum
from predmet, profesor, ispit
where  profesor.ID_PROFESORA = predmet.ID_PROFESORA
and ispit.ID_PREDMETA = predmet.ID_PREDMETA
and ID_ROKA in (select id_roka
from ispitni_rok
where STATUS_ROKA = 'vanredni')






