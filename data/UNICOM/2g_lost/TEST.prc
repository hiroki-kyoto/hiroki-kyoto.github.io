drop table exec_log;
delete from DYL_2G_LOST_FLAG where 1=1;
delete from dyl_2g_lost_flag_weal where 1=1;
delete from dyl_2g_lost_flag_end where 1=1;
delete from dyl_2g_lost_flag_end2 where 1=1;

create table exec_log (
	code varchar2(50),
	info varchar2(50)
);

declare
	retcode VARCHAR2(100);
	retinfo VARCHAR2(100);
begin
	P_DYL_2G_LOST_FLAG('201508', '79', retcode, retinfo);
	INSERT INTO exec_log VALUES (retcode, retinfo);
	P_DYL_2G_LOST_FLAG_WEAL('201508', '079', retcode, retinfo);
	INSERT INTO exec_log VALUES (retcode, retinfo);
	P_DYL_2G_LOST_FLAG_END('201508', '079', retcode, retinfo);
	INSERT INTO exec_log VALUES (retcode, retinfo);
	P_DYL_2G_LOST_FLAG_END2('201508', retcode, retinfo);
	INSERT INTO exec_log VALUES (retcode, retinfo);
end;
/
exit
