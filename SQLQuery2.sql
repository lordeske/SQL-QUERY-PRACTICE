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


select ID_PREDMETA
from predmet
where NAZIV in ('Programski jezici')

