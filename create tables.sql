CREATE TABLE Persons (
    SSN varchar(9) NOT NULL PRIMARY KEY CHECK(SSN LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
    First_name varchar(20) CHECK(First_name NOT LIKE '%[^A-Z]%') NOT NULL,
    Surname varchar(50) CHECK(Surname NOT LIKE '%[^A-Z]%') NOT NULL,
    ID_card_number varchar(9) CHECK(ID_card_number LIKE '[A-Z][A-Z][A-Z][0-9][0-9][0-9][0-9][0-9][0-9]'),
    City varchar(50),
);

CREATE TABLE Accidents (
    Accident_number int NOT NULL PRIMARY KEY CHECK (Accident_number > 0),
    Accident_type varchar(100) NOT NULL,
    Date_of_accident date CHECK(Date_of_accident BETWEEN '2000-01-01' AND CAST(GETDATE() as date)) NOT NULL,
);

CREATE TABLE Locations (
    Location_ID varchar(11) NOT NULL PRIMARY KEY,
  	State_ varchar(20) CHECK(State_ NOT LIKE '%[0-9]%') NOT NULL,
  	County varchar(30) CHECK(County NOT LIKE '%[0-9]%') NOT NULL,
    Accident_number int FOREIGN KEY REFERENCES Accidents(Accident_number)
	ON DELETE CASCADE
	ON UPDATE CASCADE
);

CREATE TABLE In_town_locations (
  	Location_ID varchar(11) NOT NULL PRIMARY KEY FOREIGN KEY REFERENCES Locations(Location_ID)
	ON DELETE CASCADE
	ON UPDATE CASCADE,
  	City varchar(30) NOT NULL,
  	Street varchar(40) NOT NULL,
);

CREATE TABLE Outside_town_locations (
  	Location_ID varchar(11) NOT NULL PRIMARY KEY FOREIGN KEY REFERENCES Locations(Location_ID)
	ON DELETE CASCADE
	ON UPDATE CASCADE,
  	Road_type varchar(20),
  	Road_number int CHECK (Road_number > 0),
  	Nearest_milestone int CHECK (Nearest_milestone > 0),
);

CREATE TABLE Reports (
	Report_number int NOT NULL PRIMARY KEY,
	Date_reported date CHECK(Date_reported BETWEEN '2000-01-01' AND CAST(GETDATE() as date)),
	Accident_number int FOREIGN KEY REFERENCES Accidents(Accident_number)
	ON DELETE CASCADE
	ON UPDATE CASCADE,
	SSN varchar(9) FOREIGN KEY REFERENCES Persons(SSN) 
	ON DELETE CASCADE
	ON UPDATE CASCADE
)

CREATE TABLE Cars (
	VIN varchar(17) NOT NULL PRIMARY KEY CHECK(VIN NOT LIKE 'Q,J,O'),
	Production_year int CHECK (Production_year > 1885 AND Production_year < 2022),
	Brand varchar(20),
	License_number varchar(8),
	Register_date date,
	Model varchar(30),
)

CREATE TABLE Involved (
	Involved_ID varchar(11) NOT NULL PRIMARY KEY,
	Was_injured varchar(3) CHECK(Was_injured LIKE 'Yes' OR Was_injured LIKE 'No'),
	Role_ varchar(30),
	Accident_number int FOREIGN KEY REFERENCES Accidents(Accident_number)
	ON DELETE CASCADE
	ON UPDATE CASCADE,
	SSN varchar(9) FOREIGN KEY REFERENCES Persons(SSN)
	ON DELETE CASCADE
	ON UPDATE CASCADE,
	VIN varchar(17) FOREIGN KEY REFERENCES Cars(VIN)
	ON DELETE CASCADE
	ON UPDATE CASCADE
)

CREATE TABLE Insurance_policies (
	Ip_ID varchar(10) NOT NULL PRIMARY KEY,
	Cost_in_USD decimal CHECK (Cost_in_USD > 0),
	Amount_in_USD decimal CHECK (Amount_in_USD > 0),
	Expires_on date CHECK(Expires_on BETWEEN '1900-01-01' AND CAST(GETDATE() as date)),
	SSN varchar(9) FOREIGN KEY REFERENCES Persons(SSN)
	ON DELETE CASCADE
	ON UPDATE CASCADE,
	VIN varchar(17) FOREIGN KEY REFERENCES Cars(VIN)
	ON DELETE CASCADE
	ON UPDATE CASCADE
)

CREATE TABLE Damages (
	Damage_ID varchar(10) NOT NULL PRIMARY KEY,
	Damage_value_in_USD decimal,
	Damage_type varchar(20),
	Involved_ID varchar(11) FOREIGN KEY REFERENCES Involved(Involved_ID)
	ON DELETE CASCADE
	ON UPDATE CASCADE
)

CREATE TABLE Payments (
	Payment_number int NOT NULL PRIMARY KEY,
	Amount_in_USD decimal,
	Due_to date CHECK(Due_to BETWEEN '2000-01-01' AND CAST(GETDATE() as date)),
	Is_received varchar(3) CHECK(Is_received LIKE 'Yes' OR Is_received LIKE 'No'),
	Damage_ID varchar(10) FOREIGN KEY REFERENCES Damages(Damage_ID),
	Ip_ID varchar(10) FOREIGN KEY REFERENCES Insurance_policies(Ip_ID)
)
