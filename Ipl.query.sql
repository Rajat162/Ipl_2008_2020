/* TASK 1 */

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

/* TASK 2 */

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

/* TASK 3 */

copy deliveries from 'C:\Program Files\PostgreSQL\15\data\data copy\IPL_BALL.csv' csv header;

copy matches from 'C:\Program Files\PostgreSQL\15\data\data copy\IPL_Matches.csv' csv header;

/* TASK 4 */

select * from deliveries limit 20;

/* TASK 5 */

select* from matches limit 20;

/* TASK 6 */

select* from matches;
select *from matches where date ='2013-05-02';

/* TASK 7 */

select* from matches;

select * from matches 
where result = 'runs' 
and
result_margin> 100;

/* TASK 8 */

select* from matches;

select * from matches 
where date = '18-10-2020'
order by date
desc;

/* TASK 9 */

select * from matches;

select count(distinct city) from matches;

/* TASK 10 */

create table deliveries_v02 as select *,
case when total_runs >= 4 then 'boundary'
when total_runs = 0 then 'dot'
else 'others'
end as ball_result
from deliveries;
	 
select sum(boundary) as total_boundary from deliveries_v02

/* TASK 11 */	 

select*from deliveries_v02;

select ball_result, count(*) as total_result from deliveries_v02 group by ball_result;

/* TASK 12 */	 

select batting_team,count(*) from deliveries_v02
where ball_result = 'boundary'
group by batting_team
order by count
desc;

/* TASK 13 */

select batting_team,count(*) from deliveries_v02
where ball_result = 'boundary'
group by batting_team
order by count
asc;

/* TASK 14 */	 

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

/* TASK 15 */	 


select*from deliveries;

select dismissal_kind, count(*) as total_dismissal from deliveries
where dismissal_kind <> 'NA'
group by dismissal_kind
order by total_dismissal
desc;

/* TASK 16 */	 

select bowler, sum(extra_runs) as total_extras_runs from deliveries 
group by bowler
order by total_extras_runs
desc 
limit 5;

/* TASK 17 */

create table deliveries_v03 as select a.*,
b.venue,
b.match_date
from deliveries_v02 as a
left join (select max(venue) as venue, max(date) as match_date,
		   match_id
		  from matches group by match_id)as b
		  on a.match_id = b.match_id;
		  

/* TASK 18 */

select* from deliveries_v03

select venue, sum(total_runs) as runs from deliveries_v03
group by venue 
order by runs
desc;


/* TASK 19 */

select* from matches;
 
select extract(year from match_date) as ipl_year,
sum(total_runs) as runs from deliveries_v03
where venue ='Eden Gardens'
group by ipl_year
order by runs
desc;

/* TASK 20 */

select distinct team1 from matches;

create table matches_correct as select*,
replace(team1,'Rising Pune Supergiants','Rising Pune Supergiants') 
as team1_correction,
replace(team2,'Rising Pune Supergiants','Rising Pune Supergiants')
from matches;


/* TASK 21 */

create table deliveries_v04
as select concat (match_id,'-',inning,'-',over,'-',ball) as ball_id,*
from deliveries_v03
	
select *from deliveries_v04

/* TASK 22 */

select *from deliveries_v04

select count(distinct ball_id) as count_ball_id from deliveries_v04

/* TASK 24 */

create table deliveries_v05 as select*,
row_number()
over(partition by ball_id)
as  r_num
from deliveries_v04

select * from deliveries_v05

/* TASK 25 */

select count(*) from deliveries_v05
 
select* from deliveries_v05 where r_num=2

/* TASK 26 */

select* from deliveries_v05 
where ball_id in (select ball_id from deliveries_v05 where r_num=2);
