--create database
CREATE DATABASE library WITH OWNER = postgres;

--connect to database
\c library

--sequences
CREATE SEQUENCE IF NOT EXISTS seqLibID
	INCREMENT BY 1
        START WITH 1 NO CYCLE
;

CREATE SEQUENCE IF NOT EXISTS seqEmpID
	INCREMENT BY 1
		START WITH 1 NO CYCLE
;

CREATE SEQUENCE IF NOT EXISTS seqWLID
	INCREMENT BY 1
		START WITH 1 NO CYCLE
;

CREATE SEQUENCE IF NOT EXISTS seqMaterialID
	INCREMENT BY 1
		START WITH 1 NO CYCLE
;

CREATE SEQUENCE IF NOT EXISTS seqPrintID
	INCREMENT BY 1
		START WITH 1 NO CYCLE
;

CREATE SEQUENCE IF NOT EXISTS seqElectronicID
	INCREMENT BY 1
		START WITH 5001 NO CYCLE
;

CREATE SEQUENCE IF NOT EXISTS seqSRID
	INCREMENT BY 1
		START WITH 1 NO CYCLE
;

CREATE SEQUENCE IF NOT EXISTS seqCHID
	INCREMENT BY 1
		START WITH 1 NO CYCLE
;

--tables
CREATE TABLE Library (
	lID INTEGER NOT NULL UNIQUE DEFAULT nextval('seqLibID'),
	address VARCHAR(40) NOT NULL,
	state VARCHAR(2) NOT NULL,
	zip INTEGER NOT NULL,
	city VARCHAR(25) NOT NULL,
	phone BIGINT NOT NULL,
	PRIMARY KEY (lID)
);

CREATE TABLE Employee (
	eID INTEGER NOT NULL UNIQUE DEFAULT nextval('seqEmpID'),
	lname VARCHAR(30) NOT NULL,
	fname VARCHAR(20) NOT NULL,
	ssn BIGINT NOT NULL UNIQUE,
	address VARCHAR(40) NOT NULL,
	state VARCHAR(2) NOT NULL,
	phone BIGINT NOT NULL,
	email VARCHAR(30) NOT NULL,
	bdate DATE NOT NULL,
	payrate FLOAT NOT NULL,
	position VARCHAR(20) NOT NULL,
	lID INTEGER REFERENCES library(lID),
	PRIMARY KEY (eID)
);

CREATE TABLE WorkLog (
	wlID INTEGER NOT NULL UNIQUE DEFAULT nextval('seqWLID'),
	Date DATE NOT NULL,
	TimeStart VARCHAR(4) NOT NULL,
	Hours FLOAT NOT NULL,
	eID INTEGER REFERENCES employee(eID),
	PRIMARY KEY (wlID)
);

CREATE TABLE Print (
	printID INTEGER NOT NULL PRIMARY KEY,
	isbn BIGINT NOT NULL,
	publisher VARCHAR(50) NOT NULL,
	issuedate VARCHAR(4) NOT NULL,
	pnumcopy INTEGER NOT NULL,
	author VARCHAR(50) NOT NULL,
	lID INTEGER REFERENCES library(lID),
	title VARCHAR(50) NOT NULL,
	year INTEGER NOT NULL,
	genre VARCHAR(25) NOT NULL
);

CREATE TABLE Electronic (
	electronicID INTEGER NOT NULL UNIQUE DEFAULT nextval('seqElectronicID'),
	production VARCHAR(50) NOT NULL,
	visual BOOLEAN,
	enumcopy INTEGER NOT NULL,
	lID INTEGER REFERENCES library(lID),
	title VARCHAR(50) NOT NULL,
	year INTEGER NOT NULL,
	genre VARCHAR(25) NOT NULL,
	PRIMARY KEY (electronicID)
);

CREATE TABLE StudyRooms (
	srID INTEGER NOT NULL UNIQUE DEFAULT nextval('seqSRID'),
    capacity INTEGER NOT NULL,
	purpose VARCHAR(25) NOT NULL,
	location INTEGER NOT NULL,
	lID INTEGER REFERENCES library(lID),
	PRIMARY KEY (srID)
);

CREATE TABLE CardHolder (
	chID INTEGER NOT NULL UNIQUE DEFAULT nextval('seqCHID'),
	lname VARCHAR(30) NOT NULL,
	fname VARCHAR(15) NOT NULL,
	address VARCHAR(50) NOT NULL,
	state VARCHAR(2) NOT NULL,
	phone BIGINT NOT NULL,
	email VARCHAR(25) NOT NULL,
	bdate DATE NOT NULL,
	latefees FLOAT NOT NULL,
	lID INTEGER REFERENCES library(lID),
	PRIMARY KEY (chID)
);

CREATE TABLE WorksFor (
	dstart DATE NOT NULL,
	dend DATE NULL,
	eID INTEGER REFERENCES employee(eID),
	libID INTEGER REFERENCES library(lID)
);

CREATE TABLE RentPrint(
	prstart DATE NOT NULL,
	prend DATE NOT NULL,
	chID INTEGER REFERENCES cardholder(chid),
	printid INTEGER REFERENCES print(printid)
);

CREATE TABLE RentElectronic(
	erstart DATE NOT NULL,
	erend DATE NOT NULL,
	chID INTEGER REFERENCES cardholder(chid),
	electronicid INTEGER REFERENCES electronic(electronicid)
);

CREATE TABLE Requests (
	srsdate DATE NOT NULL,
	srstime VARCHAR(4) NOT NULL,
	sredate DATE NOT NULL,
	sretime VARCHAR(4) NOT NULL,
	srID INTEGER REFERENCES studyrooms(srid),
	chID INTEGER REFERENCES cardholder(chid)
);

--indexes
DROP INDEX IF EXISTS idx_library_id;
CREATE INDEX IF NOT EXISTS idx_library_id
	ON library(lID)
;

DROP INDEX IF EXISTS idx_employee_id;
CREATE INDEX IF NOT EXISTS idx_employee_id
	ON employee(eID)
;

DROP INDEX IF EXISTS idx_employee_ssn;
CREATE INDEX IF NOT EXISTS idx_employee_ssn
	ON employee(ssn)
;

DROP INDEX IF EXISTS idx_worklog_id;
CREATE INDEX IF NOT EXISTS idx_worklog_id
	ON worklog(wlID)
;

DROP INDEX IF EXISTS idx_print_isbn;
CREATE INDEX IF NOT EXISTS idx_print_isbn
	ON print(isbn)
;

DROP INDEX IF EXISTS idx_studyrooms_id;
CREATE INDEX IF NOT EXISTS idx_studyrooms_id
	ON studyrooms(srID)
;

DROP INDEX IF EXISTS idx_cardholder_id;
CREATE INDEX IF NOT EXISTS idx_cardholder_id
	ON cardholder(chID)
;

DROP INDEX IF EXISTS idx_cardholder_lname;
CREATE INDEX IF NOT EXISTS idx_cardholder_lname
	ON cardholder(lname);
;

--inserts

insert into library values(1, '123 What St.', 'CA', 93309, 'Bakersfield', '6614321235');
insert into library values(2, '341 Free St.', 'CA', 93310, 'Bakersfield', '6611235678');
insert into library values(3, '122 Sum St.', 'CA', 93311, 'Bakersfield', '6618527662');
insert into library values(4, '512 Tree St.', 'CA', 90046, 'Los Angeles', '6623121244');
insert into library values(5, '1236 Jump St.', 'CA', 94256, 'Sacramento', '6513425478');

insert into employee values(1, 'Harriet', 'William', 575236741, '312 What St.', 'CA' , 6612311233, 'WHarriet@gmail.com', '1982-12-03', 12.00, 'Library Technician', 1);
insert into employee values(2, 'Jones', 'Tanya', 656326572, '321 No St,', 'CA' , 6611322315, 'TJones@gmail.com', '1998-04-13', 0.00, 'Volunteer', 1);
insert into employee values(3, 'Fisher', 'Tom', 563217633, '42 Common Ave.', 'CA' , 6761235572, 'hamsterlover13@hotmail.com', '1987-06-23', 40.00, 'Head Librarian', 2);
insert into employee values(4, 'James', 'Ken', 742155313, '643 Hello St.', 'CA' , 6512351561, 'J3dIwannab3@yahoo.com', '1996-08-27', 12.50, 'Library Technician', 2);
insert into employee values(5, 'Ren', 'Chris', 543126898, '23 Bye Dr.', 'CA' , 5432136554, 'CRen@gmail.com', '1997-07-18', 12.00, 'Library Technician', 3);
insert into employee values(6, 'Ibarra', 'Albert', 132486531, '561 Scott Ave.', 'CA' , 7635692411, 'ahbangmahknee87@aol.com', '1993-06-04', 0.00, 'Volunteer', 4);
insert into employee values(7, 'Tanori', 'Daniel', 512579089, '651 Runner st.', 'CA' , 9877515573, 'DTanori@gmail.com', '1976-09-12', 40.00, 'Head Librarian', 4);
insert into employee values(8, 'Tuck', 'James', 564126713, '512 Juniper Dr.', 'CA' , 8552136587, 'JTUCK@gmail.com', '1985-08-03', 12.00, 'Library Technician', 1);
insert into employee values(9, 'Sam', 'Neil', 124231557, '123 Capree St.', 'CA' , 1511244512, 'NSamgmail.com', '1987-05-02', 40.00, 'Head Librarian', 1);
insert into employee values(10, 'Alric', 'Alvin', 613124121, '45 Constant Ave.', 'CA' , 5121235411, 'AA@gmail.com', '1998-06-12', 0.00, 'Volunteer', 3);
insert into employee values(11, 'Eric', 'Eric', 613765121, '454 What St.', 'CA' , 5127865411, 'EE@gmail.com', '1998-09-22', 40.00, 'Head Librarian', 3);
insert into employee values(12, 'Evans', 'Jerry', 676424121, '453 No St.', 'CA' , 5165425411, 'JEvans@gmail.com', '1990-07-15', 40.00, 'Head Librarian', 4);
insert into employee values(13, 'Seinfeld', 'Jenny', 677854121, '984 Constant Ave.', 'CA' , 1623425411, 'JSeinfeld@gmail.com', '1997-12-15', 40.00, 'Head Librarian', 5);
insert into employee values(14, 'Gates', 'Sally', 677897641, '924 Juniper Dr.', 'CA' , 4512325411, 'SGates@gmail.com', '1993-01-16', 40.00, 'Head Librarian', 1);
insert into employee values(15, 'Head', 'Kenny', 677878965, '851 Runner St.', 'CA' , 1623401931, 'KHead@gmail.com', '1992-01-03', 40.00, 'Head Librarian', 3);
insert into employee values(16, 'Rojas', 'Karen', 647354121, '163 What St.', 'CA' , 1652315411, 'KRojas@gmail.com', '1993-02-13', 40.00, 'Head Librarian', 2);
insert into employee values(17, 'Lemon', 'Lilly', 786524121, '765 Constant Ave.', 'CA' , 1667725411, 'LLemon@gmail.com', '1992-10-20', 12.00, 'Library Technician', 3);
insert into employee values(18, 'Lara', 'Ramon', 786546721, '896 Common Ave.', 'CA' , 1672125411, 'RLara@gmail.com', '1991-09-02', 12.00, 'Library Technician', 5);
insert into employee values(19, 'Hurtado', 'Christopher', 778654121, '654 Runner St.', 'CA' , 5432725411, 'CHurtado@gmail.com', '1994-04-21', 12.00, 'Library Technician', 4);
insert into employee values(20, 'Murillo', 'Christian', 786424121, '982 Juniper Dr.', 'CA' , 1667727865, 'CMurillo@gmail.com', '1996-03-18', 12.00, 'Library Technician', 5);

insert into worklog values(1, '2017-10-08', '1600', 3, 1);
insert into worklog values(2, '2017-10-01', '1300', 6, 1);
insert into worklog values(3, '2017-09-02', '1100', 8, 2);
insert into worklog values(4, '2016-08-23', '1200', 2, 3);
insert into worklog values(5, '2017-02-27', '1300', 5, 4);
insert into worklog values(6, '2017-04-02', '1000', 8, 4);
insert into worklog values(7, '2016-03-01', '1600', 2, 5);
insert into worklog values(8, '2017-04-06', '1800', 2, 6);
insert into worklog values(9, '2017-05-01', '1000', 5, 7);
insert into worklog values(10, '2017-08-06', '1400', 4, 8);
insert into worklog values(11, '2017-07-03', '1200', 5, 9);
insert into worklog values(12, '2017-09-12', '1000', 4, 10);
insert into worklog values(13, '2017-07-02', '1300', 5, 11);
insert into worklog values(14, '2017-07-03', '0900', 3, 12);
insert into worklog values(15, '2017-10-03', '1200', 5, 13);
insert into worklog values(16, '2017-01-04', '0900', 6, 14);
insert into worklog values(17, '2017-03-02', '1000', 3, 15);
insert into worklog values(18, '2017-04-12', '0900', 7, 16);
insert into worklog values(19, '2017-09-14', '1200', 4, 17);
insert into worklog values(20, '2017-05-04', '0800', 8, 18);
insert into worklog values(21, '2017-07-16', '0900', 3, 19);
insert into worklog values(22, '2017-03-15', '0900', 4, 20);
insert into worklog values(23, '2017-10-03', '1200', 4, 2);
insert into worklog values(24, '2017-07-11', '1000', 5, 3);
insert into worklog values(25, '2017-06-20', '1100', 4, 5);
insert into worklog values(26, '2017-08-22', '0900', 3, 6);
insert into worklog values(27, '2017-06-20', '0800', 6, 7);
insert into worklog values(28, '2017-07-25', '1300', 5, 8);
insert into worklog values(29, '2017-01-05', '1100', 3, 9);
insert into worklog values(30, '2017-03-18', '1200', 4, 10);
insert into worklog values(31, '2017-03-15', '1300', 5, 11);
insert into worklog values(32, '2017-05-02', '1400', 3, 12);
insert into worklog values(33, '2017-03-20', '1000', 5, 13);
insert into worklog values(34, '2017-06-17', '1400', 2, 14);
insert into worklog values(35, '2017-10-02', '0800', 6, 15);
insert into worklog values(36, '2017-07-10', '1200', 5, 16);
insert into worklog values(37, '2017-06-22', '1200', 4, 17);
insert into worklog values(38, '2017-07-24', '1000', 6, 18);
insert into worklog values(39, '2017-08-22', '0800', 4, 19);
insert into worklog values(40, '2017-10-04', '1200', 5, 20);
insert into worklog values(41, '2017-04-22', '0900', 6, 1);
insert into worklog values(42, '2017-05-17', '1400', 3, 2);
insert into worklog values(43, '2017-08-11', '1200', 4, 3);
insert into worklog values(44, '2017-03-11', '0900', 8, 4);
insert into worklog values(45, '2017-08-12', '1000', 3, 5);

insert into print values(0001, 2345121153, 'White Wolf', '1986', 4, 'Steven King', 1, 'IT', '1986', 'Horror');
insert into print values(0002, 1231234513, 'Giant', '1949', 3, 'George Orwell', 1, '1984', '1949', 'Science Fiction');
insert into print values(0003, 5664272312, 'Adventure Inc.', '1985', 4, 'Steven King', 1, 'Carrie', '1985', 'Horror');
insert into print values(0004, 5664272312, 'Adventure Inc.', '1985', 3, 'Steven King', 2, 'Carrie', '1985', 'Horror');
insert into print values(0005, 5555121328, 'White Wolf', 1932, 3, 'Aldous Huxley', 3, 'Brave New World', '1932', 'Science Fiction');
insert into print values(0006, 54837458123, 'Hello Books', '1978', 4, 'Steven King', 1, 'The Stand', '1978', 'Science Fiction');
insert into print values(0007, 54837458123, 'Hello Books', '1978', 5, 'Steven King', 5, 'The Stand', '1978', 'Science Fiction');
insert into print values(0009, 4124125563, 'Giant', '1990', 3, 'Mechael Crichton', 5, 'Jurassic Park', '1990', 'Science Fiction');
insert into print values(0010, 678562132, 'Goodbye Books', '2011', 4, 'Ernest Cline', 2,'Ready Player One', '2011', 'Science Fiction');
insert into print values(0011, 983248234, 'Yellow Inc', '1952', 3, 'Ralph Ellison', 1, 'The Invisible Man', '1952', 'Horror');
insert into print values(0012, 983248234, 'Yellow Inc', '1952', 2, 'Ralph Ellison', 3, 'The Invisible Man', '1952', 'Horror');
insert into print values(0013, 123182848, 'Edison', '1954', 5, 'J.R.R. Tolkien', 4, 'Lord of the Rings', '1954', 'Fantasy');
insert into print values(0014, 1294737818, 'Hello Books', '1925', 4, 'F. Scott Fitzgerald', 4, 'The Great Gatsby', '1925', 'Fiction');
insert into print values(0015, 1294737818, 'Hello Books', '1925', 3, 'F. Scott Fitzgerald', 4, 'The Great Gatsby', '1925', 'Fiction');
insert into print values(0016, 1342337818, 'White Wolf', '1940', 3, 'James Skeltor', 4, 'The Skeleton', '1940', 'Horror');
insert into print values(0017, 8976737818, 'Giant', '1998', 5, 'Duponte James', 1, 'There Be Dragons', '1998', 'Fantasy');
insert into print values(0018, 1299807818, 'Edison', '1990', 4, 'Scott Steiner', 2, 'All The Math', '1990', 'Biography');
insert into print values(0019, 1294737865, 'Goodbye Books', '2001', 4, 'Jack Skunk', 5, 'A Stinky Story', '1998', 'Non-Fiction');
insert into print values(0020, 1675737818, 'Yellow Inc', '1967', 5, 'Thomas James', 4, 'Box Boy', '1967', 'Fantasy');
insert into print values(0021, 1294897518, 'White Wolf', '1987', 4, 'John Sacks', 4, 'The Potato Bag', '1990', 'Non-Fiction');
insert into print values(0022, 7654237818, 'Giant', '2008', 3, 'Pete Passer', 3, 'Big Pumpkin', '2008', 'Horror');
insert into print values(0023, 1294787650, 'Adventure Inc', '2005', 4, 'Harold Ramis', 5, 'Buster', '2005', 'Fiction');
insert into print values(0024, 1289637818, 'Hello Books', '2004', 4, 'Dave Buster', 3, 'The Big Bomb', '2004', 'Science Fiction');

insert into electronic values(5001, 'White Wolf', TRUE, 3, 1, 'One Flew Over the Cuckoos Nest', 1975, 'Fiction');
insert into electronic values(5002, 'Glass House',FALSE, 2, 2, 'Jurassic Park', 1993, 'Science Fiction');
insert into electronic values(5003, 'Image', TRUE, 3, 3, 'The Lord of the Rings', 2001, 'Fantasy');
insert into electronic values(5004, 'IDD', FALSE, 3, 4, 'IT', 2017, 'Horror');
insert into electronic values(5005, 'Warner Bros', TRUE, 2, 5, 'The Great Batsby', 2013, 'Fiction');
insert into electronic values(5006, 'Fox', FALSE, 3, 1, 'Full Metal Jacket', 1987, 'Fiction');
insert into electronic values(5007, 'CBS', FALSE, 1, 2, 'Vertigo', 1958, 'Fiction');
insert into electronic values(5008, 'Giant', TRUE, 2, 3, '2001: A Space odyssey', 1968, 'Science Fiction');
insert into electronic values(5009, 'Image', FALSE, 3, 4, 'Fight Club', 1999, 'Fiction');
insert into electronic values(5010, 'Edison', TRUE, 2, 5, 'Aladdin', 1982, 'Animated');
insert into electronic values(5011, 'White Wolf', FALSE, 2, 1, 'Boxed', 1988, 'Horror');
insert into electronic values(5013, 'IDD', TRUE, 3, 2, 'Boxer', 1999, 'Fiction');
insert into electronic values(5014, 'Glass House', TRUE, 2, 3, 'Raging Bull', 2004, 'Non-Fiction');
insert into electronic values(5015, 'Image', TRUE, 1, 4, 'Song of Ice', 2002, 'Fantasy');
insert into electronic values(5016, 'Image', False, 3, 5, 'Highrise', 2001, 'Science Fiction');
insert into electronic values(5017, 'Edison', TRUE, 3, 1, 'Space Odyssey', 2004, 'Science Fiction');
insert into electronic values(5018, 'Fox', TRUE, 3, 2, 'The Odyssey', 2007, 'Fiction');
insert into electronic values(5019, 'Giant', TRUE, 3, 3, 'Continue?', 2003, 'Fantasy');
insert into electronic values(5020, 'Warner Bros', TRUE, 2, 4, 'Summer', 2004, 'Fiction');

insert into studyrooms values(1, 4, 'Study', 203, 1);
insert into studyrooms values(2, 4, 'Study', 401, 2);
insert into studyrooms values(3, 6, 'Visual Room', 101, 3);
insert into studyrooms values(4, 4, 'Study', 103, 4);
insert into studyrooms values(5, 8, 'Large Group', 207, 5);
insert into studyrooms values(6, 2, 'Study', 210, 1);
insert into studyrooms values(7, 8, 'Large Group', 304, 2);
insert into studyrooms values(8, 6, 'Visual Room', 211, 3);
insert into studyrooms values(9, 4, 'Study', 309, 4);
insert into studyrooms values(10, 4, 'Study', 106, 5);
insert into studyrooms values(11, 5, 'Study', 201, 1);
insert into studyrooms values(12, 6, 'Large Group', 221, 2);
insert into studyrooms values(13, 4, 'Study', 302, 3);
insert into studyrooms values(14, 4, 'Visual Room', 226, 4);
insert into studyrooms values(15, 4, 'Study', 202, 5);
insert into studyrooms values(16, 4, 'Study', 105, 1);
insert into studyrooms values(17, 4, 'Visual Room', 303, 2);
insert into studyrooms values(18, 5, 'Study', 313, 3);
insert into studyrooms values(19, 4, 'Study', 205, 4);
insert into studyrooms values(20, 5, 'Study', 323, 5);
insert into studyrooms values(21, 4, 'Visual Room', 204, 1);
insert into studyrooms values(22, 6, 'Large Group', 222, 3);
insert into studyrooms values(23, 4, 'Study', 336, 5);
insert into studyrooms values(24, 4, 'Study', 209, 2);
insert into studyrooms values(25, 4, 'Visual Room', 505, 4);

insert into cardholder values(1, 'Valle', 'Jeff', '415 Free St.', 'CA', 1421245123, 'JValle@gmail.com', '1967-10-04', 0.00, 1);
insert into cardholder values(2, 'Davidson', 'Arthur', '123 Nowhere Dr.', 'CA', 1217656654, 'ADavidson@gmail.com', '1978-02-01', 5.00, 2);
insert into cardholder values(3, 'Cameron', 'James', '7645 Camp St.', 'CA', 9871256546, 'JCameron@gmail.com', '1987-04-02', 3.00, 3);
insert into cardholder values(4, 'Hitchcock', 'Alfred', '987 High Dr.', 'CA', 6551354766, 'AHitchcock@gmail.com', '1990-06-07', 0.00, 4);
insert into cardholder values(5, 'Bradley', 'David', '988 Scott St.', 'CA', 7651243675, 'DBradley@gmail.com', '1998-07-09', 0.00, 5);
insert into cardholder values(6, 'Lynch', 'David', '3224 Empire Ave.', 'CA', 4097092544, 'DLynch@gmail.com', '1998-06-06', 1.00, 1);
insert into cardholder values(7, 'Hardwick', 'Chris', '1234 Chen St.', 'CA', 1095346534, 'CHardwick@gmail.com', '1988-05-12', 0.00, 2);
insert into cardholder values(8, 'Wesker', 'Albert', '764 Sunrise Ave.', 'CA', 4695431651, 'AWesker@gmail.com', '1987-07-06', 0.00, 3);
insert into cardholder values(9, 'Redfield', 'Claire', '731 Farm St.', 'CA', 5457641123, 'CRedfield@gmail.com', '1998-08-07', 100.00, 4);
insert into cardholder values(10, 'Acosta', 'Derrick', '654 Mega Ave.', 'CA', 3478766567, 'DAcosta@gmail.com', '1987-07-09', 0.00, 5);
insert into cardholder values(11, 'Burberry', 'Jill', '541 Scott St.', 'CA', 8976466567, 'JBurberry@gmail.com', '1989-02-12', 5.00, 1);
insert into cardholder values(12, 'Chucka', 'Bill', '542 Nowhere Dr.', 'CA', 4653766567, 'BChucka@gmail.com', '2001-05-03', 0.00, 2);
insert into cardholder values(13, 'Klein', 'John', '763 Camp St.', 'CA', 4521766567, 'JKlein@gmail.com', '1983-10-22', 0.00, 3);
insert into cardholder values(14, 'Stinson', 'Daniel', '431 High Dr.', 'CA', 3474356767, 'DStinson@gmail.com', '1992-11-15', 5.00, 4);
insert into cardholder values(15, 'Stein', 'Alfred', '772 Farm St.', 'CA', 3472315767, 'AStein@gmail.com', '1992-05-11', 6.00, 5);
insert into cardholder values(16, 'Scott', 'Den', '786 Empire Ave.', 'CA', 3476754367, 'DScott@gmail.com', '2002-03-15', 2.00, 1);
insert into cardholder values(17, 'Chin', 'Jen', '561 High St.', 'CA', 4567154316, 'JChin@gmail.com', '2001-10-15', 0.00, 2);
insert into cardholder values(18, 'Martinez', 'Salvador', '873 Camp St.', 'CA', 3474378667, 'SMartinez@gmail.com', '1999-06-01', 0.00, 3);
insert into cardholder values(19, 'Hurtado', 'Hector', '980 Empire Ave.', 'CA', 3478438577, 'HHurtado@gmail.com', '1992-09-11', 0.00, 4);
insert into cardholder values(20, 'Ibarra', 'Sarah', '987 Chen St.', 'CA', 3478679547, 'SIbarra@gmail.com', '2001-08-14', 0.00, 5);

insert into worksfor values('2001-01-24', '2016-12-11', 1, 1);
insert into worksfor values('2017-01-12', NULL, 2, 1);
insert into worksfor values('2016-02-01', NULL, 3, 2);
insert into worksfor values('2013-02-11', NULL, 4, 2);
insert into worksfor values('2011-11-14', NULL, 5, 3);
insert into worksfor values('2003-12-11', NULL, 6, 4);
insert into worksfor values('2011-10-18', '2017-01-12', 7, 5);
insert into worksfor values('2013-12-21', NULL, 8, 1);
insert into worksfor values('2014-11-16', NULL, 9, 1);
insert into worksfor values('2013-10-12', NULL, 10, 3);
insert into worksfor values('2014-02-11', NULL, 11, 3);
insert into worksfor values('2011-12-23', NULL, 12, 4);
insert into worksfor values('2012-02-13', NULL, 13, 5);
insert into worksfor values('2016-05-17', NULL, 14, 1);
insert into worksfor values('2014-09-21', NULL, 15, 3);
insert into worksfor values('2015-04-22', NULL, 16, 2);
insert into worksfor values('2012-10-15', '2014-11-29', 17, 3);
insert into worksfor values('2012-12-23', NULL, 18, 4);
insert into worksfor values('2013-03-11', NULL, 19, 4);
insert into worksfor values('1999-03-18', NULL, 20, 5);
insert into worksfor values('1999-03-21', '2015-12-11', 16, 5);

insert into rentprint values('2017-02-14', '2017-02-25', 1, 0001);
insert into rentprint values('2017-02-01', '2017-02-08', 1, 0003);
insert into rentprint values('2017-02-03', '2017-02-10', 1, 0006);
insert into rentprint values('2017-03-12', '2017-03-19', 1, 0011);
insert into rentprint values('2017-05-11', '2017-05-18', 2, 0002);
insert into rentprint values('2017-04-01', '2017-04-08', 2, 0005);
insert into rentprint values('2017-01-11', '2017-01-18', 2, 0007);
insert into rentprint values('2017-03-13', '2017-03-20', 3, 0004);
insert into rentprint values('2017-02-10', '2017-02-17', 4, 0008);
insert into rentprint values('2017-06-13', '2017-06-20', 5, 0009);
insert into rentprint values('2017-04-22', '2017-04-29', 6, 0010);
insert into rentprint values('2017-06-04', '2017-06-11', 7, 0012);
insert into rentprint values('2017-03-18', '2017-03-25', 8, 0013);
insert into rentprint values('2017-07-12', '2017-07-19', 9, 0014);
insert into rentprint values('2017-06-14', '2017-06-22', 10, 0015);
insert into rentprint values('2017-08-02', '2017-08-02', 11, 0016);
insert into rentprint values('2017-03-11', '2017-03-04', 12, 0017);
insert into rentprint values('2017-09-14', '2017-09-21', 13, 0018);
insert into rentprint values('2017-06-10', '2017-06-17', 14, 0019);
insert into rentprint values('2017-04-11', '2017-04-18', 15, 0020);
insert into rentprint values('2017-06-10', '2017-06-17', 16, 0021);
insert into rentprint values('2017-03-10', '2017-03-17', 17, 0022);
insert into rentprint values('2017-06-02', '2017-06-13', 17, 0023);
insert into rentprint values('2017-10-08', '2017-10-15', 18, 0024);
insert into rentprint values('2017-10-01', '2017-10-09', 19, 0002);
insert into rentprint values('2017-10-01', '2017-10-09', 19, 0006);
insert into rentprint values('2017-10-11', '2017-10-18', 20, 0014);
insert into rentprint values('2017-11-01', '2017-11-09', 1, 0015);
insert into rentprint values('2017-09-04', '2017-09-11', 2, 0006);
insert into rentprint values('2017-08-05', '2017-08-12', 3, 0008);
insert into rentprint values('2017-10-19', '2017-10-26', 4, 0009);
insert into rentprint values('2017-11-15', '2017-11-22', 5, 0010);

insert into rentelectronic values('2017-11-15', '2017-11-18', 1, 5001);
insert into rentelectronic values('2017-12-10', '2017-12-17', 2, 5002);
insert into rentelectronic values('2017-10-15', '2017-10-22', 3, 5003);
insert into rentelectronic values('2017-01-02', '2017-01-09', 4, 5004);
insert into rentelectronic values('2017-01-10', '2017-01-17', 5, 5005);
insert into rentelectronic values('2017-01-20', '2017-01-27', 6, 5006);
insert into rentelectronic values('2017-02-04', '2017-02-11', 7, 5007);
insert into rentelectronic values('2017-02-12', '2017-02-19', 8, 5008);
insert into rentelectronic values('2017-02-21', '2017-02-28', 9, 5009);
insert into rentelectronic values('2017-03-02', '2017-03-09', 10, 5010);
insert into rentelectronic values('2017-03-10', '2017-03-17', 11, 5011);
insert into rentelectronic values('2017-03-22', '2017-03-29', 12, 5012);
insert into rentelectronic values('2017-04-04', '2017-04-11', 13, 5013);
insert into rentelectronic values('2017-04-14', '2017-04-21', 14, 5014);
insert into rentelectronic values('2017-04-22', '2017-04-29', 15, 5015);
insert into rentelectronic values('2017-05-02', '2017-05-09', 16, 5016);
insert into rentelectronic values('2017-05-12', '2017-05-19', 17, 5017);
insert into rentelectronic values('2017-05-21', '2017-05-29', 18, 5018);
insert into rentelectronic values('2017-06-05', '2017-06-12', 19, 5019);
insert into rentelectronic values('2017-07-04', '2017-07-11', 20, 5020);
insert into rentelectronic values('2017-07-15', '2017-07-23', 1, 5002);
insert into rentelectronic values('2017-08-02', '2017-08-09', 2, 5004);
insert into rentelectronic values('2017-08-11', '2017-08-19', 3, 5006);
insert into rentelectronic values('2017-08-21', '2017-08-28', 4, 5008);
insert into rentelectronic values('2017-09-02', '2017-09-10', 5, 5010);
insert into rentelectronic values('2017-09-11', '2017-09-19', 2, 5001);
insert into rentelectronic values('2017-09-20', '2017-09-28', 4, 5003);
insert into rentelectronic values('2017-10-01', '2017-10-09', 6, 5005);
insert into rentelectronic values('2017-10-11', '2017-10-20', 8, 5007);
insert into rentelectronic values('2017-10-21', '2017-10-29', 10, 5009);

insert into requests values('2017-01-02', '1200', '2017-01-02', '1400', 1, 1);
insert into requests values('2017-01-05', '1100', '2017-01-05', '1300', 2, 2);
insert into requests values('2017-01-10', '1300', '2017-01-10', '1400', 3, 3);
insert into requests values('2017-01-15', '0900', '2017-01-15', '1100', 4, 4);
insert into requests values('2017-01-20', '0800', '2017-01-20', '1200', 5, 5);
insert into requests values('2017-01-25', '1400', '2017-01-25', '1600', 6, 6);
insert into requests values('2017-02-03', '1600', '2017-02-03', '1700', 7, 7);
insert into requests values('2017-02-06', '1000', '2017-02-06', '1200', 8, 8);
insert into requests values('2017-02-10', '0900', '2017-02-10', '1000', 9, 9);
insert into requests values('2017-02-16', '0800', '2017-02-16', '1100', 10, 10);
insert into requests values('2017-02-25', '0900', '2017-02-25', '1100', 11, 11);
insert into requests values('2017-03-02', '1300', '2017-03-02', '1500', 12, 12);
insert into requests values('2017-03-10', '1000', '2017-03-10', '1200', 13, 13);
insert into requests values('2017-03-15', '1200', '2017-03-15', '1300', 14, 14);
insert into requests values('2017-03-23', '1000', '2017-03-23', '1200', 15, 15);
insert into requests values('2017-04-05', '1200', '2017-04-05', '1300', 16, 16);
insert into requests values('2017-04-08', '1200', '2017-04-08', '1400', 17, 17);
insert into requests values('2017-04-14', '1300', '2017-04-14', '1500', 18, 18);
insert into requests values('2017-04-20', '1500', '2017-04-20', '1700', 19, 19);
insert into requests values('2017-04-27', '1400', '2017-04-27', '1800', 20, 20);
insert into requests values('2017-05-03', '1400', '2017-05-03', '1600', 21, 1);
insert into requests values('2017-05-10', '1500', '2017-05-10', '1600', 22, 2);
insert into requests values('2017-05-14', '1200', '2017-05-14', '1400', 23, 3);
insert into requests values('2017-05-22', '0800', '2017-05-22', '1000', 24, 4);
insert into requests values('2017-05-28', '0900', '2017-05-28', '1100', 25, 5);
insert into requests values('2017-06-05', '0900', '2017-06-05', '1000', 1, 6);
insert into requests values('2017-06-10', '1100', '2017-06-10', '1300', 2, 7);
insert into requests values('2017-06-14', '1100', '2017-06-14', '1200', 3, 8);
insert into requests values('2017-06-20', '0800', '2017-06-20', '0900', 4, 9);
insert into requests values('2017-06-27', '1100', '2017-06-27', '1300', 5, 10);

CREATE OR REPLACE FUNCTION new_cardholder(ChID integer, Lname varchar(30), Fname varchar(30), Address varchar(50), State varchar(2), Phone bigint, Email varchar(25), Bdate date, Latefees float, LID integer)
RETURNS void AS $$
BEGIN
INSERT INTO cardholder VALUES(chID, lname, fname, address, state, phone, email, bdate, latefees, lID);
END;
$$ LANGUAGE 'plpgsql'; 

CREATE OR REPLACE FUNCTION delete_cardholder(drop integer)
RETURNS void AS $$
BEGIN
DELETE FROM cardholder WHERE chID = drop;
END;
$$ LANGUAGE 'plpgsql';

CREATE OR REPLACE FUNCTION update_trigger() RETURN trigger AS
$BODY$
BEGIN
IF NEW.chID <> OLD.chID THEN
UPDATE RentElectronic re
SET OLD.chID = NEW.chID
WHERE re.chID = c.chID;
UPDATE RentPrint rp
SET OLD.chID = NEW.chID
WHERE rp.chID = c.chID;
UPDATE Requests r
SET OLD.chID = NEW.chID
WHERE r.chID = c,chID;

END IF;

RETURN NEW;
END:
$BODY$
LANGUAGE 'plpgsql';

CREATE TRIGGER beforeUpdate
BEFORE INSERT OR UPDATE
ON cardholder
FOR EACH ROW
EXECTUE PROCEDURE update_trigger();










CREATE FUNCTION delete_trigger() RETURNS trigger AS
$BODY$
BEGIN

DELETE FROM RentElectronic re
WHERE re.chID = OLD.chID;
DELETE FROM RentPrint rp
WHERE rp.chID = OLD.chID;
DELETE FROM Requests r
WHERE r.chID = OLD.chID;
END;
$BODY$
LANGUAGE 'plpgsql';

CREATE TRIGGER deleteRow
BEFORE DELETE
ON cardholder
FOR EACH ROW
EXECUTE PROCEDURE delete_trigger();

CREATE OR REPLACE VIEW viewCardholders AS
SELECT
c.chID AS chID,
c.lname AS lname,
c.fname AS fname,
c.address AS address,
c.state AS state,
c.phone AS phone,
c.email AS email,
c.bdate AS bdate,
c.latefees AS latefees,
c.lID AS lID
FROM cardholder c;

CREATE FUNCTION update_view() RETURNS trigger AS
$BODY$
BEGIN
UPDATE view Cardholders cd
SET cd.chID = NEW.chID
WHERE cd.chID = OLD.chID;
RETURN NEW;
END;
$BODY$
LANGUAGE 'plpgsql';

CREATE TRIGGER instead_trigger
INSTEAD OF UPDATE
ON viewCardholders
FOR EACH ROW
EXECUTE PROCEDURE update_view();








CREATE OR REPLACE FUNCTION averageCopies()
RETURNS float AS $average$
declare
average float;
BEGIN
RETURN(
SELECT AVG(pnumcopy ) “Average of copies in library” FROM print
);
END;
$average$
LANGUAGE 'plpgsql';