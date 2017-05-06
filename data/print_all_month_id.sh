echo "SELECT COUNT(MONTH_ID) FROM DM_V_M_CUS_2G_HOR_MOBILE_079 GROUP BY MONTH_ID;" > echo_month_id.sql
echo "SELECT COUNT(MONTH_ID) FROM DWA_V_M_2G_VOICE_BEHAVIOR_079 GROUP BY MONTH_ID;" >> echo_month_id.sql
echo "SELECT COUNT(MONTH_ID) FROM DWD_M_RES_MB_TERMINAL_IMEI GROUP BY MONTH_ID;" >> echo_month_id.sql
echo "EXIT" >> echo_month_id.sql
sqlplus gpu/gpu @echo_month_id.sql
