merge into Points using (select * from Students) on (strudents.sid = points.sid) and (points.cid = DB.cid)
when matched then
update Points set points = least(100, points + 10) 
when not matched then
insert values (sid, dbcid, 10)