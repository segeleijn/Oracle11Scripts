-- top 20 sql_is query with reads and writes:

select * from (
  select hss.sql_id,
count(unique(plan_hash_value)) diff_plans,
 -- decode(count(unique(plan_hash_value)), 1 , 1, count(unique(plan_hash_value))) diff_plans,
 count(unique(force_matching_signature)) fms,
 -- decode(count(unique(force_matching_signature)), 1, max(force_matching_signature),count(unique(force_matching_signature))) fms_2,
 sum(hss.executions_delta) executions,
 round(sum(hss.elapsed_time_delta)/1000000,3) elapsed_time_s,
 round(sum(hss.cpu_time_delta)/1000000,3) cpu_time_s,
 round(sum(hss.iowait_delta)/1000000,3) iowait_s,
 -- round(sum(hss.clwait_delta)/1000000,3) clwait_s,
 -- round(sum(hss.apwait_delta)/1000000,3) apwait_s,
 -- round(sum(hss.ccwait_delta)/1000000,3) ccwait_s,
 -- round(sum(hss.rows_processed_delta),3) rows_processed,
 round(sum(hss.buffer_gets_delta),3) buffer_gets,
 round(sum(hss.disk_reads_delta),3) disk_reads,
 round(sum(hss.direct_writes_delta),3) direct_writes
 from dba_hist_sqlstat hss, dba_hist_snapshot hs 
 where hss.snap_id=hs.snap_id
  -- and hss.sql_id = '0643yhacr145x'
  -- and hs.begin_interval_time>=trunc(sysdate)-7+1
  -- and hs.begin_interval_time<=trunc(sysdate)-7+1+(24/24)
  group by sql_id
  order by 2 desc nulls last)
where rownum<=20; 
