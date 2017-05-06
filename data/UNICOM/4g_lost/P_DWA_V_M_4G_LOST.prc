CREATE OR REPLACE PROCEDURE P_DWA_V_M_4G_LOST(V_MONTH   IN VARCHAR2,
                                                     V_PROV    IN VARCHAR2,
                                                     V_RETCODE OUT VARCHAR2,
                                                     V_RETINFO OUT VARCHAR2) IS
  /*@
  ****************************************************************
  *名称 --%@NAME:  P_DWA_V_M_4G_LOST
  *功能描述 --%@COMMENT:4G稳定度模型用户稳定度得分计算结果表
  *执行周期 --%@PERIOD:月
  *参数 --%@PARAM:V_DATE 日期,格式YYYYMM
  *参数 --%@PARAM:V_RETCODE  过程运行结束成功与否标志
  *参数 --%@PARAM:V_RETINFO  过程运行结束成功与否描述
  *创建人 --%@CREATOR:  杜娅丽
  *创建时间 --%@CREATED_TIME:2015-05-25
  *备注 --%@REMARK:
  *修改记录 --%@MODIFY:
  *来源表 --%@FROM:
  *目标表 --%@TO:
  *修改记录 --%@MODIFY:
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
  V_PKG      := 'LOST_4G'; -- 分类
  V_TAB      := 'DWA_V_M_4G_LOST';
  V_PROCNAME := 'P_DWA_V_M_4G_LOST'; -- 过程名称
  SELECT ZB_CSM.SEQ_DWD_SQLPARSER.NEXTVAL
    INTO V_LOG_SN --运行日志序号
    FROM DUAL;
  --日志部分
  P_INSERT_SQLPARSER_LOG_GENERAL(V_LOG_SN,
                                 V_MONTH,
                                 V_PROV,
                                 'ZB_DWA',
                                 V_PROCNAME,
                                 'V_DATE='||V_MONTH||';V_PROV='||
                                 V_PROV,
                                 SYSDATE,
                                 V_TAB);
  P_INSERT_LOG(V_MONTH, V_PKG, V_PROCNAME, V_PROV, SYSDATE, V_TAB);

  --条件判断
   SELECT COUNT(1) INTO V_COUNT FROM MID_V_M_4G_LOST_2
    WHERE MONTH_ID = V_MONTH
    AND PROV_ID = V_PROV
    AND ROWNUM < 11;

IF V_COUNT = 10 THEN

  V_SQL := 'ALTER TABLE ZB_CSM.DWA_V_M_4G_LOST TRUNCATE SUBPARTITION PART'||V_MONTH||'_SUBPART'||V_PROV;
  execute immediate v_sql;


----合约
INSERT INTO DWA_V_M_4G_LOST
SELECT MONTH_ID,
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
       IS_SANWU,
       IS_LOWER_VALUE_USER,
       USER_STATUS,
   100-ROUND(1/(1+EXP(-(
   -0.008729 * LAST_STOP_DATE +
   -0.149 * INNET_MONTH +
   0.01835 * CALL_RATIO +
   0.5156 * STREAM_RATIO +
   0.6046 * ACCT_FEE +
   0.1052 * JF_TIMES +
   0.1005 * TOTAL_FLUX +
   -0.1275 * FLUX_34G_CN +
   0.1441 * ACCT_CN +
   -0.3166 * FLUX_CN +
   -0.08298 * TIMES_CN +
   -0.2049 * VALID_CALL_RING +
   -0.05078 * YIWANG_CNT +
   0.5767 * DEV_NUM_SHANG +
   0.3875 * (CASE WHEN CHANNEL_TYPE=1 THEN 1 ELSE 0 END) +
   -2.693 * (CASE WHEN AGREE_EXP=0 THEN 1 ELSE 0 END) +
   -0.1746 * (CASE WHEN TERM_TYPE='2G' THEN 1 ELSE 0 END) +
   -0.1197 * (CASE WHEN TERM_TYPE='3G' THEN 1 ELSE 0 END) +
   -0.4091 * (CASE WHEN USE_STATUS_INNET=1 THEN 1 ELSE 0 END) +
   -0.3208 * (CASE WHEN USE_STATUS_INNET=2 THEN 1 ELSE 0 END) +
   0.09374 * (CASE WHEN LAST_IS_ACCT=0 THEN 1 ELSE 0 END) +
   -0.4012 * (CASE WHEN IF_MBTOCB=0 THEN 1 ELSE 0 END) +
   0.2622 * (CASE WHEN MEMBER_LVL=0 THEN 1 ELSE 0 END) +
   0.147 * (CASE WHEN P2P_SMS_CNT=0 THEN 1 ELSE 0 END) +
   0.2458 * (CASE WHEN NET_TYPE=0 THEN 1 ELSE 0 END) +
   0.1637 * (CASE WHEN MANU_NAME=0 THEN 1 ELSE 0 END) +
   -1.12
   )))*100,2) USER_SCORE
FROM MID_V_M_4G_LOST_2
WHERE MONTH_ID = V_MONTH
AND PROV_ID = V_PROV
AND IS_AGREE = 1
;

COMMIT;



-----单卡
INSERT INTO DWA_V_M_4G_LOST
SELECT MONTH_ID,
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
       IS_SANWU,
       IS_LOWER_VALUE_USER,
       USER_STATUS,
   100-ROUND(1/(1+EXP(-(
   -0.0221 * LAST_STOP_DATE +
   -1.149 * INNET_MONTH +
   -0.4294 * CALL_RATIO +
   0.3532 * STREAM_RATIO +
   0.03583 * ACCT_FEE +
   -0.1402 * JF_TIMES +
   0.06087 * TOTAL_FLUX +
   -0.4071 * FLUX_34G_CN +
   0.2855 * ACCT_CN +
   0.4812 * FLUX_CN +
   0.4353 * TIMES_CN +
   -0.1367 * VALID_CALL_RING +
   -0.02468 * YIWANG_CNT +
   0.3131 * DEV_NUM_SHANG +
   -2.016 * (CASE WHEN PRODUCT_TYPE=2 THEN 1 ELSE 0 END) +
   -0.4374 * (CASE WHEN PRODUCT_TYPE=3 THEN 1 ELSE 0 END) +
   -0.2538 * (CASE WHEN CHANNEL_TYPE=1 THEN 1 ELSE 0 END) +
   0.4 * (CASE WHEN TERM_TYPE='2G' THEN 1 ELSE 0 END) +
   0.1924 * (CASE WHEN TERM_TYPE='3G' THEN 1 ELSE 0 END) +
   -0.002322 * (CASE WHEN USE_STATUS_INNET=1 THEN 1 ELSE 0 END) +
   0.1381 * (CASE WHEN USE_STATUS_INNET=2 THEN 1 ELSE 0 END) +
   -0.7232 * (CASE WHEN LAST_IS_ACCT=0 THEN 1 ELSE 0 END) +
   -0.6113 * (CASE WHEN IF_MBTOCB=0 THEN 1 ELSE 0 END) +
   -0.04936 * (CASE WHEN MEMBER_LVL=0 THEN 1 ELSE 0 END) +
   0.1876 * (CASE WHEN P2P_SMS_CNT=0 THEN 1 ELSE 0 END) +
   0.2965 * (CASE WHEN NET_TYPE=0 THEN 1 ELSE 0 END) +
   -0.07431 * (CASE WHEN MANU_NAME=0 THEN 1 ELSE 0 END) +
   2.134
   )))*100,2) USER_SCORE
FROM MID_V_M_4G_LOST_2
WHERE MONTH_ID = V_MONTH
AND PROV_ID = V_PROV
AND IS_AGREE = 0
;


      V_ROWLINE := SQL%ROWCOUNT;
      COMMIT;


    V_RETCODE := 'SUCCESS';
    V_RETINFO := '结束';
ELSE
    V_RETCODE := 'WAIT';
    V_RETINFO := '等待数据';
END IF;



  -- 更新执行结果
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
