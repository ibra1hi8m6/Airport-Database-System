Create table Passenger(
passenger_id INT primary key ,
first_name varchar(50) not null,
middle_name varchar(50) not null,
last_name varchar(50) not null,
passenger_dob date,
passenger_age int,
passenger_email varchar(50),
);
Create table Ticket(
ticket_id INT primary key not null,
ticket_class varchar(50) ,
seat_number varchar(50) ,
gate_number int,
passenger_payload int,
plane_id int
);
Create table Flight(
flight_id INT primary key not null,
arrival_time time(7) ,
takeoff_location varchar(50) ,
flight_number int,
destination varchar(50),
pilot_id int ,
takeoff_time time(7) ,
flight_duration time(7)
);
Create table Pilot(
pilot_id INT primary key not null,
pilot_dob date ,
pilot_first_name varchar(50) ,
pilot_middle_name varchar(50) ,
pilot_last_name varchar(50) ,
pilot_total_hours int,
pilot_age int
);
Create table Plane(
plane_id INT primary key not null,
plane_model varchar(50) ,
plane_payload int,
);

Create table AddressP(
house_number INT primary key not null,
street varchar(50) ,
);
Create table  City(
city_id INT primary key not null,
city_name varchar(50) ,

);
Create table Country(
country_id INT primary key not null,
country_name varchar(50) ,
);
Create table PhoneNumber(
country_code INT primary key ,
number INT 
);

/*here we will start the relationship tables*/
/*1 - Country with city*/
Create table CC(
country_id INT  ,
city_id INT 
/*1*/
Foreign key (country_id)
REFERENCES
Country(country_id),
/*2*/
Foreign key (city_id)
REFERENCES
City(city_id)
);
/*2 - Addressp with city*/
Create table CA(
house_number INT  ,
city_id INT 
/*1*/
Foreign key (house_number)
REFERENCES
AddressP(house_number),
/*2*/
Foreign key (city_id)
REFERENCES
City(city_id)
);
/*3 - Addressp with Passenger*/
Create table AP(
house_number INT  ,
passenger_id INT 
/*1*/
Foreign key (house_number)
REFERENCES
AddressP(house_number),
/*2*/
Foreign key (passenger_id)
REFERENCES
Passenger(passenger_id)
);
/*3 - PhoneNumber with Passenger*/
Create table PP(
country_code INT  ,
passenger_id INT 
/*1*/
Foreign key (country_code)
REFERENCES
PhoneNumber(country_code),
/*2*/
Foreign key (passenger_id)
REFERENCES
Passenger(passenger_id)
);
/*4 - Ticket with Passenger*/
Create table TP(
ticket_id INT  ,
passenger_id INT 
/*1*/
Foreign key (ticket_id)
REFERENCES
Ticket(ticket_id),
/*2*/
Foreign key (passenger_id)
REFERENCES
Passenger(passenger_id)
);
/*5 - Ticket with Flight*/
Create table TF(
ticket_id INT  ,
flight_id INT 
/*1*/
Foreign key (ticket_id)
REFERENCES
Ticket(ticket_id),
/*2*/
Foreign key (flight_id)
REFERENCES
Flight(flight_id)
);
/*6 - Plane with Flight*/
Create table FP(
plane_id INT  ,
flight_id INT 
/*1*/
Foreign key (plane_id)
REFERENCES
Plane(plane_id),
/*2*/
Foreign key (flight_id)
REFERENCES
Flight(flight_id)
);




/*here we will start addition command*/

/*ALTER TABLE PhoneNumber*/
ALTER TABLE PhoneNumber
ADD constraint PhoneNumber_data UNIQUE (country_code, number);
/*DROP TABLE PhoneNumber*/
DROP TABLE PhoneNumber

Insert into Passenger(passenger_id ,first_name ,middle_name ,last_name ,passenger_dob  ,passenger_email ) 
values
(1,'ahmed', 'Hema','ali','2002-03-12',  'ahmed@gmail.com'),
(2,'omar', 'beshoy','saaed','2003-08-06',  'ahmed@gmail.com'),
(3,'nour', 'qasam','tayseer','1999-07-16','ahmed@gmail.com');

Insert into Pilot(pilot_id ,pilot_dob,pilot_first_name,pilot_middle_name,pilot_last_name,pilot_age) 
values
(1,'2002-03-12','ahmed', 'Hema','ali', 35 ),
(2,'2003-08-06','omar', 'beshoy','saaed', 48 ),
(3,'1999-07-16','nour', 'qasam','tayseer',28);

INSERT INTO Flight (flight_id, arrival_time, takeoff_location, flight_number, destination, pilot_id, takeoff_time, flight_duration)
VALUES
    (6, '12:30:00', 'Location A', 101, 'Destination X', 3, '10:00:00', '02:30:00'), 
    (7, '15:45:00', 'Location B', 102, 'Destination Y', 3, '13:20:00', '02:25:00'); 

Insert into Ticket(ticket_id ,ticket_class  ,seat_number  ,gate_number ,passenger_payload,plane_id) 
values
(1,'Economic class', 'A15',5,45,1 ),
(2,'Busniess class', 'BUS2',13,75,1 ),
(3,'Economic class', 'D25',6,45,2 );
select * from Ticket
delete from Ticket;
Insert into Plane( plane_id,plane_model,plane_payload) 
values
(1,'A730',550),
(2,'A270',250),
(3,'A1090',1550);

select* from Plane;

DELETE FROM Flight ; --where flight_id=1 ;

ALTER TABLE Flight
ADD pilot_id INT;
ALTER TABLE Flight
ADD CONSTRAINT FK_PilotID FOREIGN KEY (pilot_id) REFERENCES Pilot(pilot_id);

ALTER TABLE Ticket
ADD passenger_payload int;
UPDATE Ticket
SET passenger_payload = CONVERT(int, passenger_payload);
UPDATE Flight
SET takeoff_time = CONVERT(TIME, takeoff_date);

ALTER TABLE Flight
DROP COLUMN passenger_payload;
DROP COLUMN from Ticket  passenger_payload
from Ticket;

-- Add a new column for flight duration
ALTER TABLE Flight
ADD flight_duration TIME;

-- Update the new column with the calculated duration
UPDATE Flight
SET flight_duration = CONVERT(TIME, DATEADD(SECOND, DATEDIFF(SECOND, takeoff_time, arrival_time), 0));


select* from Flight;


update Passenger SET first_name = 'hamada' WHERE passenger_id=1;
Delete Passenger Where passenger_id=3;



SELECT UPPER(first_name) AS namee
FROM Passenger;
select* from Pilot;


Create Procedure UpdateAge
AS
BEGIN
Update Passenger
SET passenger_age= DATEDIFF(Year,passenger_dob,GETDate());
END;
EXEC UpdateAge;
select* from Passenger;



Create Procedure GET_Economic_class
AS
BEGIN
select  first_name, passenger_dob
from Passenger as t1
Left Join Ticket as t2
on t1.passenger_id = t2.ticket_id
Where t2.ticket_class = 'Economic class';
END;

EXEC GET_Economic_class;






CREATE TRIGGER update_pilot_total_hours
ON Flight
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE Pilot
    SET pilot_total_hours = ISNULL((
            SELECT SUM(DATEDIFF(MINUTE, '00:00:00', flight_duration))
            FROM Flight
            WHERE Flight.pilot_id = Pilot.pilot_id
        ), 0)
    FROM Pilot
    INNER JOIN inserted ON Pilot.pilot_id = inserted.pilot_id;
END;


Alter table Ticket
ADD plane_id int ;

Alter table Ticket
ADD CONSTRAINT plane_id_FK FOREIGN KEY (plane_id) REFERENCES Plane(plane_id);



CREATE TRIGGER UpdatePlanePayload
ON Ticket
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE Plane
    SET plane_payload = ISNULL((SELECT SUM(passenger_payload) FROM Ticket WHERE Ticket.plane_id = Plane.plane_id), 0)
    WHERE Plane.plane_id IN (SELECT DISTINCT plane_id FROM inserted);
END;

select * from Pilot



Drop TRIGGER update_x


UPDATE Pilot
SET pilot_total_hours = 0
WHERE pilot_total_hours IS NULL;


