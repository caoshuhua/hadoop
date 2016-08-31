echo "start hive server..."
ssh slave1 "nohup /usr/local/hive/bin/hive --service hiveserver 10000 >> hiveserver.log 2>&1 & "
sleep 5
