echo "start zkServer..."
ssh backup  "/usr/local/zookeeper/bin/zkServer.sh start"
ssh master  "/usr/local/zookeeper/bin/zkServer.sh start"
ssh slave1  "/usr/local/zookeeper/bin/zkServer.sh start"
ssh slave2  "/usr/local/zookeeper/bin/zkServer.sh start"
ssh slave3  "/usr/local/zookeeper/bin/zkServer.sh start"
sleep 5

echo "start hadoop cluster..."
ssh master "/usr/local/hadoop/sbin/hadoop-daemon.sh start zkfc"
ssh backup "/usr/local/hadoop/sbin/hadoop-daemon.sh start zkfc"
sleep 5

ssh master "/usr/local/hadoop/hadoop-daemon.sh start journalnode"
ssh backup "/usr/local/hadoop/hadoop-daemon.sh start journalnode"
ssh slave1 "/usr/local/hadoop/hadoop-daemon.sh start journalnode"
sleep 5

ssh master "/usr/local/hadoop/hadoop-daemon.sh  start namenode"
ssh backup "/usr/local/hadoop/hadoop-daemon.sh  start namenode"
sleep 5

ssh master "/usr/local/hadoop/hadoop-daemons.sh  start datanode"
sleep 5

ssh master "/usr/local/hadoop/sbin/start-yarn.sh"
sleep 5



