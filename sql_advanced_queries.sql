-- Leonardo Olmos Saucedo / SQL Advanced Queries Lab

-- 1. List each pair of actors that have worked together.
with CTE_ACTOR as (
	select A.ACTOR_ID, CONCAT(A.FIRST_NAME, ' ', A.LAST_NAME) as ACTOR_NAME, FA.FILM_ID
	from FILM_ACTOR FA 
	join ACTOR A 
	on FA.ACTOR_ID = A.ACTOR_ID 
)
select distinct CTE.ACTOR_ID as FIRST_ACTOR_ID, CTE.ACTOR_NAME, A.ACTOR_ID as SECOND_ACTOR_ID,  CONCAT(A.FIRST_NAME, ' ', A.LAST_NAME) as SECOND_ACTOR_NAME
from CTE_ACTOR CTE 
join FILM_ACTOR FA 
on CTE.FILM_ID = FA.FILM_ID 
join ACTOR A 
on FA.ACTOR_ID = A.ACTOR_ID 
where A.ACTOR_ID <> CTE.ACTOR_ID
order by 1, 3;

-- 2. For each film, list actor that has acted in more films.
create or replace view FILMS_BY_ACTOR as 
	select A.ACTOR_ID, COUNT(FA.FILM_ID) as TOTAL_FILMS
	from ACTOR A
	join FILM_ACTOR FA
	on A.ACTOR_ID = FA.ACTOR_ID 
	join FILM F 
	on FA.FILM_ID = F.FILM_ID 
	group by A.ACTOR_ID;
with CTE_FILM_ACTOR_TOTAL_FILMS as(
	select F.FILM_ID, FBA.ACTOR_ID, FBA.TOTAL_FILMS, RANK() over (partition by F.FILM_ID order by FBA.TOTAL_FILMS DESC) as `RANK`
	from FILMS_BY_ACTOR FBA 
	join ACTOR A 
	on FBA.ACTOR_ID = A.ACTOR_ID 
	join FILM_ACTOR FA 
	on FA.ACTOR_ID = A.ACTOR_ID 
	join FILM F
	on F.FILM_ID = FA.FILM_ID)
select F.FILM_ID, F.TITLE, A.ACTOR_ID, CONCAT(A.FIRST_NAME, ' ', A.LAST_NAME) as ACTOR_NAME
from CTE_FILM_ACTOR_TOTAL_FILMS CTE 
join FILM F 
on F.FILM_ID = CTE.FILM_ID
join ACTOR A 
on A.ACTOR_ID = CTE.ACTOR_ID
where CTE.`RANK`= 1;