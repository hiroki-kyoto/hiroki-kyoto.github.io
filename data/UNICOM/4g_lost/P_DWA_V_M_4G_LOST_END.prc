CREATE OR REPLACE PROCEDURE P_DWA_V_M_4G_LOST_END(V_MONTH   IN VARCHAR2,

                                                     V_RETCODE OUT VARCHAR2,
                                                     V_RETINFO OUT VARCHAR2) IS
  /*@
  ****************************************************************
  *名称 --%@NAME:  P_DWA_V_M_4G_LOST_END
  *功能描述 --%@COMMENT:4G稳定度模型用户高中低稳定度标签表
  *执行周期 --%@PERIOD:月
  *参数 --%@PARAM:V_DATE 日期,格式YYYYMM
  *参数 --%@PARAM:V_RETCODE  过程运行结束成功与否标志
  *参数 --%@PARAM:V_RETINFO  过程运行结束成功与否描述
  *创建人 --%@CREATOR:  杜娅丽
  *创建时间 --%@CREATED_TIME:2015-07-16
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
  V_TAB      := 'DWA_V_M_4G_LOST_END';
  V_PROCNAME := 'P_DWA_V_M_4G_LOST_END'; -- 过程名称
  SELECT ZB_CSM.SEQ_DWD_SQLPARSER.NEXTVAL
    INTO V_LOG_SN --运行日志序号
    FROM DUAL;
  --日志部分
  P_INSERT_SQLPARSER_LOG_GENERAL(V_LOG_SN,
                                 V_MONTH,
                                 '31',
                                 'ZB_DWA',
                                 V_PROCNAME,
                                 'V_DATE='||V_MONTH||';V_PROV='||
                                 '31',
                                 SYSDATE,
                                 V_TAB);
  P_INSERT_LOG(V_MONTH, V_PKG, V_PROCNAME, '31', SYSDATE, V_TAB);

  --条件判断
   SELECT COUNT(1) INTO V_COUNT FROM DWA_V_M_4G_LOST
    WHERE MONTH_ID = V_MONTH
    AND ROWNUM < 11;

IF V_COUNT = 10 THEN

  V_SQL := 'ALTER TABLE ZB_CSM.DWA_V_M_4G_LOST_END TRUNCATE PARTITION PART'||V_MONTH;
  execute immediate v_sql;


---高中低标记
INSERT INTO DWA_V_M_4G_LOST_END
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
       USER_SCORE,
       STABLE_FLAG
FROM
(SELECT MONTH_ID,
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
       USER_SCORE
FROM DWA_V_M_4G_LOST
WHERE MONTH_ID = V_MONTH
) T,
(
SELECT
ROUND(USER_SCORE) USER_SCORE_Z,
CASE WHEN SUM(COUNT(1)) OVER ( ORDER BY ROUND(USER_SCORE))/SUM(COUNT(1)) OVER (PARTITION BY 1) <= 0.3333 THEN '03'
  WHEN SUM(COUNT(1)) OVER ( ORDER BY ROUND(USER_SCORE))/SUM(COUNT(1)) OVER (PARTITION BY 1) >= 0.6666 THEN '01'
    ELSE '02'
      END STABLE_FLAG
FROM DWA_V_M_4G_LOST
WHERE MONTH_ID = V_MONTH
AND IS_INNET = 1
AND IS_SANWU = 0
AND IS_LOWER_VALUE_USER = 0
AND USER_STATUS IN ('11','12')
AND IS_FREE = 0
AND IS_TEST = 0
GROUP BY
ROUND(USER_SCORE)
ORDER BY ROUND(USER_SCORE)
) T1
WHERE ROUND(T.USER_SCORE) = T1.USER_SCORE_Z
;


      V_ROWLINE := SQL%ROWCOUNT;
      COMMIT;


  V_SQL := 'ALTER TABLE ZB_CSM.MID_V_M_4G_LOST_1 TRUNCATE PARTITION PART'||V_MONTH ;
      execute immediate v_sql;


  V_SQL := 'ALTER TABLE ZB_CSM.MID_V_M_4G_LOST_2 TRUNCATE PARTITION PART'||V_MONTH ;
      execute immediate v_sql;


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
               '31',
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
                 '31',
                 V_RETINFO,
                 V_RETCODE,
                 SYSDATE,
                 V_ROWLINE);
    P_UPDATE_SQLPARSER_LOG_GENERAL(V_LOG_SN, V_RETCODE, V_RETINFO);
END;
/
