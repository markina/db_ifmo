1. FreeSeats(FlightId) — список мест, доступных для продажи и бронирования.

CREATE OR REPLACE FUNCTION FreeSeats(Flight INT)
RETURNS TABLE (SeatNoOut INT, StatusOut VARCHAR(1))
LANGUAGE plpgsql
AS $function$
    DECLARE 
        row Tickets%ROWTYPE;
    BEGIN
        IF (((SELECT f.FlightTime FROM Flights f WHERE f.FlightId = Flight) - INTERVAL '1 day') < NOW())
        THEN 
            UPDATE Tickets
               SET Status = 'F', UpdateTime = NOW() 
             WHERE FlightId = Flight
               AND Status = 'R';
        END IF;

        UPDATE Tickets
           SET Status = 'F', UpdateTime = NOW() 
         WHERE FlightId = Flight
           AND Status = 'R'
           AND UpdateTime + INTERVAL '1 day' < NOW();

        RETURN QUERY (SELECT t.SeatNo, t.Status FROM Tickets t WHERE t.FlightId = Flight AND t.Status = 'F');
    END;
$function$;


2. Reserve(FlightId, SeatNo) — пытается забронировать место. Возвращает истину, если удалось и ложь — в противном случае.

CREATE OR REPLACE FUNCTION Reserve(Flight INT, Seat INT)
RETURNS BOOLEAN 
LANGUAGE plpgsql
AS $function$
    DECLARE 
        row Tickets%ROWTYPE;
    BEGIN
        IF (((SELECT f.FlightTime FROM Flights f WHERE f.FlightId = Flight) - INTERVAL '1 day') < NOW())
        THEN 
            RETURN FALSE;
        END IF;

        SELECT *
          INTO row
          FROM Tickets t
         WHERE t.FlightId = Flight 
           AND t.SeatNo = Seat;
        
        IF (row.Status = 'S' OR row.Status = 'R' AND row.UpdateTime + INTERVAL '1 day' > NOW())
        THEN 
            RETURN FALSE;
        END IF;
        
        UPDATE Tickets
           SET Status = 'R', UpdateTime = NOW() 
         WHERE FlightId = Flight
           AND SeatNo = Seat;
        RETURN TRUE;
    END;
$function$;

3. ExtendReservation(FlightId, SeatNo) — пытается продлить бронь места. Возвращает истину, если удалось и ложь — в противном случае.

CREATE OR REPLACE FUNCTION ExtendReservation(Flight INT, Seat INT)
RETURNS BOOLEAN 
LANGUAGE plpgsql
AS $function$
    DECLARE 
        row Tickets%ROWTYPE;
    BEGIN
        IF (((SELECT f.FlightTime FROM Flights f WHERE f.FlightId = Flight) - INTERVAL '1 day') < NOW())
        THEN 
            RETURN FALSE;
        END IF;

        SELECT *
          INTO row
          FROM Tickets t
         WHERE t.FlightId = Flight 
           AND t.SeatNo = Seat;
        
        IF (row.Status = 'S' OR row.Status = 'F' OR row.Status = 'R' AND row.UpdateTime + INTERVAL '1 day' < NOW())
        THEN 
            RETURN FALSE;
        END IF;
        
        UPDATE Tickets
           SET Status = 'R', UpdateTime = NOW() 
         WHERE FlightId = Flight
           AND SeatNo = Seat;
        RETURN TRUE;
    END;
$function$;

4. BuyFree(FlightId, SeatNo) — пытается купить свободное место. Возвращает истину, если удалось и ложь — в противном случае.

CREATE OR REPLACE FUNCTION BuyFree(Flight INT, Seat INT)
RETURNS BOOLEAN 
LANGUAGE plpgsql
AS $function$
    DECLARE 
        row Tickets%ROWTYPE;
        departureTime TIMESTAMP;
    BEGIN
        SELECT f.FlightTime INTO departureTime FROM Flights f WHERE f.FlightId = Flight;

        IF (departureTime - INTERVAL '2 hours' < NOW())
        THEN 
            RETURN FALSE;
        END IF;


        SELECT *
          INTO row
          FROM Tickets t
         WHERE t.FlightId = Flight 
           AND t.SeatNo = Seat;


        IF (departureTime - INTERVAL '1 day' > NOW() 
            AND row.Status = 'R'
            AND row.UpdateTime + INTERVAL '1 day' > NOW())
        THEN 
            RETURN FALSE;
        END IF;


        
        IF (row.Status = 'S')
        THEN 
            RETURN FALSE;
        END IF;
        
        UPDATE Tickets
           SET Status = 'S', UpdateTime = NOW() 
         WHERE FlightId = Flight
           AND SeatNo = Seat;
        RETURN TRUE;
    END;
$function$;

5. BuyReserved(FlightId, SeatNo) — пытается выкупить забронированное место. Возвращает истину, если удалось и ложь — в противном случае.

CREATE OR REPLACE FUNCTION BuyReserved(Flight INT, Seat INT)
RETURNS BOOLEAN 
LANGUAGE plpgsql
AS $function$
    DECLARE 
        row Tickets%ROWTYPE;
    BEGIN
        IF ((SELECT f.FlightTime FROM Flights f WHERE f.FlightId = Flight) - INTERVAL '1 day' < NOW())
        THEN 
            RETURN FALSE;
        END IF;

        SELECT *
          INTO row
          FROM Tickets t
         WHERE t.FlightId = Flight 
           AND t.SeatNo = Seat;
        
        IF (row.Status = 'S' OR row.Status = 'F' OR row.Status = 'R' AND row.UpdateTime + INTERVAL '1 day' < NOW())
        THEN 
            RETURN FALSE;
        END IF;
        
        UPDATE Tickets
           SET Status = 'S', UpdateTime = NOW() 
         WHERE FlightId = Flight
           AND SeatNo = Seat;
        RETURN TRUE;
    END;
$function$;

6. FlightStatistics() — возвращает статистику по рейсам: возможность бронирования и покупки, число свободных, забронированных и проданных мест.

CREATE OR REPLACE FUNCTION FlightStatistics()
RETURNS TABLE (Flight INT, ReserveationAvailable BOOLEAN, SellAvailable BOOLEAN, FreeSeats BIGINT, ReservedSeats BIGINT, SoldSeats BIGINT)
LANGUAGE plpgsql
AS $function$
    BEGIN
        RETURN QUERY (SELECT f.FlightId AS Flight, 
                            -- ReservedAvailable,
                            (f.FlightTime - INTERVAL '1 day' > NOW() 
                            AND 'F' IN (SELECT t.status 
                                          FROM Tickets t 
                                         WHERE f.FlightId = t.FlightId) 
                            OR 'R' IN (SELECT t.status 
                                         FROM Tickets t 
                                        WHERE f.FlightId = t.FlightId 
                                          AND t.UpdateTime + INTERVAL '1 day' < NOW())) AS ReserveationAvailable,
                            -- SellAvailable, 
                            (f.FlightTime - INTERVAL '2 hours' > NOW() 
                            AND 'F' IN (SELECT t.status 
                                          FROM Tickets t 
                                         WHERE f.FlightId = t.FlightId) 
                            OR 'R' IN (SELECT t.status 
                                         FROM Tickets t 
                                        WHERE f.FlightId = t.FlightId 
                                          AND (t.UpdateTime + INTERVAL '1 day' < NOW()
                                           OR f.FlightTime - INTERVAL '1 day' < NOW()) )) AS SellAvailable,
                            -- FreeSeats,
                            (SELECT count(*) 
                               FROM Tickets t
                              WHERE t.FlightId = f.FlightId
                                AND (t.status = 'F'
                                 OR t.status = 'R' 
                                AND (t.UpdateTime + INTERVAL '1 day' < NOW()
                                 OR f.FlightTime - INTERVAL '1 day' < NOW()))) AS FreeSeats,
                            -- ReservedSeats,
                            (SELECT count(*) 
                               FROM Tickets t
                              WHERE t.FlightId = f.FlightId
                                AND t.status = 'R' 
                                AND (t.UpdateTime + INTERVAL '1 day' > NOW()
                                 OR f.FlightTime - INTERVAL '1 day' > NOW())) AS ReservedSeats,
                            -- SoldSeats,
                            (SELECT count(*) 
                               FROM Tickets t
                              WHERE t.FlightId = f.FlightId
                                AND t.status = 'S') AS SoldSeats
                        FROM Flights f 
                        );
    END;
$function$;
