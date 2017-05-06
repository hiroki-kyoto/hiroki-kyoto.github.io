CREATE OR REPLACE PROCEDURE P_DYL_2G_LOST_FLAG_END2(V_MONTH   IN VARCHAR2,

                                                     V_RETCODE OUT VARCHAR2,
                                                     V_RETINFO OUT VARCHAR2) IS
  /*@
  ****************************************************************
  *���� --%@NAME:  P_DYL_2G_LOST_FLAG_END2
  *�������� --%@COMMENT:3G�ȶ����Ż�ģ���û����е��ȶ��ȱ�ǩ�����
  *ִ������ --%@PERIOD:��
  *���� --%@PARAM:V_DATE ����,��ʽYYYYMM
  *���� --%@PARAM:V_RETCODE  �������н����ɹ�����־
  *���� --%@PARAM:V_RETINFO  �������н����ɹ��������
  *������ --%@CREATOR:  �����
  *����ʱ�� --%@CREATED_TIME:2015-07-26
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
  V_PKG      := 'LOST_2G'; -- ����
  V_TAB      := 'DYL_2G_LOST_FLAG_END2';
  V_PROCNAME := 'P_DYL_2G_LOST_FLAG_END2'; -- ��������
  SELECT ZB_csm.SEQ_DWD_SQLPARSER.NEXTVAL
    INTO V_LOG_SN --������־���
    FROM DUAL;
  --��־����
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

  --�����ж�
   SELECT COUNT(1) INTO V_COUNT FROM DYL_2G_LOST_FLAG_END
    WHERE MONTH_ID = V_MONTH
    AND ROWNUM < 11;

IF V_COUNT = 10 THEN

  V_SQL := 'ALTER TABLE zb_CSM.DYL_2G_LOST_FLAG_END2 TRUNCATE PARTITION PART'||V_MONTH;
  execute immediate v_sql;


---���еͱ��
INSERT INTO zb_CSM.DYL_2G_LOST_FLAG_END2
SELECT MONTH_ID,
       PROV_ID,
       AREA_ID,
       USER_ID,
       DEVICE_NUMBER,
       SERVICE_TYPE,
       IS_FREE,
       IS_INNET,
       USER_3WU,
       IS_LOWER_VALUE_USER,
       USER_STATUS,
       USER_SCORE,
       STABLE_FLAG
FROM
(SELECT MONTH_ID,
       PROV_ID,
       AREA_ID,
       USER_ID,
       DEVICE_NUMBER,
       SERVICE_TYPE,
       IS_FREE,
       IS_INNET,
       USER_3WU,
       IS_LOWER_VALUE_USER,
       USER_STATUS,
       USER_SCORE
FROM zb_CSM.DYL_2G_LOST_FLAG_END
WHERE MONTH_ID = V_MONTH
) T,
(
SELECT
ROUND(USER_SCORE) USER_SCORE_Z,
CASE WHEN SUM(COUNT(1)) OVER ( ORDER BY ROUND(USER_SCORE))/SUM(COUNT(1)) OVER (PARTITION BY 1) <= 0.3333 THEN '03'
  WHEN SUM(COUNT(1)) OVER ( ORDER BY ROUND(USER_SCORE))/SUM(COUNT(1)) OVER (PARTITION BY 1) >= 0.6666 THEN '01'
    ELSE '02'
      END STABLE_FLAG
FROM zb_CSM.DYL_2G_LOST_FLAG_END
WHERE MONTH_ID = V_MONTH
AND IS_INNET = 1
AND USER_3WU = 0
AND IS_LOWER_VALUE_USER = 0
AND USER_STATUS IN ('11','12')
AND IS_FREE = 0
GROUP BY
ROUND(USER_SCORE)
ORDER BY ROUND(USER_SCORE)
) T1
WHERE ROUND(T.USER_SCORE) = T1.USER_SCORE_Z
;


      V_ROWLINE := SQL%ROWCOUNT;
      COMMIT;


/*  V_SQL := 'ALTER TABLE zb_CSM.MID_V_M_3G_LOST_STEP1 TRUNCATE PARTITION PART'||V_MONTH ;
      execute immediate v_sql;


  V_SQL := 'ALTER TABLE zb_CSM.MID_V_M_3G_LOST_STEP2 TRUNCATE PARTITION PART'||V_MONTH ;
      execute immediate v_sql;


  V_SQL := 'ALTER TABLE zb_CSM.MID_V_M_3G_LOST_FLAG TRUNCATE PARTITION PART'||V_MONTH ;
      execute immediate v_sql;


  V_SQL := 'ALTER TABLE zb_CSM.DWA_V_M_3G_LOST_FLAG TRUNCATE PARTITION PART'||V_MONTH ;
      execute immediate v_sql;*/


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
