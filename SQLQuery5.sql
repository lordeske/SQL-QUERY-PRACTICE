1.Kreirati uskladitenu proceduru sp_Premesti_OJ posredstvom koje se izvrilac prebacuje iz jedne u drugu
organizacionu jedinicu. Proceduri se prosle?uju id organizacione jedinice u koju se prebacuje i id izvrioca koji se
prebacuje.

create procedure sp_Premesti_OJ (@idOJ int,@idI int)
as
begin
update izvrsilac
set idOJ= @idOJ 
where idIzvrsilac = @idI
END
----------------------------------
exec sp_Premesti_OJ 101, 1



2.Kreirati uskladitenu proceduru sp_novo_OJ koja u tabelu Organizaciona jedinica dodaje novu jedinicu ?ija adresa i
grad se zadaju i u nju zaposliti novog izvrioca čije ime i prezime se zadaju Postaviti datum zaposlenja za dananji
datum korišenjem funkcije getDate.
create procedure sp_novo_OJ (@adresa nchar(30),@grad nchar(30), @telefon nchar(30), @ime nchar(30), @prezime nchar(30)
,@email nchar(30),  @telefonIzv nchar(30), @jmbg nchar(13), @adresaIzv nchar(30), @gradIzv nchar(30), @cenaPoSatu float)
as
begin
insert into organizaciona_jedinica(grad,adresaOJ, telefonOJ)
values (@grad, @adresa, @telefon)
insert into izvrsilac (ime, prezime, dat_zap, cenaPoSatu, telefon, jmbg, adresa,grad)
values (@ime, @prezime, getDate(), @cenaPoSatu, @telefonIzv, @jmbg, @adresaIzv, @gradIzv)
END
------------------------------
exec sp_novo_OJ 'Kosmajska', 'Beograd', '066252147','Marija', 'Milicevic', 'mejl@gmail.com', '0601238745', '1212998457825', 'Durmitorska 14', 'Novi sad', 450



3.Kreirati uskladitenu proceduru sp_Ukloni koja izvrioca ?ije se ime i prezime zadaju uklanja sa projekta jedino
ako zadati izvrilac radi samo na jednom projektu. U slucaju uspesnog uklanjanja sa projekta vratiti poruku
UKLONJEN SA PROJEKTA u protivnom vratiti poruku NIJE UKLONJEN SA PROJEKTA.
create procedure sp_Ukloni
@ime nchar(30),
@prezime nchar(30)
as
begin
declare @Brojprojekata int
SELECT @Brojprojekata=count(*)
FROM ucesce WHERE idizvrsilac IN (SELECT idizvrsilac FROM izvrsilac WHERE  ime=@ime and prezime=@prezime)
if @Brojprojekata =1
begin 
delete 
from ucesce
where idIzvrsilac = (select idIzvrsilac from izvrsilac where ime=@ime and prezime=@prezime)
select 'UKLONJEN SA PROJEKTA'
end
else
begin
select 'NIJE UKLONJENSA PROJEKTA'
end
end
-----------------------------------------------
exec sp_Ukloni 'Bojan', 'Jovanović'


4.Kreirati uskladitenu proceduru sp_Promena_Cena koja menja cenu rada po satu izvrioca Zadaje se ime , prezime
i procenat za koji se cena rada menja. Ukoliko je promenjena cena manja od prose?ne cene rada po satu izvriti
promenu i vratiti poruku Cena rada po satu je promenjena. U slucaju da je nova vrednost veca od prose?ne cene
rada po satu, ne izvravati promenu i vratiti poruku Cena rada po satu nije promenjena..
alter procedure sp_Promena_Cena (@ime nvarchar(30), @prezime nvarchar(30), @procenat int)
as
begin
declare @prosek float
select @prosek =avg(cenaPoSatu) from izvrsilac
declare @novaPlata real
select @novaPlata=cenaPoSatu+cenaPoSatu*@procenat/100 from izvrsilac
where ime=@ime and prezime=@prezime
If @novaPlata <(select avg(cenaPoSatu) from izvrsilac)
begin
update izvrsilac
set cenaPoSatu=cenaPoSatu+cenaPoSatu*@procenat/100 
where ime=@ime and prezime=@prezime
select 'Promenjena cena';
end
else
select 'Nije promenjena cena';
end
-------------------
exec sp_Promena_Cena 'Dalibor', 'Grgurović', 3