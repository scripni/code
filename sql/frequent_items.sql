--------------------------------------
-- clean up
--------------------------------------
if object_id('acquisitions', 'u') is not null
begin
	drop table acquisitions;
end

--------------------------------------
-- assuming a transactional database containing purchases,
-- select products which are frequently bought together
-- ghetto solution, in case the cpu blows up
-- use Apriori or something to optimize the solution
--------------------------------------

--------------------------------------
-- test data
--------------------------------------
--  [
--    {1, [A, C, D]}, 
--    {2, [B, C, E]}, 
--    {3, [A, B, C, E]}, 
--    {4, [B, E]}
--  ]

create table acquisitions
(
  usr int,
  product nvarchar(1)
);
 
insert into acquisitions values (1, 'A');
insert into acquisitions values (1, 'C');
insert into acquisitions values (1, 'D');

insert into acquisitions values (2, 'B');
insert into acquisitions values (2, 'C');
insert into acquisitions values (2, 'E');

insert into acquisitions values (3, 'A');
insert into acquisitions values (3, 'B');
insert into acquisitions values (3, 'C');
insert into acquisitions values (3, 'E');

insert into acquisitions values (4, 'B');
insert into acquisitions values (4, 'E');

--------------------------------------
-- select all 2-item combinations
--------------------------------------
--  p1  p2	p3	bought_together_count
--  B   C	  E	  2
--  A	  B	  C	  1
--  A	  B	  E	  1
--  A	  C	  D	  1
--  A	  C   E   1
--------------------------------------

select
  p.product as p1,
  q.product as p2,
  r.product as p3,
  count(1) as bought_together_count
from
  acquisitions p,
  acquisitions q,
  acquisitions r
where
  p.usr = q.usr and
  p.usr = r.usr and 
  p.product < q.product and 
  q.product < r.product
group by
  p.product,
  q.product,
  r.product
order by
  bought_together_count desc,
  p1,
  p2,
  p3;
