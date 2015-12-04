S     C     M
s_id  c_id  s_id
s_n   c_n   c_id
      c_y   mark
            def

  s_id     hash
С c_id     hash       - не обязательно упорядоченные 
  (s_id, c_id, mark)  - упорядоченные 
  (s_n, s_id)         - упорядоченные
  (c_n, c_id, c_y)    - упорядоченные
M (c_id)      hash    - не обязательно упорядоченные

Отчислить студентов, у который больше 3 долгов 
CREATE PROCEDURE f (in k, int) as 
BEGIN
    CREATE CURSOR c AS 
    (SELECT s_id FROM marks 
        WHERE mark < 60 group by s_id having count(*)>k)
    OPEN c 
    DECLARE EXIT handler FOR NOT FOUND CLOSE c;  
END 
