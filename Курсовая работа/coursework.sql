CREATE TABLE card (
    id               SERIAL  PRIMARY KEY,
    card_type_id       INT       NOT NULL,
    cardholder_id     INT,
    balance            REAL      NOT NULL,
    trips           INT          NOT NULL,
    start_date         DATE      NOT NULL,
    last_trip_datetime TIMESTAMP,
    last_trip_place_id INT
);

CREATE TABLE card_type (
    id              INT       PRIMARY KEY,
    name            VARCHAR(100) NOT NULL,
    duration_day    INT          NOT NULL,
    price           REAL         NOT NULL,
    trips           INT          NOT NULL,
    trips_for       VARCHAR(4)   NOT NULL,
    unlims          VARCHAR(4)   NOT NULL,
    timeout_minute   INT          NOT NULL,
    category        CHAR(1)      NOT NULL,
    require_holder  BOOLEAN      NOT NULL
);

CREATE TABLE place (
    id           SERIAL PRIMARY KEY,
    transport_id INT NOT NULL
);

CREATE TABLE transport (
    id    SERIAL      PRIMARY KEY,
    type  CHAR(1)     NOT NULL,
    price REAL        NOT NULL
);

CREATE TABLE cardholder (
    id         SERIAL  PRIMARY KEY,
    name       VARCHAR(50) NOT NULL,
    surname    VARCHAR(50) NOT NULL,
    path_photo VARCHAR(50) NOT NULL,
    category   CHAR(1)     NOT NULL,
    status     BOOLEAN         NOT NULL
);

CREATE TABLE purchase (
    card_id       INT  NOT NULL,
    start_date    DATE NOT NULL
);


CREATE TABLE use (
    card_id  INT       NOT NULL,
    place_id INT       NOT NULL,
    usetime  TIMESTAMP NOT NULL,
    accepted BOOLEAN       NOT NULL
);

   ALTER TABLE card
ADD CONSTRAINT card_cardtype
   FOREIGN KEY (card_type_id) 
    REFERENCES card_type(id);

   ALTER TABLE purchase
ADD CONSTRAINT purchase_card
   FOREIGN KEY (card_id) 
    REFERENCES card(id);

   ALTER TABLE use
ADD CONSTRAINT using_card 
   FOREIGN KEY (card_id) 
    REFERENCES card(id);

   ALTER TABLE use
ADD CONSTRAINT using_place 
   FOREIGN KEY (place_id) 
    REFERENCES place(id);

   ALTER TABLE card
ADD CONSTRAINT card_cardholder
   FOREIGN KEY (cardholder_id) 
    REFERENCES cardholder(id);

   ALTER TABLE card
ADD CONSTRAINT card_last_place 
   FOREIGN KEY (last_trip_place_id) 
    REFERENCES place(id);

    ALTER TABLE place
ADD CONSTRAINT place_transport 
   FOREIGN KEY (transport_id) 
    REFERENCES transport(id);

INSERT INTO card_type
    (id, name,                                                                 duration_day, price, trips, trips_for, unlims,  timeout_minute, category, require_holder) VALUES
    (1,  'ПБ «Автобус»',                                                       30,           1445,  0,     '',        'B',     10,            'A',       FALSE),
    (2,  'ПБ «Трамвай»',                                                       30,           1445,  0,     '',        'T',     10,            'A',       FALSE),
    (3,  'ПБ «Троллейбус»',                                                    30,           1445,  0,     '',        'L',     10,            'A',       FALSE),
    (4,  'ПБ «Трамвай-Автобус»',                                               30,           1710,  0,     '',        'TB',    10,            'A',       FALSE),
    (5,  'ПБ «Троллейбус-Автобус»',                                            30,           1710,  0,     '',        'LB',    10,            'A',       FALSE),
    (6,  'ПБ «Трамвай-Троллейбус»',                                            30,           1710,  0,     '',        'TL',    10,            'A',       FALSE),
    (7,  'ПБ «Трамвай-Троллейбус-Автобус»',                                    30,           1815,  0,     '',        'TLB',   10,            'A',       FALSE),
    (8,  'ПБ «Месячный именной автобусный билет для учащихся»',                30,           315,   0,     '',        'B',     10,            'P',       TRUE),
    (9,  'Комбинированный (трамвай, троллейбус, автобус) билет на 10 поездок', 60,           290,   10,    'BTL',     '',      10,            'A',       FALSE)
;

INSERT INTO card_type
    (id, name,                                                                 duration_day, price, trips, trips_for, unlims, timeout_minute, category, require_holder) VALUES
    (10, 'ПБ ученический единый на месяц',                                     30,           480,   70,    'M',       'BTL',  10,            'P',       TRUE),
    (11, 'ПБ студенческий единый на месяц',                                    30,           960,   100,   'M',       'BTL',  10,            'S',       TRUE),
    (12, 'ПБ единый на месяц',                                                 30,           2690,  70,    'M',       'BTL',  10,            'A',       TRUE),
    (13, 'ПБ на метро на 10 поездок и 7 дней',                                 7,            330,   10,    'M',       '',     10,            'A',       FALSE),
    (14, 'ПБ на метро на 20 поездок и 15 дней',                                15,           630,   20,    'M',       '',     10,            'A',       FALSE),
    (15, 'ПБ на метро на 40 поездок и 30 дней',                                30,           1205,  40,    'M',       '',     10,            'A',       FALSE),
    (16, 'Платежная карта',                                                    1000,         0,     0,     '',        '',     10,            'A',       FALSE),
    (17, 'ПБ единый именной льготный на месяц',                                30,           506,   0,     '',        'M',    10,            'L',       TRUE),
    (18, 'Проездной билет инвалида',                                           600,          0,     0,     '',        'MTLB', 10,            'D',       TRUE),
    (19, 'ПБ многоразовый по тарифу до 70 поездок на 90 дней',                 90,           2450,  70,    'M',       '',     0,             'A',       FALSE)
;



INSERT INTO transport
    (id, type, price) VALUES
    (1, 'M', 35),
    (2, 'T', 30),
    (3, 'L', 30),
    (4, 'B', 30)
;

INSERT INTO place
    (id, transport_id) VALUES
    (1, 1),
    (2, 1),
    (3, 1),
    (4, 2),
    (5, 2),
    (7, 3),
    (8, 4),
    (9, 4),
    (10, 4),
    (11, 4);

INSERT INTO cardholder 
    (id, name,      surname, path_photo, category, status) VALUES
    (1,  'Сергей',  'Игушкин', 'res/igushkin.jpg', 'S', TRUE),
    (2,  'Руслан',  'Ахундов', 'res/ahundov.jpg',  'S', TRUE),
    (3,  'Георгий', 'Корнеев', 'res/korneev.jpg',  'A', TRUE),
    (4,  'Павел',   'Скаков',  'res/skakov.jpg',   'A', TRUE),
    (5,  'Антон',   'Ковалев', 'res/kovalev.jpg',  'A', TRUE),
    (6,  'Нина',    'Малева',  'res/maleva.jpg',   'L', TRUE),
    (7,  'Николай', 'Чач',     'res/chach.jpg',    'D', TRUE),
    (8,  'Анна',    'Мосеева', 'res/moseeva.jpg',  'S', FALSE),
    (9,  'Ева',     'Рупенко', 'res/rupenko.jpg',  'S', FALSE)
;

CREATE OR REPLACE FUNCTION buy_card_by_type_with_cardholder(card_type_id INT, cardholder_id INT)
RETURNS BOOLEAN
LANGUAGE plpgsql
AS $function$
    DECLARE
        card_type_ card_type%ROWTYPE;
        cardholder_ cardholder%ROWTYPE;
        new_card_id INTEGER;
    BEGIN
        SELECT *
          INTO card_type_
          FROM card_type ct
         WHERE ct.id = card_type_id;

        IF (NOT card_type_.require_holder)
        THEN
            RETURN FALSE;
        END IF;

        SELECT *
          INTO cardholder_
          FROM cardholder ch
         WHERE ch.id = cardholder_id;

        IF (card_type_.category <> 'A' AND (NOT cardholder_.status OR card_type_.category <> cardholder_.category))
        THEN
            RETURN FALSE;
        END IF;

        INSERT INTO card
           (card_type_id, cardholder_id, balance, trips,            start_date) VALUES
           (card_type_id, cardholder_id, 0,       card_type_.trips, NOW())
           RETURNING id INTO new_card_id;

        INSERT INTO purchase
            (card_id, start_date) VALUES
            (new_card_id, NOW());

        RETURN TRUE;
    END;
$function$;


CREATE OR REPLACE FUNCTION buy_card_by_type(card_type_id INT)
RETURNS BOOLEAN
LANGUAGE plpgsql
AS $function$
    DECLARE
        card_type_ card_type%ROWTYPE;
        new_card_id INTEGER;
    BEGIN
        SELECT *
          INTO card_type_
          FROM card_type ct
         WHERE ct.id = card_type_id;

        IF (card_type_.require_holder)
        THEN
            RETURN FALSE;
        END IF;

        IF (card_type_.category <> 'A')
        THEN
            RETURN FALSE;
        END IF;

        INSERT INTO card
           (card_type_id, balance, trips,            start_date) VALUES
           (card_type_id, 0,       card_type_.trips, NOW())
           RETURNING id INTO new_card_id;

        INSERT INTO purchase
            (card_id, start_date) VALUES
            (new_card_id, NOW());

        RETURN TRUE;
    END;
$function$;

CREATE OR REPLACE FUNCTION update_card(card_id INT)
RETURNS BOOLEAN
LANGUAGE plpgsql
AS $function$
    DECLARE
        card_ card%ROWTYPE;
        card_type_ card_type%ROWTYPE;
        cardholder_ cardholder%ROWTYPE;
    BEGIN
        IF (card_id NOT IN (SELECT id FROM card))
        THEN
            RETURN FALSE;
        END IF;

        SELECT *
          INTO card_
          FROM card c
         WHERE c.id = card_id;

        IF (card_.card_type_id = 16)
        THEN
            RETURN FALSE;
        END IF;

        SELECT *
        INTO card_type_
        FROM card_type ct
        WHERE ct.id = card_.card_type_id;

        IF (card_type_.require_holder)
        THEN
            SELECT *
              INTO cardholder_
              FROM cardholder ch
             WHERE card_.cardholder_id = ch.id;
            IF (card_type_.category <> 'A' AND (NOT cardholder_.status OR card_type_.category <> cardholder_.category))
            THEN
                RETURN FALSE;
            END IF;
        END IF;

        UPDATE card
        SET trips = card_type_.trips, start_date = NOW()
        WHERE id = card_.id;

        INSERT INTO purchase
            (card_id, start_date) VALUES
            (card_id, NOW());

        RETURN TRUE;
    END;
$function$;

CREATE OR REPLACE FUNCTION update_card_with_balance(card_id INT, amount REAL)
RETURNS BOOLEAN
LANGUAGE plpgsql
AS $function$
    DECLARE
        card_ card%ROWTYPE;
        balance_ REAL;
    BEGIN
        IF (card_id NOT IN (SELECT id FROM card))
        THEN
            RETURN FALSE;
        END IF;

        SELECT *
          INTO card_
          FROM card c
         WHERE c.id = card_id;

        IF (card_.card_type_id <> 16)
        THEN
            RETURN FALSE;
        END IF;

        SELECT balance
        INTO balance_
        FROM card
        WHERE card.id = card_id;

        UPDATE card
        SET balance = balance_ + amount, start_date = NOW()
        WHERE id = card_id;

        INSERT INTO purchase
            (card_id, start_date) VALUES
            (card_id, NOW());

        RETURN TRUE;
    END;
$function$;

CREATE OR REPLACE FUNCTION use_card(card_id INT, place_id INT)
RETURNS BOOLEAN
LANGUAGE plpgsql
AS $function$
    DECLARE
        card_ card%ROWTYPE;
        card_type_ card_type%ROWTYPE;
        place_ place%ROWTYPE;
        transport_ transport%ROWTYPE;
    BEGIN
        SELECT *
        INTO card_
        FROM card c
        WHERE c.id = card_id;

        SELECT *
        INTO card_type_
        FROM card_type ct
        WHERE ct.id = card_.card_type_id;

        SELECT *
        INTO place_
        FROM place p
        WHERE p.id = place_id;

        IF (NOW() - ((INTERVAL '1 day') * card_type_.duration_day) > card_.start_date)
        THEN
            INSERT INTO use
                (card_id, place_id, usetime, accepted) VALUES
                (card_id, place_id, NOW(), FALSE);
            RETURN FALSE;
        END IF;

        IF (card_.last_trip_place_id = place_id AND (NOW() - (card_type_.timeout_minute * (INTERVAL '1 minute')) < card_.last_trip_datetime))
        THEN
            INSERT INTO use
                (card_id, place_id, usetime, accepted) VALUES
                (card_id, place_id, NOW(), FALSE);
            RETURN FALSE;
        END IF;

        SELECT *
        INTO transport_
        FROM transport t
        WHERE t.id = place_.transport_id;

        IF (card_type_.id = 16)
        THEN

            IF (card_.balance < transport_.price)
            THEN
                INSERT INTO use
                    (card_id, place_id, usetime, accepted) VALUES
                    (card_id, place_id, NOW(), FALSE);
                RETURN FALSE;
            END IF;

            UPDATE card
            SET balance = card_.balance - transport_.price,
                last_trip_datetime = NOW(),
                last_trip_place_id = place_id
            WHERE id = card_id;

            INSERT INTO use
                (card_id, place_id, usetime, accepted) VALUES
                (card_id, place_id, NOW(), TRUE);
            RETURN TRUE;
        END IF;

        IF (POSITION(transport_.type IN card_type_.unlims) > 0)
        THEN
            UPDATE card
            SET last_trip_datetime = NOW(),
                last_trip_place_id = place_id
            WHERE id = card_id;

            INSERT INTO use
                (card_id, place_id, usetime, accepted) VALUES
                (card_id, place_id, NOW(), TRUE);
            RETURN TRUE;
        END IF;

        IF (POSITION(transport_.type IN card_type_.trips_for) > 0 AND card_.trips > 0)
        THEN
            UPDATE card
            SET last_trip_datetime = NOW(),
                last_trip_place_id = place_id,
                trips = trips - 1
            WHERE id = card_id;

             INSERT INTO use
                (card_id, place_id, usetime, accepted) VALUES
                (card_id, place_id, NOW(), TRUE);
            RETURN TRUE;
        END IF;
        INSERT INTO use
            (card_id, place_id, usetime, accepted) VALUES
            (card_id, place_id, NOW(), FALSE);
        RETURN FALSE;
    END;
$function$;

-- статистика: по карте сколько раз на каком транспорте были поездки в последнем месяце?
CREATE VIEW trips_by_card AS
SELECT t.type, (SELECT count(*)
                 FROM use u
                 WHERE (SELECT p.transport_id FROM place p WHERE p.id = u.place_id) = t.id
                        AND u.card_id = 6
                        AND u.accepted = TRUE
                        AND NOW() - INTERVAL '1 month' < u.usetime) AS trips
  FROM transport t;

-- статистика: по ТИПУ карты сколько раз в среднем на каком транспорте были поездки в последнем месяце?
CREATE VIEW avg_trips_by_card_type AS
SELECT t.type, ((SELECT count(*)
                 FROM use u
                 WHERE (SELECT p.transport_id FROM place p WHERE p.id = u.place_id) = t.id
                        AND (SELECT c.card_type_id FROM card c WHERE c.id = u.card_id) = 16
                        AND u.accepted = TRUE
                        AND NOW() - INTERVAL '1 month' < u.usetime)
                        / (SELECT count(*) FROM card c WHERE c.card_type_id = 16)) AS trips
  FROM transport t;

CREATE INDEX card_by_id ON card
(id);

CREATE INDEX cardholder_by_id ON cardholder
(id);

CREATE INDEX transport_by_id ON transport
(id);

CREATE INDEX card_type_by_id ON card_type
(id);

CREATE INDEX place_by_id ON place
(id);

CREATE INDEX use_index ON use
(card_id, accepted);

CREATE INDEX card_by_card_type ON card
(card_type_id);

CREATE OR REPLACE FUNCTION increase_trips()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $function$
    DECLARE
        dif INTEGER;
    BEGIN
        dif := NEW.trips - OLD.trips;
        IF (dif < 0)
        THEN
            RETURN NEW;
        END IF;

        UPDATE card
        SET trips = trips + dif
        WHERE NEW.id = card.card_type_id;

        RETURN NEW;
    END;
$function$;


-- искусственный пример: если количество поездок по типу карты увеличилось, то всем прибавим разницу.
CREATE TRIGGER increase_trips_in_card_type
  BEFORE UPDATE
  ON card_type
  FOR EACH ROW EXECUTE PROCEDURE increase_trips();

CREATE OR REPLACE FUNCTION change_tlb_price()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $function$
    BEGIN
        IF (OLD.type = 'M' OR NEW.price - OLD.price = 0)
        THEN
            RETURN NEW;
        END IF;


        UPDATE transport
        SET price = NEW.price
        WHERE type = 'B' OR type = 'T' OR type = 'L';

        RETURN NEW;
    END;
$function$;

-- искусственный пример: если стоимость проезда на один вид наземного изменилась, то изменится на весь наземный транспорт
CREATE TRIGGER change_price_one_of_tlb
  AFTER UPDATE
  ON transport
  FOR EACH ROW EXECUTE PROCEDURE change_tlb_price();






