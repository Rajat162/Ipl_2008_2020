create table deliveries(
match_id int, 
inning int,
over int,
ball int, 
batsman varchar, 
non_striker varchar, 
bowler varchar, 
batsman_runs int,
extra_runs int,
total_runs int,
is_wicket int,
dismissal_kind varchar,
player_dismissed varchar,
fielder varchar,
extras_type varchar,
batting_team varchar,
bowling_team varchar
);

create table matches(
match_id int,
city varchar,
date date,
player_of_match varchar,
venue varchar,
neutral_venue varchar,
team1 varchar,
team2 varchar,
toss_winner varchar,
toss_decision varchar,
winner varchar,
result varchar,
result_margin int,
eliminator varchar,
method_dl varchar,
umpire1 varchar,
umpire2 varchar
);

copy deliveries from 'C:\Program Files\PostgreSQL\15\data\data copy\IPL_BALL.csv' csv header;

copy matches from 'C:\Program Files\PostgreSQL\15\data\data copy\IPL_Matches.csv' csv header;


/* TASK 1 */
----Select the top 20 rows of the deliveries table after ordering them by id, inning, over, ball in ascending order.

select * from deliveries limit 20;

/* TASK 2 */
----Select the top 20 rows of the matches table.

select* from matches limit 20;


/* TASK 3 */
----Fetch data of all the matches played on 2nd May 2013 from the matches table..

select* from matches;
select *from matches where date ='2013-05-02';


/* TASK 4 */
----Fetch data of all the matches where the result mode is ‘runs’ and margin of victory is more than 100 runs.

select* from matches;

select * from matches 
where result = 'runs' 
and
result_margin> 100;


/* TASK 5 */
----Fetch data of all the matches where the final scores of both teams tied and order it in descending order of the date.

select* from matches;

select * from matches 
where date = '18-10-2020'
order by date
desc;


/* TASK 6 */
----Get the count of cities that have hosted an IPL match.

select * from matches;

select count(distinct city) from matches;



/* TASK 7 */
----Create table deliveries_v02 with all the columns of the table ‘deliveries’ 
----and an additional column ball_result containing values boundary, dot or other 
----depending on the total_run (boundary for >= 4, dot for 0 and other for any other number)
----(Hint 1 : CASE WHEN statement is used to get condition based results)
----(Hint 2: To convert the output data of select statement into a table, you can use a subquery. 
----Create table table_name as [entire select statement].

create table deliveries_v02 as select *,
case when total_runs >= 4 then 'boundary'
when total_runs = 0 then 'dot'
else 'others'
end as ball_result
from deliveries;
	 

select sum(boundary) as total_boundary from deliveries_v02
/* TASK 8*/	 
---- Write a query to fetch the total number of boundaries and dot balls from the deliveries_v02 table.

select*from deliveries_v02;

select ball_result, count(*) as total_result from deliveries_v02 group by ball_result;

/* TASK 9*/	 
---- Write a query to fetch the total number of boundaries scored by each team from the deliveries_v02 
---- table and order it in descending order of the number of boundaries scored.


select batting_team,count(*) from deliveries_v02
where ball_result = 'boundary'
group by batting_team
order by count
desc;



select batting_team,count(*) from deliveries_v02
where ball_result = 'boundary'
group by batting_team
order by count
asc;

/* TASK 10*/	 
---- Write a query to fetch the total number of dot balls bowled by each team and order it in descending 
---- order of the total number of dot balls bowled.

select bowling_team,count(*) from deliveries_v02
where ball_result = 'dot'
group by bowling_team 
order by count
desc;


select bowling_team,count(*) from deliveries_v02
where ball_result = 'dot'
group by bowling_team 
order by count
asc;

/* TASK 11 */	 
---- Write a query to fetch the total number of dismissals by dismissal kinds where dismissal kind is not NA.

select*from deliveries;

select dismissal_kind, count(*) as total_dismissal from deliveries
where dismissal_kind <> 'NA'
group by dismissal_kind
order by total_dismissal
desc;


/* TASK 12 */	 
----Write a query to get the top 5 bowlers who conceded maximum extra runs from the deliveries table

select bowler, sum(extra_runs) as total_extras_runs from deliveries 
group by bowler
order by total_extras_runs
desc 
limit 5;

/* TASK 13 */
----Write a query to create a table named deliveries_v03 with all the columns of deliveries_v02
----table and two additional column (named venue and match_date) of venue and date from table matches.

create table deliveries_v03 as select a.*,
b.venue,
b.match_date
from deliveries_v02 as a
left join (select max(venue) as venue, max(date) as match_date,
		   match_id
		  from matches group by match_id)as b
		  on a.match_id = b.match_id;
		  

/* TASK 14 */
----Write a query to fetch the total runs scored for each venue and order it in the descending order of total runs scored.
select* from deliveries_v03

select venue, sum(total_runs) as runs from deliveries_v03
group by venue 
order by runs
desc;


/* TASK 15 */
----Write a query to fetch the year-wise total runs scored at Eden Gardens and order it in the descending order of total runs scored.


 select* from matches;
 
select extract(year from match_date) as ipl_year,
sum(total_runs) as runs from deliveries_v03
where venue ='Eden Gardens'
group by ipl_year
order by runs
desc;


/* TASK 16 */
----Get unique team1 names from the matches table, you will notice that there are two entries for
----Rising Pune Supergiant one with Rising Pune Supergiant and another one with Rising Pune Supergiants.  
----Your task is to create a matches_corrected table with two additional columns team1_corr and team2_corr containing 
----team names with replacing Rising Pune Supergiants with Rising Pune Supergiant. Now analyse these newly created columns.

select distinct team1 from matches;

create table matches_correct as select*,
replace(team1,'Rising Pune Supergiants','Rising Pune Supergiants') 
as team1_correction,
replace(team2,'Rising Pune Supergiants','Rising Pune Supergiants')
from matches;


/* TASK 17 */
----Create a new table deliveries_v04 with the first column as ball_id containing information of 
----match_id, inning, over and ball separated by ‘-’ (For ex. 335982-1-0-1 match_id-inning-over-ball) 
----and rest of the columns same as deliveries_v03)


create table deliveries_v04
as select concat (match_id,'-',inning,'-',over,'-',ball) as ball_id,*
from deliveries_v03
	
select *from deliveries_v04


----Compare the total count of rows and total count of distinct ball_id in deliveries_v04;

	
select *from deliveries_v04

select count(distinct ball_id) as count_ball_id from deliveries_v04



create table deliveries_v05 as select*,
row_number()
over(partition by ball_id)
as  r_num
from deliveries_v04


select * from deliveries_v05




----Use the r_num created in deliveries_v05 to identify instances where ball_id is repeating.

select count(*) from deliveries_v05
 
select* from deliveries_v05 where r_num=2


----Use subqueries to fetch data of all the ball_id which are repeating.
select* from deliveries_v05 
where ball_id in (select ball_id from deliveries_v05 where r_num=2);