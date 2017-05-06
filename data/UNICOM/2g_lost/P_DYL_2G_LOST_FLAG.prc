CREATE OR REPLACE PROCEDURE P_DYL_2G_LOST_FLAG(V_MONTH   IN VARCHAR2,
                                                     V_PROV    IN VARCHAR2,
                                                     V_RETCODE OUT VARCHAR2,
                                                     V_RETINFO OUT VARCHAR2) IS
  /*@
  ****************************************************************
  *名称 --%@NAME:  P_DYL_2G_LOST_FLAG
  *功能描述 --%@COMMENT:2G稳定度指标加工
  *执行周期 --%@PERIOD:月
  *参数 --%@PARAM:V_DATE 日期,格式YYYYMM
  *参数 --%@PARAM:V_RETCODE  过程运行结束成功与否标志
  *参数 --%@PARAM:V_RETINFO  过程运行结束成功与否描述
  *创建人 --%@CREATOR:  杜娅丽
  *创建时间 --%@CREATED_TIME:2015-07-22
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
  V_PKG      := 'LOST_2G'; -- 分类
  V_TAB      := 'DYL_2G_LOST_FLAG';
  V_PROCNAME := 'P_DYL_2G_LOST_FLAG'; -- 过程名称
  SELECT ZB_csm.SEQ_DWD_SQLPARSER.NEXTVAL
    INTO V_LOG_SN --运行日志序号
    FROM DUAL;
  --日志部分
  P_INSERT_SQLPARSER_LOG_GENERAL(V_LOG_SN,
                                 V_MONTH,
                                 V_PROV,
                                 'zb_CSM',
                                 V_PROCNAME,
                                 'V_DATE='||V_MONTH||';V_PROV='||
                                 V_PROV,
                                 SYSDATE,
                                 V_TAB);
  P_INSERT_LOG(V_MONTH, V_PKG, V_PROCNAME, V_PROV, SYSDATE, V_TAB);


  V_SQL := 'ALTER TABLE zb_CSM.DYL_2G_LOST_FLAG TRUNCATE SUBPARTITION PART'||V_MONTH||'_SUBPART'||V_PROV;
  execute immediate v_sql;


v_sql:='INSERT INTO zb_CSM.DYL_2G_LOST_FLAG
SELECT T.*,
T1.STDEV_CDR_NUM                     ,
T1.VAR_CDR_NUM                       ,
T1.CALL_DAYS                         ,
T1.CALLING_DAYS                      ,
T1.LAST_CALL_TIME                    ,
T1.LAST_CALLING_TIME                 ,
T1.CALL_DURA_LAST7                   ,
T1.CALL_DURA_FIRST20                 ,
T1.OTHER_MOBILE_RING                 ,
T1.CELLID_NUM                        ,
T1.CALLING_MOBILE_PHONE_CDR          ,
T1.CALLING_TELE_PHONE_CDR            ,
T2.NET_TYPE,
T3.MANU_NAME,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
/*T5.IS_INNET IS_INNET_N,
T5.IS_THIS_ACCT IS_THIS_ACCT_N,
T5.USER_STATUS USER_STATUS_N,
T5.USE_STATUS_INNET USE_STATUS_INNET_N,
T5.IS_LOWER_VALUE_USER IS_LOWER_VALUE_USER_N,
T6.USER_ID_BSS,
T7.SUBS_INSTANCE_ID,*/
F_DEVICE_SHANG(T.DEVICE_NUMBER) DEV_NUM_SHANG
FROM(
SELECT MONTH_ID                   ,
PROV_ID                    ,
AREA_ID                    ,
USER_ID                    ,
DEVICE_NUMBER              ,
SERVICE_TYPE               ,
PAY_MODE                   ,
PRODUCT_ID                 ,
PRODUCT_MODE               ,
CHNL_ID                    ,
USER_STATUS                ,
CUST_ID                    ,
IS_GRP_MBR                 ,
IS_INNET                   ,
IS_THIS_ACCT               ,
IS_FREE                    ,
STOP_MONTH                 ,
LAST_STOP_DATE             ,
INNET_MONTHS               ,
FLUXMOST1MON_IMEI          ,
USE_TERM_TYPE              ,
IS_TERM_IPHONE             ,
IS_USE_SMART               ,
USER_3WU                   ,
IS_ACTIVE                  ,
IS_LOWER_VALUE_USER        ,
USE_STATUS_INNET           ,
TOTAL_FLUX                 ,
LOCAL_FLUX                 ,
JF_TIMES                   ,
NOROAM_LOCAL_JF_TIMES      ,
NOROAM_LONG_JF_TIMES       ,
NOROAM_GN_LONG_JF_TIMES    ,
NOROAM_GJ_LONG_JF_TIMES    ,
NOROAM_GAT_LONG_JF_TIMES   ,
ROAM_PROV_CALLING_TIMES    ,
ROAM_COUN_CALLING_TIMES    ,
GAT_ROAM_OUT_JF_TIMES      ,
GJ_ROAM_OUT_JF_TIMES       ,
OUT_JF_TIMES               ,
IN_JF_TIMES                ,
CDR_NUM                    ,
ROAM_PROV_CNT              ,
ROAM_COUN_CALLED_NUMS      ,
ROAM_PROV_CALLED_NUMS      ,
ROAM_GAT_CALLED_NUMS       ,
ROAM_INTER_CALLED_NUMS     ,
TOLL_NUMS                  ,
VIP_LEVEL                  ,
ACCT_FEE                   ,
ROAM_VOICE_FEE             ,
PHONE_TV_FEE               ,
PHONE_NEWSPAPER_FEE        ,
PHONE_MUSIC_FEE            ,
OWE_FEE                    ,
OVERDUE_OWE_FEE            ,
P2P_SMS_CNT                ,
COMP_ID                    ,
COMP_TYPE                  ,
FLUX_NUM                   ,
FLUX_TIME                  ,
YQ_OWE_MONTHS
FROM ZBG_DM.DM_V_M_CUS_2G_HOR_MOBILE_'||V_PROV||'@DSSDB02
WHERE MONTH_ID = '''||V_MONTH||'''
AND IS_THIS_ACCT = 1
) T,
(
SELECT USER_ID                           ,
STDEV_CDR_NUM                     ,
VAR_CDR_NUM                       ,
CALL_DAYS                         ,
CALLING_DAYS                      ,
LAST_CALL_TIME                    ,
LAST_CALLING_TIME                 ,
CALL_DURA_LAST7                   ,
CALL_DURA_FIRST20                 ,
OTHER_MOBILE_RING                 ,
CELLID_NUM                        ,
CALLING_MOBILE_PHONE_CDR          ,
CALLING_TELE_PHONE_CDR
FROM ZBA_DWA.DWA_V_M_3G_VOICE_BEHAVIOR_'||V_PROV||'
WHERE MONTH_ID = '''||V_MONTH||'''
AND SERVICE_TYPE = ''20AAAAAA''
) T1,
 (
  SELECT TAC,NET_TYPE FROM ZB_DWD.DWD_M_RES_MB_TERMINAL_IMEI
  WHERE MONTH_ID = '''||V_MONTH||'''
  ) T2,
( SELECT TAC,MANU_NAME FROM ZB_csm.VIEW_IMEI_TAC_INFO ) T3/*,
(
SELECT USER_ID,IS_INNET,IS_THIS_ACCT,USER_STATUS,USE_STATUS_INNET,IS_LOWER_VALUE_USER
FROM zbg_dm.dm_v_m_cus_2g_hor_mobile_'||V_PROV||'@dssdb02
WHERE MONTH_ID = ''201506''
) T5,
(
Select user_id_bss from ZBG_DM.DM_V_M_CUS_CB_HOR_MOBILE@LINK_DSSDWE
where month_id = ''201506''
and prov_id = '''||V_PROV||'''
and if_mbtocb = ''1''
) T6,
(
SELECT SUBS_INSTANCE_ID
FROM ZBA_DWA.DWA_V_M_CUS_3G_HOR_MOBILE_'||V_PROV||'
WHERE MONTH_ID = ''201506''
AND IS_CARD <> ''1''
) T7*/
WHERE T.USER_ID = T1.USER_ID(+)
AND SUBSTR(T.FLUXMOST1MON_IMEI,1,8) = T2.TAC(+)
AND SUBSTR(T.FLUXMOST1MON_IMEI,1,8) = T3.TAC(+)
/*AND T.USER_ID = T5.USER_ID(+)
AND T.USER_ID = T6.USER_ID_BSS(+)
AND T.USER_ID = T7.SUBS_INSTANCE_ID(+)*/
';
    EXECUTE IMMEDIATE V_SQL;

      V_ROWLINE := SQL%ROWCOUNT;
      COMMIT;


    V_RETCODE := 'SUCCESS';
    V_RETINFO := '结束';



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
