CREATE OR REPLACE PROCEDURE P_DWA_V_M_3G_LOST_FLAG(V_MONTH   IN VARCHAR2,
                                                     V_PROV    IN VARCHAR2,
                                                     V_RETCODE OUT VARCHAR2,
                                                     V_RETINFO OUT VARCHAR2) IS
  /*@
  ****************************************************************
  *���� --%@NAME:  P_DWA_V_M_3G_LOST_FLAG
  *�������� --%@COMMENT:3G�ȶ����Ż�ģ���û��ȶ��ȵ÷ּ�������
  *ִ������ --%@PERIOD:��
  *���� --%@PARAM:V_DATE ����,��ʽYYYYMM
  *���� --%@PARAM:V_RETCODE  �������н����ɹ�����־
  *���� --%@PARAM:V_RETINFO  �������н����ɹ��������
  *������ --%@CREATOR:  �����
  *����ʱ�� --%@CREATED_TIME:2015-05-25
  *��ע --%@REMARK:
  *�޸ļ�¼ --%@MODIFY:
  *��Դ�� --%@FROM:
  *Ŀ��� --%@TO:
  *�޸ļ�¼ --%@MODIFY:
  ******************************************************************
  @*/

  V_PKG      VARCHAR2(30);
  V_TAB      VARCHAR2(300);
  V_PROCNAME VARCHAR2(300);
  V_ROWLINE  NUMBER;
  V_COUNT    NUMBER;
  V_SQL      LONG;
  V_LOG_SN   NUMBER;
BEGIN
  V_PKG      := 'LOSTEST'; -- ����
  V_TAB      := 'DWA_V_M_3G_LOST_FLAG';
  V_PROCNAME := 'P_DWA_V_M_3G_LOST_FLAG'; -- ��������
  SELECT ZB_CSM.SEQ_DWD_SQLPARSER.NEXTVAL
    INTO V_LOG_SN --������־���
    FROM DUAL;
  --��־����
  P_INSERT_SQLPARSER_LOG_GENERAL(V_LOG_SN,
                                 V_MONTH,
                                 V_PROV,
                                 'ZB_CSM',
                                 V_PROCNAME,
                                 'V_DATE='||V_MONTH||';V_PROV='||
                                 V_PROV,
                                 SYSDATE,
                                 V_TAB);
  P_INSERT_LOG(V_MONTH, V_PKG, V_PROCNAME, V_PROV, SYSDATE, V_TAB);

  --�����ж�
   SELECT COUNT(1) INTO V_COUNT FROM MID_V_M_3G_LOST_STEP2
    WHERE MONTH_ID = V_MONTH
    AND PROV_ID = V_PROV
    AND ROWNUM < 11;

IF V_COUNT = 10 THEN

  V_SQL := 'ALTER TABLE ZB_CSM.MID_V_M_3G_LOST_FLAG TRUNCATE SUBPARTITION PART'||V_MONTH||'_SUBPART'||V_PROV;
  execute immediate v_sql;


  V_SQL := 'ALTER TABLE ZB_CSM.DWA_V_M_3G_LOST_FLAG TRUNCATE SUBPARTITION PART'||V_MONTH||'_SUBPART'||V_PROV;
  execute immediate v_sql;

----��Լ
INSERT INTO MID_V_M_3G_LOST_FLAG
SELECT MONTH_ID,
       PROV_ID,
       AREA_ID,
       CUST_ID,
       SUBS_INSTANCE_ID,
       DEVICE_NUMBER,
       SERVICE_TYPE,
       IS_CARD,
       IS_FREE,
       IS_TEST,
       IS_AGREE,
       IS_INNET,
       IS_SANWU,
       IS_LOWER_VALUE_USER,
       USER_STATUS,
   100-ROUND(1/(1+EXP(-(
   -0.6522 * INNET_MONTH +
   -0.01718 * CALL_RATIO +
   0.01336 * STREAM_RATIO +
   -0.1366 * ACCT_FEE +
   0.1392 * JF_TIMES +
   -0.02815 * TOTAL_FLUX +
   -0.0554 * LAST_STOP_DATE +
   0.005061 * ACCT_CN +
   0.007125 * FLUX_CN +
   -0.004298 * TIMES_CN +
   0.3214 * CALL_CN7 +
   0.03122 * YIWANG_CNT +
   -0.04977 * CALL_DAYS +
   0.01324 * VALID_CALL_RING +
   -0.2154 * CELLID_NUM +
   0.05962 * LAST_JF_MONTH +
   -0.08722 * JF_MON +
   1.616 * DEV_NUM_SHANG +
   0.08734 * (CASE WHEN PAY_MODE_2=0 THEN 1 ELSE 0 END) +
   1.676 * (CASE WHEN PRODUCT_TYPE=1 THEN 1 ELSE 0 END) +
   1.705 * (CASE WHEN PRODUCT_TYPE=2 THEN 1 ELSE 0 END) +
   -0.4196 * (CASE WHEN CHANNEL_TYPE=1 THEN 1 ELSE 0 END) +
   0.119 * (CASE WHEN TERM_TYPE=1 THEN 1 ELSE 0 END) +
   0.0947 * (CASE WHEN USE_STATUS_INNET=1 THEN 1 ELSE 0 END) +
   0.09312 * (CASE WHEN USE_STATUS_INNET=2 THEN 1 ELSE 0 END) +
   -0.5656 * (CASE WHEN LAST_IS_ACCT=0 THEN 1 ELSE 0 END) +
   0.4706 * (CASE WHEN MEMBER_LVL=1 THEN 1 ELSE 0 END) +
   0.05626 * (CASE WHEN P2P_SMS_CNT=0 THEN 1 ELSE 0 END) +
   0.05654 * (CASE WHEN IS_PKG=0 THEN 1 ELSE 0 END) +
   0.523 * (CASE WHEN IS_WOJT_USER=0 THEN 1 ELSE 0 END) +
   0.1991 * (CASE WHEN NET_TYPE=0 THEN 1 ELSE 0 END) +
   0.2373 * (CASE WHEN MANU_NAME=0 THEN 1 ELSE 0 END) +
   0.08003 * (CASE WHEN MANU_NAME=1 THEN 1 ELSE 0 END) +
   0.1548 * (CASE WHEN MANU_NAME=2 THEN 1 ELSE 0 END) +
   -2.285 * (CASE WHEN AGREE_EXP=0 THEN 1 ELSE 0 END) +
    -1.351
   )))*100,2) USER_SCORE
FROM MID_V_M_3G_LOST_STEP2
WHERE MONTH_ID = V_MONTH
AND PROV_ID = V_PROV
AND IS_CARD = '0'
AND IS_AGREE = 1
;

COMMIT;



-----����
INSERT INTO MID_V_M_3G_LOST_FLAG
SELECT MONTH_ID,
       PROV_ID,
       AREA_ID,
       CUST_ID,
       SUBS_INSTANCE_ID,
       DEVICE_NUMBER,
       SERVICE_TYPE,
       IS_CARD,
       IS_FREE,
       IS_TEST,
       IS_AGREE,
       IS_INNET,
       IS_SANWU,
       IS_LOWER_VALUE_USER,
       USER_STATUS,
   100-ROUND(1/(1+EXP(-(
   -0.5973 * INNET_MONTH +
   -0.002878 * CALL_RATIO +
   -0.002087 * STREAM_RATIO +
   0.1493 * ACCT_FEE +
   0.1572 * JF_TIMES +
   -0.04325 * TOTAL_FLUX +
   -0.08309 * LAST_STOP_DATE +
   0.05438 * ACCT_CN +
   0.005342 * FLUX_CN +
   -0.01497 * TIMES_CN +
   0.4766 * CALL_CN7 +
   0.1178 * YIWANG_CNT +
   -0.06243 * CALL_DAYS +
   -0.09473 * VALID_CALL_RING +
   -0.1615 * CELLID_NUM +
   0.003884 * LAST_JF_MONTH +
   0.02878 * JF_MON +
   0.6595 * DEV_NUM_SHANG +
   0.3763 * (CASE WHEN PAY_MODE_2=0 THEN 1 ELSE 0 END) +
   0.4014 * (CASE WHEN PRODUCT_TYPE=1 THEN 1 ELSE 0 END) +
   0.5963 * (CASE WHEN PRODUCT_TYPE=2 THEN 1 ELSE 0 END) +
   -0.1955 * (CASE WHEN CHANNEL_TYPE=1 THEN 1 ELSE 0 END) +
   -0.4543 * (CASE WHEN TERM_TYPE=1 THEN 1 ELSE 0 END) +
   0.09879 * (CASE WHEN USE_STATUS_INNET=1 THEN 1 ELSE 0 END) +
   0.06562 * (CASE WHEN USE_STATUS_INNET=2 THEN 1 ELSE 0 END) +
   -0.3963 * (CASE WHEN LAST_IS_ACCT=0 THEN 1 ELSE 0 END) +
   0.1694 * (CASE WHEN MEMBER_LVL=1 THEN 1 ELSE 0 END) +
   0.09564 * (CASE WHEN P2P_SMS_CNT=0 THEN 1 ELSE 0 END) +
   -0.0202 * (CASE WHEN IS_PKG=0 THEN 1 ELSE 0 END) +
   0.5043 * (CASE WHEN IS_WOJT_USER=0 THEN 1 ELSE 0 END) +
   0.2958 * (CASE WHEN NET_TYPE=0 THEN 1 ELSE 0 END) +
   0.173 * (CASE WHEN MANU_NAME=0 THEN 1 ELSE 0 END) +
   -0.03181 * (CASE WHEN MANU_NAME=1 THEN 1 ELSE 0 END) +
   0.008765 * (CASE WHEN MANU_NAME=2 THEN 1 ELSE 0 END) +
    -0.4348
   )))*100,2) USER_SCORE
FROM MID_V_M_3G_LOST_STEP2
WHERE MONTH_ID = V_MONTH
AND PROV_ID = V_PROV
AND IS_CARD = '0'
AND IS_AGREE = 0
;

COMMIT;




----�ں�
INSERT INTO MID_V_M_3G_LOST_FLAG
SELECT MONTH_ID,
       PROV_ID,
       AREA_ID,
       CUST_ID,
       SUBS_INSTANCE_ID,
       DEVICE_NUMBER,
       SERVICE_TYPE,
       IS_CARD,
       IS_FREE,
       IS_TEST,
       IS_AGREE,
       IS_INNET,
       IS_SANWU,
       IS_LOWER_VALUE_USER,
       USER_STATUS,
   100-ROUND(1/(1+EXP(-(
   -0.5864 * INNET_MONTH +
   0.347 * ACCT_FEE +
   0.1037 * JF_TIMES +
   -0.04299 * TOTAL_FLUX +
   -0.03174 * LAST_STOP_DATE +
   0.006857 * ACCT_CN +
   0.01458 * FLUX_CN +
   -0.002371 * TIMES_CN +
   0.6215 * CALL_CN7 +
   0.0513 * YIWANG_CNT +
   -0.06051 * CALL_DAYS +
   0.008509 * VALID_CALL_RING +
   -0.1291 * CELLID_NUM +
   0.03436 * LAST_JF_MONTH +
   0.009693 * JF_MON +
   2.917 * DEV_NUM_SHANG +
   0.01293 * (CASE WHEN PAY_MODE_2=0 THEN 1 ELSE 0 END) +
   -20.45 * (CASE WHEN PRODUCT_TYPE=1 THEN 1 ELSE 0 END) +
   -0.2139 * (CASE WHEN CHANNEL_TYPE=1 THEN 1 ELSE 0 END) +
   -1.377 * (CASE WHEN TERM_TYPE=1 THEN 1 ELSE 0 END) +
   0.3201 * (CASE WHEN USE_STATUS_INNET=1 THEN 1 ELSE 0 END) +
   0.2488 * (CASE WHEN USE_STATUS_INNET=2 THEN 1 ELSE 0 END) +
   -0.1019 * (CASE WHEN LAST_IS_ACCT=0 THEN 1 ELSE 0 END) +
   0.1958 * (CASE WHEN MEMBER_LVL=1 THEN 1 ELSE 0 END) +
   0.08806 * (CASE WHEN P2P_SMS_CNT=0 THEN 1 ELSE 0 END) +
   -0.1859 * (CASE WHEN IS_PKG=0 THEN 1 ELSE 0 END) +
   0.3646 * (CASE WHEN IS_WOJT_USER=0 THEN 1 ELSE 0 END) +
   0.232 * (CASE WHEN NET_TYPE=0 THEN 1 ELSE 0 END) +
   0.1389 * (CASE WHEN MANU_NAME=0 THEN 1 ELSE 0 END) +
   0.01115 * (CASE WHEN MANU_NAME=1 THEN 1 ELSE 0 END) +
   0.02233 * (CASE WHEN MANU_NAME=2 THEN 1 ELSE 0 END) +
    -3.902
   )))*100,2) USER_SCORE
FROM MID_V_M_3G_LOST_STEP2
WHERE MONTH_ID = V_MONTH
AND PROV_ID = V_PROV
AND IS_CARD = '2'
;
COMMIT;


---�÷ִ���
INSERT INTO DWA_V_M_3G_LOST_FLAG
SELECT MONTH_ID,
       PROV_ID,
       AREA_ID,
       CUST_ID,
       SUBS_INSTANCE_ID,
       DEVICE_NUMBER,
       SERVICE_TYPE,
       IS_CARD,
       IS_FREE,
       IS_TEST,
       IS_AGREE,
       IS_INNET,
       IS_SANWU,
       IS_LOWER_VALUE_USER,
       USER_STATUS,
       CASE WHEN ROUND(USER_SCORE) < 1 THEN 27
         ELSE USER_SCORE
           END USER_SCORE
FROM MID_V_M_3G_LOST_FLAG
WHERE MONTH_ID = V_MONTH
AND PROV_ID = V_PROV
;


      V_ROWLINE := SQL%ROWCOUNT;
      COMMIT;


    V_RETCODE := 'SUCCESS';
    V_RETINFO := '����';
ELSE
    V_RETCODE := 'WAIT';
    V_RETINFO := '�ȴ�����';
END IF;



  -- ����ִ�н��
  P_UPDATE_LOG(V_MONTH,
               V_PKG,
               V_PROCNAME,
               V_PROV,
               V_RETINFO,
               V_RETCODE,
               SYSDATE,
               V_ROWLINE);
  P_UPDATE_SQLPARSER_LOG_GENERAL(V_LOG_SN, V_RETCODE, V_RETINFO);
EXCEPTION
  WHEN OTHERS THEN
    V_RETCODE := 'FAIL';
    V_RETINFO := SQLERRM;
    P_UPDATE_LOG(V_MONTH,
                 V_PKG,
                 V_PROCNAME,
                 V_PROV,
                 V_RETINFO,
                 V_RETCODE,
                 SYSDATE,
                 V_ROWLINE);
    P_UPDATE_SQLPARSER_LOG_GENERAL(V_LOG_SN, V_RETCODE, V_RETINFO);
END;
/
