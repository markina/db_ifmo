CREATE TABLE Planes (
    PlaneId INT NOT NULL PRIMARY KEY,
    PlaneName VARCHAR(20) NOT NULL,
    Seating INT NOT NULL
);

CREATE TABLE Flights (
    FlightId  INT NOT NULL PRIMARY KEY,
    FlightTime TIMESTAMP NOT NULL,
    PlaneId INT NOT NULL
);

-- Seats появляются при добавлении нового самолета, для каждого из Seating. 
CREATE TABLE Seats (
    PlaneId INT NOT NULL,
    SeatNo INT NOT NULL,
    PRIMARY KEY(PlaneId, SeatNo)
);

-- Tichets заполняются при добавлении нового рейса
CREATE TABLE Tickets (
    FlightId INT NOT NULL,
    SeatNo INT NOT NULL,
    Status VARCHAR(1) NOT NULL,
    UpdateTime TIMESTAMP NOT NULL,
    PRIMARY KEY (FlightId, SeatNo)
);

   ALTER TABLE Flights
ADD CONSTRAINT fk_plane 
   FOREIGN KEY (PlaneId) 
    REFERENCES Planes(PlaneId);

    ALTER TABLE Seats
ADD CONSTRAINT fk_plane 
   FOREIGN KEY (PlaneId) 
    REFERENCES Planes(PlaneId);

    ALTER TABLE Tickets
ADD CONSTRAINT fk_flight 
   FOREIGN KEY (FlightId) 
    REFERENCES Flights(FlightId);

CREATE FUNCTION VALID_SEAT_NO(seat INT, flight INT) 
        RETURNS BOOLEAN 
             AS $$ BEGIN
                      RETURN seat IN (SELECT s.SeatNo FROM Seats s WHERE s.PlaneId IN (SELECT f.PlaneId FROM Flights f WHERE f.FlightId = flight));
                     END; 
                $$ 
       LANGUAGE plpgsql;

   ALTER TABLE Tickets
ADD CONSTRAINT fk_seat 
         CHECK (VALID_SEAT_NO(SeatNo, FlightId));

INSERT INTO Planes
    (PlaneId, PlaneName, Seating) VALUES
    (1, 'Airbus A319', 3),
    (2, 'Airbus A380', 2),
    (3, 'Boeing 747', 4),
    (4, 'Boeing 777', 5);

insert into Flights
    (FlightId, FlightTime, PlaneId) Values 
    (1, '2015-11-27 23:00', 1),
    (2, '2015-11-28 23:00', 1),
    (3, '2015-11-29 23:00', 1),
    (4, '2015-11-28 04:00', 3),
    (5, '2015-11-28 07:00', 2);

CREATE OR REPLACE FUNCTION create_free_seats() 
RETURNS TRIGGER 
LANGUAGE plpgsql
AS $function$
    DECLARE
        i int;
    BEGIN
        i := 1;
        LOOP
            INSERT INTO Tickets (FlightId, SeatNo, Status, UpdateTime) 
                 VALUES (NEW.FlightId, i, 'F', NOW());
            i := i + 1;
            EXIT WHEN NOT VALID_SEAT_NO(i, NEW.FlightId);
        END LOOP;
        RETURN NEW;  
    END;
$function$;

CREATE TRIGGER trigger_create_free_seats 
  AFTER INSERT
  ON Flights
  FOR EACH ROW EXECUTE PROCEDURE create_free_seats();

CREATE INDEX pk_index_tikets ON Tickets
(FlightId, SeatNo);

-- для частых запросов по средней заполненности самолета
CREATE INDEX filght_status_index_tikets ON Tickets
(FlightId, Status);


CREATE INDEX planeid_index_seats ON Seats
(PlaneId);

CREATE INDEX pk_flights ON Flights
(FlightId);

CREATE INDEX pk_planes ON Planes
(PlaneId);