CREATE OR REPLACE PROCEDURE P_DWA_V_M_4G_LOST_MID1(V_MONTH   IN VARCHAR2,
                                                    V_PROV IN VARCHAR2,
                                                    V_RETCODE OUT VARCHAR2,
                                                    V_RETINFO OUT VARCHAR2) IS
  /*%
     *********************************************************
  *名称 --%@杜娅丽:
  *功能描述 --%@4G稳定度模型数据汇总表:
  *执行周期 --%@PERIOD:月
  *参数 --%@PARAM:V_MONTH 当月 YYYYMM
  *创建人 --%@杜娅丽:
  *创建时间 --%@2015-05-25:
  *层次---%@LEVEL:DWA层
  *主题域---%@MASTER_FIELD:
  *备注 --%@REMARK:
  *修改记录 --%@MODIFY:
  *所属于实体--%@ENTITY:
  *来源表 --%@FROM:
  *来源表 --%@FROM:
  *来源表 --%@FROM:
  *来源表 --%@FROM:
  *来源表 --%@FROM:
  *来源表 --%@FROM:
  *目标表 --%@TO:
     **************************************************************
  %*/
  V_PKG      VARCHAR2(30);
  V_TAB      VARCHAR2(300);
  V_PROCNAME VARCHAR2(300);
  V_ROWLINE  NUMBER;
  V_COUNT    NUMBER;
  V_MONTH1   VARCHAR(6);
  V_MONTH2   VARCHAR(6);
  V_SQL      LONG;
  V_LOG_SN   NUMBER;
BEGIN
  V_PKG      := 'LOST_4G'; -- 分类
  V_TAB      := 'MID_V_M_4G_LOST_1';
  V_PROCNAME := 'P_DWA_V_M_4G_LOST_MID1'; -- 过程名称
  V_MONTH1   := TO_CHAR(ADD_MONTHS(TO_DATE(V_MONTH,'YYYYMM'),-1),'YYYYMM');
  V_MONTH2   := TO_CHAR(ADD_MONTHS(TO_DATE(V_MONTH,'YYYYMM'),-2),'YYYYMM');

  SELECT ZB_CSM.SEQ_DWD_SQLPARSER.NEXTVAL
      INTO V_LOG_SN --运行日志序号
      FROM DUAL;
  --日志部分
  P_INSERT_SQLPARSER_LOG_GENERAL(V_LOG_SN,V_MONTH,V_PROV,'ZB_DWA',V_PROCNAME,'V_DATE='||V_MONTH||';V_PROV='||V_PROV ,SYSDATE,V_TAB);
  P_INSERT_LOG(V_MONTH ,V_PKG,V_PROCNAME,V_PROV,SYSDATE,V_TAB);

  --条件判断
   SELECT COUNT(1) INTO V_COUNT FROM ZBG_DM.DM_V_M_CUS_CB_HOR_MOBILE@LINK_DSSDWE
    WHERE MONTH_ID = V_MONTH
    AND PROV_ID = V_PROV
    AND ROWNUM < 11;

IF V_COUNT = 10 THEN

         V_SQL := 'ALTER TABLE ZB_CSM.MID_V_M_4G_LOST_1 TRUNCATE SUBPARTITION PART'||V_MONTH||'_SUBPART'||V_PROV ;
      execute immediate v_sql;


       V_SQL := 'ALTER TABLE ZB_CSM.DYL_4G_DEV_NUM_SHANG TRUNCATE SUBPARTITION PART'||V_MONTH||'_SUBPART'||V_PROV ;
      execute immediate v_sql;


       V_SQL := 'INSERT INTO DYL_4G_DEV_NUM_SHANG
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
 FROM ZBG_DM.DM_V_M_CUS_CB_HOR_MOBILE@LINK_DSSDWE
         WHERE MONTH_ID = '''||V_MONTH||'''
         AND PROV_ID = '''||V_PROV||'''
         AND SERVICE_TYPE = ''40AAAAAA''
           AND IS_THIS_ACCT = ''1''
           AND IS_CARD <> ''1''
 ) T,
 (
 SELECT * FROM DYL_4G_DEV_NUM_SHANG
 WHERE MONTH_ID = '''||V_MONTH1||'''
 AND PROV_ID = '''||V_PROV||'''
 ) T1
 WHERE T.SUBS_INSTANCE_ID = T1.SUBS_INSTANCE_ID(+)
';
    EXECUTE IMMEDIATE V_SQL;
    COMMIT;


V_SQL := 'INSERT INTO ZB_CSM.MID_V_M_4G_LOST_1
SELECT T.MONTH_ID,
       T.PROV_ID,
       T.AREA_ID,
       T.CUST_ID,
       T.SUBS_INSTANCE_ID,
       T.DEVICE_NUMBER,
       T.SERVICE_TYPE,
       T.IS_FREE,
       T.IS_TEST,
       T.IS_AGREE,
       T.IS_INNET,
       CASE WHEN T.USE_STATUS_INNET = ''0'' THEN 1
         ELSE 0
           END IS_SANWU,
       T.IS_LOWER_VALUE_USER,
       T.USER_STATUS,
       T.PRODUCT_TYPE,
       T.CHANNEL_TYPE,
       T.LAST_STOP_DATE,
       T.INNET_MONTH,
       T.AGREE_EXP_DATE,
       T.USE_TERM_TYPE TERM_TYPE,
       T.USE_STATUS_INNET,
       T.LAST_IS_ACCT,
       T.IF_MBTOCB,
       T.MEMBER_LVL,
       T.CALL_RATIO,
       T.STREAM_RATIO,
       T.ACCT_FEE,
       T.JF_TIMES,
       T.P2P_SMS_CNT,
       T.TOTAL_FLUX,
       T.TOTAL_FLUX_4G,
       T.TOTAL_FLUX_3G,
       (NVL(T.ACCT_FEE, 0) - NVL(T1.ACCT_FEE, 0)) /
       DECODE(NVL(T1.ACCT_FEE, 0), 0, 1, NVL(T1.ACCT_FEE, 0)) ACCT_CN,
       (NVL(T.TOTAL_FLUX, 0) - NVL(T1.TOTAL_FLUX, 0)) /
       DECODE(NVL(T1.TOTAL_FLUX, 0), 0, 1, NVL(T1.TOTAL_FLUX, 0)) FLUX_CN,
       (NVL(T.JF_TIMES, 0) - NVL(T1.JF_TIMES, 0)) /
       DECODE(NVL(T1.JF_TIMES, 0), 0, 1, NVL(T1.JF_TIMES, 0)) TIMES_CN,
       VALID_CALL_RING,
       YIWANG_CNT,
       T5.NET_TYPE,
       T6.MANU_NAME,
       T7.DEV_NUM_SHANG
  FROM (SELECT MONTH_ID,
               PROV_ID,
               AREA_ID,
               CUST_ID,
               SUBS_INSTANCE_ID,
               DEVICE_NUMBER,
               SERVICE_TYPE,
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
               SUBSTR(FLUXMOST1MON_IMEI,1,8) TAC,
               LAST_STOP_DATE,
               INNET_MONTH,
               AGREE_TYPE,
               AGREE_EXP_DATE,
               USE_TERM_TYPE,
               LAST_IS_ACCT,
               IF_MBTOCB,
               MEMBER_LVL,
               CALL_RATIO,
               SMS_RATIO,
               STREAM_RATIO,
               ACCT_FEE,
               JF_TIMES,
               P2P_SMS_CNT,
               TOTAL_FLUX,
               FLUX_PKG,
               VOICE_PKG,
               SMS_MMS_PKG,
               TOTAL_FLUX_4G,
               TOTAL_FLUX_3G,
               TOTAL_FLUX_2G,
               TOTAL_FLUX_OT
          FROM ZBG_DM.DM_V_M_CUS_CB_HOR_MOBILE@LINK_DSSDWE
         WHERE MONTH_ID = '''||V_MONTH||'''
         AND PROV_ID = '''||V_PROV||'''
         AND SERVICE_TYPE = ''40AAAAAA''
           AND IS_THIS_ACCT = ''1''
           AND IS_CARD <> ''1'') T,

       (SELECT SUBS_INSTANCE_ID, ACCT_FEE, TOTAL_FLUX, JF_TIMES
          FROM ZBG_DM.DM_V_M_CUS_CB_HOR_MOBILE@LINK_DSSDWE
         WHERE MONTH_ID = '''||V_MONTH1||'''
         AND PROV_ID = '''||V_PROV||'''
         AND SERVICE_TYPE = ''40AAAAAA'') T1,

       (SELECT USER_ID,
               VALID_CALL_RING,
               CALLING_MOBILE_PHONE_CDR + CALLING_TELE_PHONE_CDR YIWANG_CNT
          FROM ZBG_DWA.DWA_V_M_4G_VOICE_BEHAVIOR_'||V_PROV||'@LINK_DSSDWE
         WHERE MONTH_ID = '''||V_MONTH||'''
           AND SERVICE_TYPE = ''40AAAAAA'') T2,
      ---网络制式
       (SELECT TAC, NET_TYPE
          FROM ZB_DWD.DWD_M_RES_MB_TERMINAL_IMEI
         WHERE MONTH_ID = '''||V_MONTH||''') T5,
       ---终端品牌
       (SELECT TAC, MANU_NAME FROM ZB_csm.VIEW_IMEI_TAC_INFO) T6,
        ---号码熵
       (SELECT SUBS_INSTANCE_ID, DEV_NUM_SHANG
          FROM DYL_4G_DEV_NUM_SHANG
         WHERE MONTH_ID = '''||V_MONTH||'''
         AND PROV_ID = '''||V_PROV||''') T7
 WHERE T.SUBS_INSTANCE_ID = T1.SUBS_INSTANCE_ID(+)
   AND T.SUBS_INSTANCE_ID = T2.USER_ID(+)
   AND T.TAC = T5.TAC(+)
   AND T.TAC = T6.TAC(+)
   AND T.SUBS_INSTANCE_ID = T7.SUBS_INSTANCE_ID(+)
';
    EXECUTE IMMEDIATE V_SQL;

      V_ROWLINE := SQL%ROWCOUNT;
      COMMIT;


  V_SQL := 'ALTER TABLE ZB_CSM.DYL_4G_DEV_NUM_SHANG TRUNCATE SUBPARTITION PART'||V_MONTH2||'_SUBPART'||V_PROV ;
      execute immediate v_sql;



    V_RETCODE := 'SUCCESS';
    V_RETINFO := '结束';
ELSE
    V_RETCODE := 'WAIT';
    V_RETINFO := '等待数据';
END IF;



  -- 更新执行结果
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
