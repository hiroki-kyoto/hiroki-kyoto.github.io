drop table exec_log;
create table exec_log (
	code varchar2(50),
	info varchar2(50)
);

declare
	retcode VARCHAR2(100);
	retinfo VARCHAR2(100);
begin
	P_DWA_V_M_3G_LOST_STEP1('201512', '079', retcode, retinfo);
	INSERT INTO exec_log VALUES (retcode, retinfo);
end;
/