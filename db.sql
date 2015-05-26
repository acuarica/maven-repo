--select count(*) from arts where inrepo and ext='pom';
--select count(*) from arts where not inrepo;
--select count(*) from arts;
--select * from arts order by gid limit 1000 
--
--select count(*) from (select gid, aid from arts group by gid, aid ) t

--create index arts_gidaid on arts (gid, aid);

--select gid, aid, count(*) from arts group by gid, aid having count(*) >= 5 limit 100
--select count(*) from deps

--select * from deps limit 1000

--select * from arts where gid = 'de.berlios.jsunit' and aid='jsunit' and version='1.3'
--create index arts_ga on arts (gid, aid)
--drop index arts_ga
--create index deps_ga on deps (gid, aid)

--select * from deps where gid = 'de.berlios.jsunit'

--select * from arts where gid='de.berlios.jsunit' and aid='jsunit'
--select * from deps where gid='de.berlios.jsunit' and aid='jsunit'
--select * from deps where gid='jmock' and aid='jmock'
--select * from deps where gid='cglib' and aid='cglib-nodep'

/*
WITH RECURSIVE d(gid, aid, depth, path, cycle) AS (
    values ('de.berlios.jsunit', 'jsunit', 0, array['de.berlios.jsunit' || 'jsunit'], false)
  UNION
	select deps.dgid, deps.daid, d.depth + 1, 
		d.path || (deps.dgid || deps.daid),
		(deps.dgid || deps.daid) = any(path)
	from deps, d 
	where deps.gid=d.gid and deps.aid=d.aid and not cycle
)
SELECT * FROM d;
*/

/*
CREATE FUNCTION getdeps(text, text) RETURNS TABLE(gid text, aid text, depth int, path text[], cycle boolean) as $$
WITH RECURSIVE d(gid, aid, depth, path, cycle) AS (
    values ($1, $2, 0, array[ $1 || $2 ], false)
  UNION
	select deps.dgid, deps.daid, d.depth + 1, 
		d.path || (deps.dgid || deps.daid),
		(deps.dgid || deps.daid) = any(path)
	from deps, d 
	where deps.gid=d.gid and deps.aid=d.aid and not cycle and depth < 8
)
SELECT * FROM d $$
LANGUAGE SQL;
*/

--select * from getdeps('junit', 'junit')
--select * from getdeps('io.netty', 'netty')

/*
WITH RECURSIVE d(gid, aid) AS (
    values ('junit', 'junit')
  UNION
	select deps.dgid, deps.daid
	from deps, d 
	where deps.gid=d.gid and deps.aid=d.aid
)
SELECT * FROM d
*/

/*
WITH RECURSIVE d(gid, aid) AS (
    values ('io.netty', 'netty')
  UNION
	select deps.dgid, deps.daid
	from deps, d 
	where deps.gid=d.gid and deps.aid=d.aid
)
SELECT * FROM d
*/
--create table artsid (id serial, gid varchar(255), aid varchar(255));

--insert into artsid (gid, aid) select gid, aid from arts group by gid, aid 
--select * from artsid order by id limit 1000
--create index on artsid (gid, aid)
--select * from artsid where gid='io.netty' and aid='netty'

--drop table depsid
create table depsid (
	_id serial primary key, 
	id integer, 
	gid varchar(255), 
	aid varchar(255), 
	ver varchar(255), 
	did integer, 
	dver varchar(255), 
	dscope varchar(255)
);

--select count(*) from deps --5155459

insert into depsid (id, ver, did, dver, dscope)
select a.id, d.ver, b.id, d.dver, d.dscope from deps d
left join artsid a on a.gid = d.gid and a.aid = d.aid 
left join artsid b on b.gid = d.dgid and b.aid = d.daid
-- 5155459

--create index on depsid (id)
select * from artsid where gid='io.netty' and aid='netty'
select * from depsid where id = 33395
