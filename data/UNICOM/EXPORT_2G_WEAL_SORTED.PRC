CREATE OR REPLACE DIRECTORY EXP_DIR AS '/home/wulinzhi/Downloads/UNICOM/EXP_DIR';

DECLARE
	VSFILE UTL_FILE.FILE_TYPE;
	V_CNT NUMBER;
	U_ID VARCHAR2(40);
BEGIN
	DBMS_OUTPUT.ENABLE(10000);
	VSFILE := UTL_FILE.FOPEN('EXP_DIR', '_2G_WEAL_SORTED.CSV', 'W');
	UTL_FILE.PUT_LINE(VSFILE,
'MONTH_ID,PROV_ID,AREA_ID,USER_ID,SERVICE_TYPE,PAY_MODE,PRODUCT_ID,PRODUCT_MODE,CHNL_ID,USER_STATUS,CUST_ID,IS_GRP_MBR,IS_INNET,IS_THIS_ACCT,IS_FREE,STOP_MONTH,LAST_STOP_DATE,INNET_MONTHS,FLUXMOST1MON_IMEI,USE_TERM_TYPE,IS_TERM_IPHONE,IS_USE_SMART,USER_3WU,IS_ACTIVE,IS_LOWER_VALUE_USER,USE_STATUS_INNET,TOTAL_FLUX,LOCAL_FLUX,LOCAL_FLUX_ZB,JF_TIMES,NOROAM_LOCAL_JF_TIMES,NOROAM_LONG_JF_TIMES,ROAM_ZB,ZHUJIAO_ZB,CDR_NUM,TOLL_NUMS_ZB,VIP_LEVEL,ACCT_FEE,ROAM_VOICE_FEE,ZENGZHI_FEE,OWE_FEE,OVERDUE_OWE_FEE,P2P_SMS_CNT,FLUX_NUM,FLUX_TIME,YQ_OWE_MONTHS,STDEV_CDR_NUM,VAR_CDR_NUM,CALL_DAYS,LAST_CALL_TIME,CALL_DURA_LAST7_CN,OTHER_MOBILE_RING,CELLID_NUM,CALLING_YIWANG,NET_TYPE,MANU_NAME,LOST_FLAG');
	V_CNT := 0;
	U_ID := '0';
	FOR R IN (SELECT * FROM DYL_2G_LOST_FLAG_WEAL ORDER BY USER_ID)
	LOOP
		IF U_ID<>R.USER_ID THEN
			U_ID := R.USER_ID;
			UTL_FILE.PUT_LINE( VSFILE, 
				R.MONTH_ID				|| ',' ||
				R.PROV_ID				|| ',' ||
				R.AREA_ID				|| ',' ||
				R.USER_ID				|| ',' ||
				R.SERVICE_TYPE				|| ',' ||
				R.PAY_MODE				|| ',' ||
				R.PRODUCT_ID				|| ',' ||
				R.PRODUCT_MODE				|| ',' ||
				R.CHNL_ID				|| ',' ||
				R.USER_STATUS				|| ',' ||
				R.CUST_ID				|| ',' ||
				R.IS_GRP_MBR				|| ',' ||
				R.IS_INNET				|| ',' ||
				R.IS_THIS_ACCT				|| ',' ||
				R.IS_FREE				|| ',' ||
				R.STOP_MONTH				|| ',' ||
				R.LAST_STOP_DATE			|| ',' ||
				R.INNET_MONTHS				|| ',' ||
				R.FLUXMOST1MON_IMEI			|| ',' ||
				R.USE_TERM_TYPE				|| ',' ||
				R.IS_TERM_IPHONE			|| ',' ||
				R.IS_USE_SMART				|| ',' ||
				R.USER_3WU				|| ',' ||
				R.IS_ACTIVE				|| ',' ||
				R.IS_LOWER_VALUE_USER			|| ',' ||
				R.USE_STATUS_INNET			|| ',' ||
				R.TOTAL_FLUX				|| ',' ||
				R.LOCAL_FLUX				|| ',' ||
				R.LOCAL_FLUX_ZB				|| ',' ||
				R.JF_TIMES				|| ',' ||
				R.NOROAM_LOCAL_JF_TIMES			|| ',' ||
				R.NOROAM_LONG_JF_TIMES			|| ',' ||
				R.ROAM_ZB				|| ',' ||
				R.ZHUJIAO_ZB				|| ',' ||
				R.CDR_NUM				|| ',' ||
				R.TOLL_NUMS_ZB				|| ',' ||
				R.VIP_LEVEL				|| ',' ||
				R.ACCT_FEE				|| ',' ||
				R.ROAM_VOICE_FEE			|| ',' ||
				R.ZENGZHI_FEE				|| ',' ||
				R.OWE_FEE				|| ',' ||
				R.OVERDUE_OWE_FEE			|| ',' ||
				R.P2P_SMS_CNT				|| ',' ||
				R.FLUX_NUM				|| ',' ||
				R.FLUX_TIME				|| ',' ||
				R.YQ_OWE_MONTHS				|| ',' ||
				R.STDEV_CDR_NUM				|| ',' ||
				R.VAR_CDR_NUM				|| ',' ||
				R.CALL_DAYS				|| ',' ||
				R.LAST_CALL_TIME			|| ',' ||
				R.CALL_DURA_LAST7_CN			|| ',' ||
				R.OTHER_MOBILE_RING			|| ',' ||
				R.CELLID_NUM				|| ',' ||
				R.CALLING_YIWANG			|| ',' ||
				R.NET_TYPE				|| ',' ||
				R.MANU_NAME				|| ',' ||
				R.LOST_FLAG
			);
			V_CNT := V_CNT + 1;
		END IF;
	END LOOP;
	DBMS_OUTPUT.PUT_LINE('ROWS EXPORTED: ' || V_CNT);
	UTL_FILE.FFLUSH(VSFILE);
	UTL_FILE.FCLOSE(VSFILE);
END;
/
EXIT
