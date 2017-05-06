# create tables 
sqlplus sys/root as sysdba @_2G.PRC


# fill tables with loaded data
sqlldr \"sys/root as sysdba\" control=_2G_DM_V_M_CUS_2G_HOR_MOBILE_079.CTL log=log_2g_dm.txt bad=bad.txt 
sqlldr \"sys/root as sysdba\" control=_2G_DWA_V_M_2G_VOICE_BEHAVIOR_079.CTL log=log_2g_dwa.txt bad=bad.txt 
sqlldr \"sys/root as sysdba\" control=_2G_DWD_M_RES_MB_TERMINAL_IMEI.CTL log=log_2g_dwd.txt bad=bad.txt 
sqlldr \"sys/root as sysdba\" control=_2G_VIEW_IMEI_TAC_INFO.CTL log=log_2g_view.txt bad=bad.txt

