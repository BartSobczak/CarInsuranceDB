


--1.
select count(*) as [Number of G.Sanders' accidents in Boston] 
from Persons
Join Involved on Involved.SSN = Persons.SSN
Join Accidents on Involved.Accident_number = Accidents.Accident_number
Join Locations on Accidents.Accident_number = Locations.Accident_number
Join In_town_locations on Locations.Location_ID = In_town_locations.Location_ID
where Surname = 'Sanders' and First_name = 'George' and In_town_locations.City = 'Boston';


--2.
declare @firstAccident date
set @firstAccident= (select min(Accidents.Date_of_accident)
from Persons
Right Join Involved on Involved.SSN = Persons.SSN
Right Join Accidents on Involved.Accident_number = Accidents.Accident_number
where Surname = 'Hartford' and First_name = 'Richard');

declare @pmnt decimal;
set @pmnt = (select Amount_In_USD 
from Payments
Join Damages on Payments.Damage_ID = Damages.Damage_ID
Join Involved on Damages.Involved_ID = Involved.Involved_ID
Join Accidents on Involved.Accident_number = Accidents.Accident_number
where Accidents.Date_of_accident = @firstAccident);

update Insurance_policies
set Amount_in_USD = Amount_in_USD - (@pmnt*0.8)
where SSN = (select SSN 
from Persons
where Surname = 'Hartford' and First_name = 'Richard');
select Persons.SSN, Persons.First_name, Persons.Surname, Amount_in_USD, @pmnt as Payment_value_in_USD
from Insurance_policies
Join Persons on Insurance_policies.SSN = Persons.SSN
where Persons.SSN = '857102750';

--reset for displaying purposes
update Insurance_policies
set Amount_in_USD = 550000
where SSN = '857102750';
select * from Insurance_policies
where SSN = '857102750';


--3.
select top 1 count(Cars.VIN) as [number of cars without accident], Persons.First_name, Persons.Surname
from Involved
Right join Cars on Involved.VIN = Cars.VIN
join Insurance_policies on Cars.VIN = Insurance_policies.VIN
join Persons on Insurance_policies.SSN = Persons.SSN
where Involved.VIN is NULL
group by Persons.First_name, Persons.Surname
order by [number of cars without accident] DESC;


--4.
select top 1 Brand, avg(Damages.Damage_value_in_USD) as [average damage value in USD]
from Cars
Join Involved on Cars.VIN = Involved.VIN
Join Damages on Involved.Involved_ID = Damages.Involved_ID
group by Brand
order by [average damage value in USD] DESC;


--5.
select top 1 Locations.County, count(Date_of_accident) as nmbr
from Accidents
Join Locations on Accidents.Accident_number = Locations.Accident_number
where (month(Date_of_accident) = 12 and day(Date_of_accident) >= 22) 
or month (Date_of_accident) <= 2 
or (month(Date_of_accident) = 3 and day(Date_of_accident) <= 19)
group by Locations.County
order by nmbr DESC;


--6.
declare @number_of_injured float
set @number_of_injured = (select count(*) 
from Involved
where Involved.Was_injured = 'Yes')

declare @number_of_accidents float
set @number_of_accidents = (select count(*)
from Accidents)

declare @avg_inj float
set @avg_inj = @number_of_injured/@number_of_accidents;
select @avg_inj as [Average number of injured per accident];


--7.
create view [Interstate accidents] as
select Accidents.Accident_number
from Accidents
join Locations on Accidents.Accident_number = Locations.Accident_number
join Outside_town_locations on Locations.Location_ID = Outside_town_locations.Location_ID
where Outside_town_locations.Road_type = 'Interstate';
select top 1 count(Involved_ID) as [How many involved], [Interstate accidents].Accident_number
from [Interstate accidents]
join Involved on [Interstate accidents].Accident_number = Involved.Accident_number
group by [Interstate accidents].Accident_number
order by [How many involved];

--for display purposes
drop view [Interstate accidents]
select * from [Interstate accidents]
select * from Outside_town_locations where Road_type = 'Interstate'


--8.
declare @nmbr_acc float
set @nmbr_acc = (select count(*)
from Accidents
Join Locations on Accidents.Accident_number = Locations.Accident_number
Join Outside_town_locations on Locations.Location_ID = Outside_town_locations.Location_ID
where Date_of_accident >= '2011-01-01' and Date_of_accident <= '2020-12-31')
select @nmbr_acc/10 as [average number of accidents per year in the last decade]
from Accidents


--9.
select Persons.First_name, Persons.Surname, Cars.VIN, Cars.Production_year, Insurance_policies.Expires_on
from Cars
Join Insurance_policies on Cars.VIN = Insurance_policies.VIN
Join Persons on Insurance_policies.SSN = Persons.SSN
where 
(Insurance_policies.Expires_on >= '2019-01-01' and Insurance_policies.Expires_on <= '2019-12-31')
and (Production_year >= 2000 and Production_year <= 2005)