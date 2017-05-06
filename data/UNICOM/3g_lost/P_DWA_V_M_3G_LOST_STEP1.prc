CREATE OR REPLACE PROCEDURE P_DWA_V_M_3G_LOST_STEP1(V_MONTH   IN VARCHAR2,
                                                    V_PROV IN VARCHAR2,
                                                    V_RETCODE OUT VARCHAR2,
                                                    V_RETINFO OUT VARCHAR2) IS
  /*%
     *********************************************************
  *���� --%@�����:
  *�������� --%@�ȶ����Ż�ģ�����ݻ��ܱ�:
  *ִ������ --%@PERIOD:��
  *���� --%@PARAM:V_MONTH ���� YYYYMM
  *������ --%@CREATOR:
  *����ʱ�� --%@2015-05-25:
  *���---%@LEVEL:DWA��
  *������---%@MASTER_FIELD:
  *��ע --%@REMARK:
  *�޸ļ�¼ --%@MODIFY:
  *������ʵ��--%@ENTITY:
  *��Դ�� --%@FROM:
  *��Դ�� --%@FROM:
  *��Դ�� --%@FROM:
  *��Դ�� --%@FROM:
  *��Դ�� --%@FROM:
  *��Դ�� --%@FROM:
  *Ŀ��� --%@TO:
     **************************************************************
  %*/
  V_PKG      VARCHAR2(30);
  V_TAB      VARCHAR2(300);
  V_PROCNAME VARCHAR2(300);
  V_ROWLINE  NUMBER;
  V_COUNT    NUMBER;
  V_COUNT1    NUMBER;
  V_MONTH1   VARCHAR(6);
  V_MONTH2   VARCHAR(6);
  V_MONTH3   VARCHAR(6);
  V_SQL      LONG;
  V_LOG_SN   NUMBER;
BEGIN
  V_PKG      := 'LOSTEST'; -- ����
  V_TAB      := 'MID_V_M_3G_LOST_STEP1';
  V_PROCNAME := 'P_DWA_V_M_3G_LOST_STEP1'; -- ��������
  V_MONTH1   := TO_CHAR(ADD_MONTHS(TO_DATE(V_MONTH,'YYYYMM'),-1),'YYYYMM');
  V_MONTH2   := TO_CHAR(ADD_MONTHS(TO_DATE(V_MONTH,'YYYYMM'),-5),'YYYYMM');
  V_MONTH3   := TO_CHAR(ADD_MONTHS(TO_DATE(V_MONTH,'YYYYMM'),-2),'YYYYMM');

  SELECT ZB_CSM.SEQ_DWD_SQLPARSER.NEXTVAL
      INTO V_LOG_SN --������־���
      FROM DUAL;
  --��־����
  P_INSERT_SQLPARSER_LOG_GENERAL(V_LOG_SN,V_MONTH,V_PROV,'ZB_DWA',V_PROCNAME,'V_DATE='||V_MONTH||';V_PROV='||V_PROV ,SYSDATE,V_TAB);
  P_INSERT_LOG(V_MONTH ,V_PKG,V_PROCNAME,V_PROV,SYSDATE,V_TAB);

    --�����ж�
	execute immediate 'SELECT COUNT(1) FROM ZBA_DWA.DWA_V_M_CUS_3G_HOR_MOBILE_'||V_PROV||'
    WHERE MONTH_ID = '''||V_MONTH||'''
    AND ROWNUM < 11' INTO V_COUNT;

       execute immediate 'SELECT COUNT(1) FROM ZBA_DWA.DWA_V_M_3G_VOICE_BEHAVIOR_'||V_PROV||'
    WHERE MONTH_ID = '''||V_MONTH||'''
    AND ROWNUM < 11' INTO V_COUNT1;


IF V_COUNT = 10 AND V_COUNT1 = 10 THEN

         V_SQL := 'ALTER TABLE ZB_CSM.MID_V_M_3G_LOST_STEP1 TRUNCATE SUBPARTITION PART'||V_MONTH||'_SUBPART'||V_PROV ;
      execute immediate v_sql;


       V_SQL := 'ALTER TABLE ZB_CSM.DYL_3G_DEV_NUM_SHANG TRUNCATE SUBPARTITION PART'||V_MONTH||'_SUBPART'||V_PROV ;
      execute immediate v_sql;


         V_SQL := 'INSERT INTO DYL_3G_DEV_NUM_SHANG
  SELECT T.MONTH_ID,
T.PROV_ID,
T.AREA_ID,
T.SUBS_INSTANCE_ID,
T.DEVICE_NUMBER,
CASE WHEN T1.SUBS_INSTANCE_ID IS NULL THEN   F_DEVICE_SHANG (T.DEVICE_NUMBER) ELSE T1.DEV_NUM_SHANG END DEV_NUM_SHANG
FROM(
SELECT MONTH_ID,
       PROV_ID,
       AREA_ID,
       SUBS_INSTANCE_ID,
       DEVICE_NUMBER
 FROM ZBA_DWA.DWA_V_M_CUS_3G_HOR_MOBILE_'||V_PROV||'
 WHERE MONTH_ID = '''||V_MONTH||'''
           AND IS_THIS_ACCT = ''1''
           AND IS_CARD <> ''1''
 ) T,
 (
 SELECT * FROM DYL_3G_DEV_NUM_SHANG
 WHERE MONTH_ID = '''||V_MONTH1||'''
 AND PROV_ID = '''||V_PROV||'''
 ) T1
 WHERE T.SUBS_INSTANCE_ID = T1.SUBS_INSTANCE_ID(+)
';
    EXECUTE IMMEDIATE V_SQL;
    COMMIT;


V_SQL := 'INSERT INTO ZB_CSM.MID_V_M_3G_LOST_STEP1
SELECT T.MONTH_ID,
       T.PROV_ID,
       T.AREA_ID,
       T.CUST_ID,
       T.SUBS_INSTANCE_ID,
       T.DEVICE_NUMBER,
       T.SERVICE_TYPE,
       T.IS_CARD,
       T.IS_FREE,
       T.IS_TEST,
       T.IS_AGREE,
       T.IS_INNET,
       CASE WHEN T.USE_STATUS_INNET = ''0'' THEN 1
         ELSE 0
           END IS_SANWU,
       T.IS_LOWER_VALUE_USER,
       T.USER_STATUS,
       T.PAY_MODE_2,
       T.PRODUCT_TYPE,
       T.CHANNEL_TYPE,
       T.LAST_STOP_DATE,
       T.INNET_MONTH,
       T.AGREE_TYPE,
       T.AGREE_EXP_DATE,
       T.TERM_TYPE,
       T.USE_STATUS_INNET,
       T.LAST_IS_ACCT,
       T.MEMBER_LVL,
       T.CALL_RATIO,
       T.STREAM_RATIO,
       T.ACCT_FEE,
       T.JF_TIMES,
       T.P2P_SMS_CNT,
       T.TOTAL_FLUX,
       CASE
         WHEN T.PKG_PROD_CLASS IS NULL THEN
          0
         ELSE
          1
       END IS_PKG,
       (NVL(T.ACCT_FEE, 0) - NVL(T1.ACCT_FEE, 0)) / DECODE(NVL(T1.ACCT_FEE, 0), 0, 1, NVL(T1.ACCT_FEE, 0)) ACCT_CN,
	   (NVL(T.TOTAL_FLUX, 0) - NVL(T1.TOTAL_FLUX, 0)) / DECODE(NVL(T1.TOTAL_FLUX, 0), 0, 1, NVL(T1.TOTAL_FLUX, 0)) FLUX_CN, 
	   (NVL(T.JF_TIMES, 0) - NVL(T1.JF_TIMES, 0)) / DECODE(NVL(T1.JF_TIMES, 0), 0, 1, NVL(T1.JF_TIMES, 0)) TIMES_CN,
       NVL(T2.CALL_DURA_LAST7, 0) / DECODE(NVL(T2.CALL_DURA_FIRST20, 0), 0, 1, NVL(T2.CALL_DURA_FIRST20, 0)) CALL_CN7,
       CALL_DAYS,
       VALID_CALL_RING,
       CELLID_NUM,
       YIWANG_CNT,
       CASE
         WHEN T3.SUBS_GROUP_TYPE_DESC IS NOT NULL THEN
          1
         ELSE
          0
       END IS_WOJT_USER,
       T5.NET_TYPE,
       T6.MANU_NAME,
       T7.DEV_NUM_SHANG,
       T8.JF_MON,
       T8.last_jf_month
  FROM (SELECT MONTH_ID,
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
               IS_LOWER_VALUE_USER,
               USE_STATUS_INNET,
               USER_STATUS,
               PAY_MODE_2,
               PRODUCT_TYPE,
               CHANNEL_TYPE,
               LAST_STOP_DATE,
               INNET_MONTH,
               AGREE_TYPE,
               AGREE_EXP_DATE,
               TERM_TYPE,
               LAST_IS_ACCT,
               MEMBER_LVL,
               CALL_RATIO,
               STREAM_RATIO,
               ACCT_FEE,
               JF_TIMES,
               P2P_SMS_CNT,
               TOTAL_FLUX,
               PKG_PROD_CLASS
          FROM ZBA_DWA.DWA_V_M_CUS_3G_HOR_MOBILE_'||V_PROV||'
         WHERE MONTH_ID = '''||V_MONTH||'''
           AND IS_THIS_ACCT = ''1''
           AND IS_CARD <> ''1'') T,

       (SELECT SUBS_INSTANCE_ID, ACCT_FEE, TOTAL_FLUX, JF_TIMES
          FROM ZBA_DWA.DWA_V_M_CUS_3G_HOR_MOBILE_'||V_PROV||'
         WHERE MONTH_ID = '''||V_MONTH1||''') T1,

       (SELECT USER_ID,
               CALL_DAYS,
               CALL_DURA_LAST7,
               CALL_DURA_FIRST20,
               VALID_CALL_RING,
               CELLID_NUM,
               CALLING_MOBILE_PHONE_CDR + CALLING_TELE_PHONE_CDR YIWANG_CNT
          FROM ZBA_DWA.DWA_V_M_3G_VOICE_BEHAVIOR_'||V_PROV||'
         WHERE MONTH_ID = '''||V_MONTH||'''
           AND SERVICE_TYPE = ''30AAAAAA'') T2,
       ---�ּ�ͥ
       (SELECT USER_ID, SUBS_GROUP_TYPE_DESC
          FROM ZBA_DWA.DWA_V_M_CUS_AL_ORD_MEMBER_'||V_PROV||' T,
               ZB_DIM.DIM_BI_SUBS_GROUP_TYPE      T1
         WHERE MONTH_ID = '''||V_MONTH||'''
           AND T.IS_VALID = ''1''
           AND T.IS_COMP_VALID = ''1''
           AND T.COMP_TYPE = T1.SUBS_GROUP_TYPE) T3,
       ---TAC
       (SELECT USER_ID, SUBSTR(USEMOST1MON_IMEI, 1, 8) TAC
          FROM ZBA_DWA.DWA_V_M_CUS_MB_SI_IMEI_IF_'||V_PROV||'
         WHERE MONTH_ID = '''||V_MONTH||''') T4,
       ---������ʽ
       (SELECT TAC, NET_TYPE
          FROM ZB_DWD.DWD_M_RES_MB_TERMINAL_IMEI
         WHERE MONTH_ID = '''||V_MONTH||''') T5,
       ---�ն�Ʒ��
       (SELECT TAC, MANU_NAME FROM ZB_csm.VIEW_IMEI_TAC_INFO) T6,
       ---������
       (SELECT SUBS_INSTANCE_ID, DEV_NUM_SHANG
          FROM DYL_3G_DEV_NUM_SHANG
         WHERE MONTH_ID = '''||V_MONTH||'''
         AND PROV_ID = '''||V_PROV||''') T7,
       ---�ɷ�
       (SELECT T.USER_ID, JF_MON, MONTH_ID last_jf_month
          FROM (SELECT USER_ID, COUNT(1) JF_MON
                  FROM (SELECT MONTH_ID,
                               USER_ID,
                               row_number() over(partition by MONTH_ID, USER_ID order by PAY_FEE desc) rn
                          FROM ZB_DWA.DWA_S_M_ACC_AL_PAY_'||V_PROV||'
                         WHERE MONTH_ID <= '''||V_MONTH||'''
                           AND MONTH_ID >= '''||V_MONTH2||''')
                 WHERE RN = 1
                 GROUP BY USER_ID) T,
               (SELECT MONTH_ID, USER_ID
                  FROM (SELECT MONTH_ID,
                               USER_ID,
                               row_number() over(partition by USER_ID order by MONTH_ID desc) rn
                          FROM ZB_DWA.DWA_S_M_ACC_AL_PAY_'||V_PROV||'
                         WHERE MONTH_ID <= '''||V_MONTH||'''
                           AND MONTH_ID >= '''||V_MONTH2||''')
                 WHERE RN = 1) T1
         WHERE T.USER_ID = T1.USER_ID(+)) T8
 WHERE T.SUBS_INSTANCE_ID = T1.SUBS_INSTANCE_ID(+)
   AND T.SUBS_INSTANCE_ID = T2.USER_ID(+)
   AND T.SUBS_INSTANCE_ID = T3.USER_ID(+)
   AND T.SUBS_INSTANCE_ID = T4.USER_ID(+)
   AND T4.TAC = T5.TAC(+)
   AND T4.TAC = T6.TAC(+)
   AND T.SUBS_INSTANCE_ID = T7.SUBS_INSTANCE_ID(+)
   AND T.SUBS_INSTANCE_ID = T8.USER_ID(+)
';
    EXECUTE IMMEDIATE V_SQL;

      V_ROWLINE := SQL%ROWCOUNT;
      COMMIT;


  V_SQL := 'ALTER TABLE ZB_CSM.DYL_3G_DEV_NUM_SHANG TRUNCATE SUBPARTITION PART'||V_MONTH3||'_SUBPART'||V_PROV ;
      execute immediate v_sql;



    V_RETCODE := 'SUCCESS';
    V_RETINFO := '����';
ELSE
    V_RETCODE := 'WAIT';
    V_RETINFO := '�ȴ�����';
END IF;



  -- ����ִ�н��
  P_UPDATE_LOG(V_MONTH ,
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
    P_UPDATE_LOG(V_MONTH ,
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
