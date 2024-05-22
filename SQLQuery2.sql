select * from student 
where smer in ('RT' , 'IS')


/* Studenti koji studiraju siti smer kao Milos Petkovic */
select *
from student
where SMER in ( SELECT smer FROM student WHERE ime='Miloš' )


/* Ukupan broj studenata po smeru kojih ima vise od 2 upisanih 2020*/
select COUNT(*) as broj_Studenata, SMER
from student
where GODINA_UPISA = '2020'
group by SMER
having COUNT(*) > 2


/*Studente cija je ocena iz predmeta PROGARMSKI JEZICI veca od prosecne ocene na tom 
premdetu u ispitnom roku JUNSKOM* 18/19 */
select ime , prezime , smer, naziv 
from student , predmet , zapisnik , ispit
where student.ID_STUDENTA  = zapisnik.ID_STUDENTA and		
					zapisnik.ID_ISPITA = ispit.ID_ISPITA and
						predmet.ID_PREDMETA = ispit.ID_PREDMETA 
				and NAZIV in ('Programski jezici')
				and  OCENA > (select AVG(ocena)
				
from zapisnik
where ID_ISPITA in (select ID_ISPITA
from ispit
where ID_ROKA in (select ID_ROKA
						from ispitni_rok 
								where NAZIV = 'Jun' and SKOLSKA_GOD = '2018/19') 
								and 
				ID_PREDMETA in (select ID_PREDMETA
					from predmet
						where NAZIV in ('Programski jezici')))


)




/* Imena i prezimena studenata i njihovu prosecnu ocenu*/
select ime, prezime , AVG(OCENA)
from student , zapisnik
where student.ID_STUDENTA = zapisnik.ID_STUDENTA
group by ime, prezime /*Kada imamo agregatnu funckiju u group by ide ovo sve iz selekta osim te funckije*/




/*Написати SQL упит који приказује име, презиме
и индекс свих студената који су положили предмет “Интеракција човек-рачунар”.*/
select ime, prezime, CONCAT(smer,' ',broj,'-',GODINA_UPISA) as indeks, OCENA
from student ,zapisnik
where student.ID_STUDENTA = zapisnik.ID_STUDENTA
and OCENA > 6 
and ID_ISPITA in (select ID_ISPITA
from ispit where ID_PREDMETA in ( select ID_PREDMETA
from predmet 
where NAZIV in ('Interakcija čovek-računar')))




/*Prikazati spisak svih ispita (naziv predmeta i datum ispita) održanih u junu 2019/20.*/
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



/*Prikazati studente koji iz predmeta Programski jezici imaju manju 
ocenu od prosečne ocene na tom predmetu.*/
select ime ,prezime
from student ,zapisnik
where student.ID_STUDENTA = zapisnik.ID_STUDENTA and
ocena < (select AVG(ocena)
from zapisnik
where ID_ISPITA in (
select ID_ISPITA from ispit where ID_PREDMETA in (select ID_PREDMETA
from predmet
where NAZIV = 'Programski jezici')))






/*Dodati podatke o izbornom predmetu Telekomunikacije koji nosi 6 ESPB.*/
INSERT INTO predmet
values ('1234' , '4242' , 'Telekomunikacije' , 'izborni')



/*Prikazati spisak studenata koji su birali predmet Objektno programiranje 1*/  
select *
from student , predmet, student_predmet
where student.ID_STUDENTA = student_predmet.ID_STUDENTA
      and predmet.ID_PREDMETA = student_predmet.ID_PREDMETA

and NAZIV = 'Objektno programiranje 1'



/*Za predmet Programiranje mobilnih uređaja dodeliti profesora Vladimira Vuletića.*/
update predmet
set ID_PROFESORA = (select ID_PROFESORA 
from profesor
where ime in ('Vladimir') and PREZIME in ('Vuletić'))
where ID_PREDMETA in (select ID_PREDMETA
from predmet
where NAZIV = 'Programiranje mobilnih uređaja')



/*Prikazati naziv predmeta, zvanje, ime i prezime profesora i datum održavanja
ispita za sve ispite koji su se održali u vanrednim ispitnim rokovima*/
select profesor.IME , profesor.PREZIME , zvanje, predmet.NAZIV
from profesor, ispit , predmet

where profesor.ID_PROFESORA = predmet.ID_PROFESORA and
predmet.ID_PREDMETA = ispit.ID_PREDMETA

and  ID_ROKA in (select ID_ROKA
from ispitni_rok
where STATUS_ROKA in ('vanredni'))






/*Написати SQL упит који креира нову табелу са произвољним називом
и у њу ископирати записе о студентима који су остварили више од 30 ESPB бодова.*/
create table nekaTabela
select ime , PREZIME , sum(espb)
from student , predmet ,student_predmet
where student.ID_STUDENTA = student_predmet.ID_STUDENTA and
predmet.ID_PREDMETA = student_predmet.ID_PREDMETA
group by ime , PREZIME
having SUM(espb) > 30
