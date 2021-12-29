USE office_management;

drop table company;
create table Company (
	Company_Name VARCHAR(50),
	Location VARCHAR(50),
	Company_Id VARCHAR(50),
    Area VARCHAR(50),
    Industry varchar(50),
    Country varchar(15)
);

create table Booking (
	Booking_ID VARCHAR(50),
	Emp_Id VARCHAR(6),
	Date DATE,
	Start_Time VARCHAR(50),
	End_Time VARCHAR(50),
	Time_zone VARCHAR(50)
);

create table Account (
	Company_Name VARCHAR(100),
	Emp_ID VARCHAR(10),
	First_Name VARCHAR(100),
	Last_Name VARCHAR(100),
	Email_ID VARCHAR(100),
	Password VARCHAR(50)
);

create table Building (
	Building_Number VARCHAR(50),
	Building_Name VARCHAR(50),
	Location VARCHAR(50),
	Company_Name VARCHAR(30)
);

create table Room_type (
	Room_Id VARCHAR(50),
	Room_Name VARCHAR(50),
    Booking_id VARCHAR(15),
	Capacity INT,
    Room_Type VARCHAR(20),
	Building_Number VARCHAR(40),
	Building_Name VARCHAR(40),
	Floor_Number VARCHAR(50),
	Utilities VARCHAR(15),
	Media VARCHAR(50)
);

create table User (
	Company_Name VARCHAR(30),
	Emp_Id VARCHAR(50),
	Email_ID VARCHAR(50),
	First_Name VARCHAR(50),
	Last_Name VARCHAR(50),
	Dept_Name VARCHAR(50)
);

create table Cab_Service (
	Cab_Vendor_Name VARCHAR(50),
	Cab_Provider_Id VARCHAR(50),
	Emp_Id VARCHAR(6),
	Company_Name VARCHAR(30),
	Car_Type VARCHAR(13),
	Date DATE,
	Start_Location VARCHAR(50),
	End_Location VARCHAR(50),
	PickUp_Time VARCHAR(50),
	Passenger_Count INT,
	Distance_from_home_inMiles INT
);

#1. Number of bookings per day in May 2020
select date as Date,count(booking_id) as Number_of_bookings from booking 
where date like '%2020-05%'
group by date 
order by Number_of_bookings desc;

#2. Busiest hours per day in the month of Feb, 2021
select date as 'Feb_2021', hour(start_time) as Busiest_Hours, start_time as Time, count(*) 'Number_of_bookings' from booking
where date like '%2021-02%'
group by Busiest_Hours
order by count(*) desc;

#3. Busiest days per month of Aug 2021
select date_format(date, '%y-%m') as 'Month', day(date) as Busiest_day, count(*) 'Number_of_bookings' from booking
where date like '%2021-08%'
group by busiest_day
order by count(*) desc;

#4. Most number of bookings based on departments
select a.dept_name, count(b.booking_id) as No_of_bookings, b.date from user as a, booking as b
where a.emp_id = b.emp_id and DATE(b.date) between '2020-01-01' AND '2020-12-31'
group by a.dept_name
order by No_of_bookings desc;

#5. Most number of bookings vs Least number of bookings in the month of Feb- March 2021 (classified by weeks)
select count(booking_id) NumberOfBookings, week(date) Week_Number, date Feb_March_2021  from booking
where date between '2021-02-01' and '2021-03-01'
group by week(date)
order by count(booking_id) desc;

#6. Employee count who prefer Gas vehciles vs Electric Vehicles
select count(a.booking_id), b.car_type from booking as a, cab_Service as b
where a.emp_id = b.emp_id
group by b.car_type;

#7. Count of employees who opted for cab facilities within 20miles radius vs beyond 20miles radius from their office locality
select count(emp_id) as 'Total number of employees who tale cab service',
(select count(emp_id)  from cab_service where distance_from_home_inMiles >=20) as 'Count of Employees who opted for Cab facility and live more than 20 miles from office',
(select count(emp_id)  from cab_service where distance_from_home_inMiles <20) as 'Count of Employees who opted for Cab facility and live less than 20 miles from office'
from cab_service; 

#8. Area(Branch) names which are being occupied the most by companies and frequently booked by employees
Select area, count(company_name) as Number_of_Companies from company
group by area
order by number_of_companies desc;

#9. Employees who prefer visiting the office to work alone OR to attend meetings 
select count(booking.booking_id) as Number_ofBookings, room_type.room_type as 'Type_of_Room' from booking
LEFT JOIN room_type
on booking.booking_id= room_type.booking_id
where room_type.room_type IS NOT NULL
group by room_type;

#10. Industries which have adopted Office Space Optization Concept
Select  Country, Industry, count(company_name) as Number_of_Companies from company
where industry not in ('n/a')
group by country
order by Number_of_Companies desc;





