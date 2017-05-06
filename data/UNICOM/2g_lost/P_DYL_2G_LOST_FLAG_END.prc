CREATE OR REPLACE PROCEDURE P_DYL_2G_LOST_FLAG_END(V_MONTH   IN VARCHAR2,
                                                     V_PROV    IN VARCHAR2,
                                                     V_RETCODE OUT VARCHAR2,
                                                     V_RETINFO OUT VARCHAR2) IS
  /*@
  ****************************************************************
  *���� --%@NAME:  P_DYL_2G_LOST_FLAG_END
  *�������� --%@COMMENT:3G�ȶ����Ż�ģ���û��ȶ��ȵ÷ּ�������
  *ִ������ --%@PERIOD:��
  *���� --%@PARAM:V_DATE ����,��ʽYYYYMM
  *���� --%@PARAM:V_RETCODE  �������н����ɹ�����־
  *���� --%@PARAM:V_RETINFO  �������н����ɹ��������
  *������ --%@CREATOR:  �����
  *����ʱ�� --%@CREATED_TIME:2015-07-25
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
  V_TAB      := 'DYL_2G_LOST_FLAG_END';
  V_PROCNAME := 'P_DYL_2G_LOST_FLAG_END'; -- ��������
  SELECT ZB_csm.SEQ_DWD_SQLPARSER.NEXTVAL
    INTO V_LOG_SN --������־���
    FROM DUAL;
  --��־����
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

  --�����ж�
   SELECT COUNT(1) INTO V_COUNT FROM DYL_2G_LOST_FLAG_WEAL
    WHERE MONTH_ID = V_MONTH
    AND PROV_ID = V_PROV
    AND ROWNUM < 11;

IF V_COUNT = 10 THEN


  V_SQL := 'ALTER TABLE zb_CSM.DYL_2G_LOST_FLAG_END TRUNCATE SUBPARTITION PART'||V_MONTH||'_SUBPART'||V_PROV;
  execute immediate v_sql;


INSERT INTO zb_CSM.DYL_2G_LOST_FLAG_END
SELECT MONTH_ID,
       PROV_ID,
       AREA_ID,
       USER_ID,
       DEVICE_NUMBER,
       SERVICE_TYPE,
       USER_STATUS,
       IS_INNET,
       IS_THIS_ACCT,
       IS_FREE,
       USER_3WU,
       IS_LOWER_VALUE_USER,
   100-ROUND(1/(1+EXP(-(
   -0.02591 * ( CASE WHEN  LAST_STOP_DATE  <=  0 then 13 WHEN  LAST_STOP_DATE > 12 then 13 else TO_NUMBER(LAST_STOP_DATE) END) +
   -0.6416 * ( CASE WHEN  INNET_MONTHS <= 0 then LN(1) WHEN  INNET_MONTHS > 148 then LN(149) else LN(INNET_MONTHS) END) +
   -0.007116 * ( CASE WHEN  TOTAL_FLUX <= 0 then LN(1) WHEN  TOTAL_FLUX > 1373 then LN(1374) else LN(TOTAL_FLUX) END) +
   1.803 * LOCAL_FLUX_ZB +
   0.2755 * ( CASE WHEN  JF_TIMES <= 0 then LN(1) WHEN  JF_TIMES > 1502 then LN(1503) else LN(JF_TIMES) END) +
   0.02963 * ( CASE WHEN  NOROAM_LONG_JF_TIMES <= 0 then LN(1) WHEN  NOROAM_LONG_JF_TIMES > 386 then LN(387) else LN(NOROAM_LONG_JF_TIMES) END) +
   1.338 * ROAM_ZB +
   0.2679 * ZHUJIAO_ZB +
   0.4677 * TOLL_NUMS_ZB +
   -0.3233 * ( CASE WHEN  ACCT_FEE <= 0 then LN(1) WHEN  ACCT_FEE > 170 then LN(171) else LN(ACCT_FEE) END) +
   0.1876 * ( CASE WHEN  ROAM_VOICE_FEE <= 0 then LN(1) WHEN  ROAM_VOICE_FEE > 49 then LN(50) else LN(ROAM_VOICE_FEE ) END) +
   -0.0772 * ( CASE WHEN  ZENGZHI_FEE < 0 then 0 WHEN  ZENGZHI_FEE > 4 then 5 else ZENGZHI_FEE END) +
   0.01932 * ( CASE WHEN  OWE_FEE <= 0 then LN(1) WHEN  OWE_FEE > 125 then LN(126) else LN(OWE_FEE ) END) +
   0.05243 * ( CASE WHEN  FLUX_TIME <= 0 then LN(1) WHEN  FLUX_TIME > 47292 then LN(47293) else LN(FLUX_TIME) END) +
   0.09961 * ( CASE WHEN  YQ_OWE_MONTHS < 0 then 1 WHEN  YQ_OWE_MONTHS > 6 then 7 else YQ_OWE_MONTHS END) +
   0.6868 * VAR_CDR_NUM +
   -0.07578 * CALL_DAYS +
   0.1486 * ( CASE WHEN  LAST_CALL_TIME < 0 then 0 WHEN  LAST_CALL_TIME > 18 then 19 else TO_NUMBER(LAST_CALL_TIME) END) +
   -0.1375 * ( CASE WHEN  CALL_DURA_LAST7_CN <= 0 then LN(1) WHEN  CALL_DURA_LAST7_CN > 437 then LN(438) else LN(CALL_DURA_LAST7_CN)  END) +
   0.05896 * ( CASE WHEN  CELLID_NUM <= 0 then LN(1) WHEN  CELLID_NUM > 86 then LN(87) else LN(CELLID_NUM) END) +
   0.3234 * DEV_NUM_SHANG +
   0.1962 * (CASE WHEN PAY_MODE=1 THEN 1 ELSE 0 END) +
   -0.8655 * (CASE WHEN PAY_MODE=2 THEN 1 ELSE 0 END) +
   0.07845 * (CASE WHEN IS_GRP_MBR=0 THEN 1 ELSE 0 END) +
   -0.07204 * (CASE WHEN IS_TERM_IPHONE=0 THEN 1 ELSE 0 END) +
   -0.08731 * (CASE WHEN IS_USE_SMART=0 THEN 1 ELSE 0 END) +
   0.3301 * (CASE WHEN NET_TYPE=0 THEN 1 ELSE 0 END) +
   0.2866 * (CASE WHEN NET_TYPE=1 THEN 1 ELSE 0 END) +
   0.5253 * (CASE WHEN NET_TYPE=2 THEN 1 ELSE 0 END) +
   0.1618 * (CASE WHEN NET_TYPE=3 THEN 1 ELSE 0 END) +
   -0.9477
   )))*100,2) USER_SCORE ,
   LOST_FLAG
FROM zb_CSM.DYL_2G_LOST_FLAG_WEAL
WHERE MONTH_ID = V_MONTH
AND PROV_ID = V_PROV
;


      V_ROWLINE := SQL%ROWCOUNT;
      COMMIT;


  V_SQL := 'ALTER TABLE zb_CSM.DYL_2G_LOST_FLAG TRUNCATE SUBPARTITION PART'||V_MONTH||'_SUBPART'||V_PROV;
  execute immediate v_sql;


  V_SQL := 'ALTER TABLE zb_CSM.DYL_2G_LOST_FLAG_WEAL TRUNCATE SUBPARTITION PART'||V_MONTH||'_SUBPART'||V_PROV;
  execute immediate v_sql;


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
