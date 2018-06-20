--统计20171001至20171007期间累计访问pv大于100的男性用户数
select count(a.msisdn) from 
(select msisdn
from pagevisit
where record_day>='20171001' and record_day<='20171007'
and pv>100) a join
(select msisdn
 from user_info
 where sex='男')b
 on a.msisdn=b.msisdn
 
--统计20171001至20171007期间至少连续3天有访问的用户清单
select distinct msisdn from(
select a.msisdn,rn,count(*)days from
(select record_day,msisdn,to_number(record_day)-row_number()over(partition  by msisdn order by record_day)rn
from pagevisit
where record_day>='20171001' and record_day<='20171007')a
group by a.msisdn,rn)
where days>=3


--统计每个部门中薪酬排名top3的用户列表,输出以下信息：部门名称|员工姓名|薪酬
select departmentid,name,salary from(
select a.departmentid,name,salary,
 row_number()over(partition  by a.departmentid order by salary desc)rn from(
(select name,salary,departmentid
 from employee)a join
(select departmentid,dept_name
 from department)b
 on a.departmentid=b.departmentid))c
 where rn<=3
 
--写一段 SQL 统计2013-10-01日至2013-10-03日期间，每天非禁止用户的取消率
select request_at ,round(count(case when status like 'cancel%' then status end)*1.00/count(*),2) 
from trips a
join (select user_id from users where upper(banned) = 'NO') b
on a.cliend_id = b.user_id
join (select user_id from users where upper(banned) = 'NO') c
on a.driver_id = c.user_id
where a.Request_at between '2013-10-01' and '2013-10-03'
group by request_at;


