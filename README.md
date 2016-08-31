# hadoop
#start-hive.sh
echo "start hive server..."
ssh slave1 "nohup /usr/local/hive/bin/hive --service hiveserver 10000 >> hiveserver.log 2>&1 & "
sleep 5

#start-hadoop.sh
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

/usr/local/etc/hadoop/sbin/start-all.sh

#







val file = sc.textFile("hdfs://master:4001/input/wordcount.txt")


hadoop2环境搭建：

hadoop dfsadmin -report 


hdfs namenode -format -clusterid c1
hdfs dfs -put core-site.xml hdfs://master:4001/

<property>
    <name>fs.viewfs.mounttable.default.link./ns1</name>
	<value>hdfs://master:4001</value>
</property>
<property>
    <name>fs.viewfs.mounttable.default.link./ns2</name>
	<value>hdfs://slave1:4001</value>
</property>


hdfs dfs -ls viewfs:///

hdfs dfs -ls viewfs:///ns1/
hdfs dfs -ls viewfs:///ns2/

viewfs://ns/

default -> ns/


hdfs dfs -ls /

hdfs dfs -ls /ns1

ns1 -> etc

hdfs dfs -mkdir hdfs://hadoop1:4001/etc
hdfs dfs -put core-site.xml /etc
hdfs dfs -ls hdfs://hadoop1:4001/etc

cat core-site.xml

scp a.xml slave1:/usr/local/hadoop/tmp/journal

<configuration xmlns:xi="http://www.w3.org/2001/XInclude">
    <xi:include href="cmt.xml"/>
	 <property>
	     <name>fs.default.name</name>
		 <value>viewfs://ns/</value>
	 </property>
</configuration>

hadoop ha:


hdfs haadmin -getServiceState ns2

hive --service metastore

bin/hive --service hiveserver 10000
nohup ./bin/hive --service hiveserver 10000 >> hiveserver.log 2>&1 & 


hive --service metastore , 用这条命令来启动hive。

server.1=master:2888:3888
server.2=slave1:2888:3888
server.3=slave2:2888:3888

export ZOOKEEPER_HOME=/usr/local/zookeeper
export PATH=$ZOOKEEPER_HOME/bin:$PATH


  <property>   
      <name>ha.zookeeper.quorum</name>
      <value>master:2181,slave1:2181,slave2:2181</value>
  </property>
  
  <property>   
      <name>dfs.ha.automatic-failover.enabled.mycluster</name>
      <value>true</value>
  </property>
  
 


netstat -tln | grep 8060



bin/hdfs zkfc -formatZK
sbin/hadoop-daemon.sh start zkfc

./configure --prefix=/usr/local/mysql          //指定mysql安装路径
--localstatedir=/data/mysql_db              //指定数据库的库文件存放路径
--with-mysqld-ldflags=-all-static          //以静态方式编译服务器端
--with-client-ldflags=-all-static          //以静态方式编译客户端
--with-extra-charsets=utf8,gbk        //添加utf8、gbk字符集
--with-plugins=innobase,myisam          //添加mysql存储引擎
--with-server-suffix=-community        //为mysqld版本字符串添加后缀
--with-unix-socket-path=/usr/local/mysql/sock/mysql.sock
--enable-thread-safe-client                //以线程方式编译客户端，提高性能
--enable-assembler                            //使用汇编，提高性能
--enable-profiling                                //启用profile功能
--without-embedded-server              //去除embedded
--without-debug                                //去除debug模式，提高性能
--without-bench                                //去除bench模式，提高性能


datadir=/usr/local/mysql/data
default-storage-engine=MyISAM

log-error =/usr/local/mysql/data/error.log
pid-file = /usr/local/mysql/data/mysql.pid
user = mysql
tmpdir = /tmp


/usr/local/mysql/scripts/mysql_install_db --user=mysql --basedir=/usr/local/mysql --datadir=/usr/local/mysql/data &



<configuration>

<property>
<name>dfs.replication</name>
<value>2</value>
</property>

<property>
<name>dfs.nameservices</name>
<value>cluster1</value>
</property>

<property>
<name>dfs.ha.namenodes.cluster1</name>
<value>master,slave1</value>
</property>

<property>
<name>dfs.namenode.rpc-address.cluster1.master</name>
<value>master:9000</value>
</property>

<property>
<name>dfs.namenode.rpc-address.cluster1.slave1</name>
<value>slave1:9000</value>
</property>

<property>
<name>dfs.namenode.http-address.cluster1.master</name>
<value>master:50070</value>
</property>

<property>
<name>dfs.namenode.http-address.cluster1.slave1</name>
<value>slave1:50070</value>
</property>

<property>
<name>dfs.namenode.shared.edits.dir</name>
<value>qjournal://master:8485;slave1:8485/cluster1</value>
</property>

<property>
<name>dfs.client.failover.proxy.provider.cluster1</name>
<value>org.apache.hadoop.hdfs.server.namenode.ha.ConfiguredFailoverProxyProvider</value>
</property>

<property>
<name>dfs.ha.fencing.methods</name>
<value>sshfence</value>
</property>

<property>
<name>dfs.ha.fencing.ssh.private-key-files</name>
<value>/root/.ssh/id_rsa</value>
</property>

<property>
<name>dfs.journalnode.edits.dir</name>
<value>/usr/local/hadoop/tmp/journal</value>
</property>

</configuration>




<property>
<name>javax.jdo.option.ConnectionURL</name>
<value>jdbc:mysql://c1:3306/hive_metadata?createDatabaseIfNotExist=true</value>
<description>JDBC connect string for a JDBC metastore</description>
</property>

<property>
<name>javax.jdo.option.ConnectionDriverName</name>
<value>com.mysql.jdbc.Driver</value>
<description>Driver class name for a JDBC metastore</description>
</property>

<property>
<name>javax.jdo.option.ConnectionUserName</name>
<value>hive</value>
<description>username to use against metastore database</description>
</property>

<property>
<name>javax.jdo.option.ConnectionPassword</name>
<value>hive</value>
<description>password to use against metastore database</description>
</property>

<property>
<name>hive.metastore.warehouse.dir</name>
<value>/user/hive/warehouse</value>
<description>location of default database for the warehouse</description>
</property>


1，初始化zookeeper
在hadoop1上的hadoop的目录执行：
bin/hdfs zkfc -formatZK

2,启动JournalNode,NameNode和DataNode
hadoop-daemon.sh  start  journalnode
 hadoop-daemon.sh  start namenode
hadoop-daemons.sh  start datanode 
 
3，各个namenode启动ZKFC
sbin/hadoop-daemon.sh start zkfc


在hadoop100、hadoop101、hadoop102上，执行命令 hadoop-daemon.sh  start  journalnode



bin/hive --service metastore & Starting Hive Metastore Server


hive --hiveconf  hive.root.logger=DEBUG,console

yum install -y ntpdate
ntpdate ntp.sjtu.edu.cn

/root/hadoop/share/hadoop/mapreduce
hadoop jar hadoop-mapreduce-examples-2.2.0.jar wordcount /input /output

cd ../..
find . -name *.jar

ll ls

hive:
hive -e 'show databases'
hive>  dfs -ls /


chmod 700 /etc/profile

~/.bashrc



common.loader=${catalina.base}/lib,${catalina.base}/lib/*.jar,${catalina.home}/lib,${catalina.home}/lib/*.jar,${catalina.home}/../server/lib/*.jar,/home/dev/hadoop/share/hadoop/common/*.jar,/home/dev/hadoop/share/hadoop/common/lib/*.jar,/home/dev/hadoop/share/hadoop/yarn/*.jar,/home/dev/hadoop/share/hadoop/hdfs/*.jar,/home/dev/hadoop/share/hadoop/mapreduce/*.jar


common.loader=${catalina.base}/lib,${catalina.base}/lib/*.jar,${catalina.home}/lib,${catalina.home}/lib/*.jar,${catalina.home}/../server/lib/*.jar,/usr/local/hadoop/share/hadoop/common/*.jar,/usr/local/hadoop/share/hadoop/common/lib/*.jar,/usr/local/hadoop/share/hadoop/yarn/*.jar,/usr/local/hadoop/share/hadoop/hdfs/*.jar,/usr/local/hadoop/share/hadoop/mapreduce/*.jar

org.apache.sqoop.submission.engine.mapreduce.configuration.directory=/usr/local/hadoop/etc/hadoop


create table ar_disp_std(id int, squ_mtr_eff string, area string) row format delimited fields terminated by ',';

bin/sqoop import --connect jdbc:oracle:thin:@192.168.149.114:1521:MBTESTDB --username MTSBWTST --password MTSBWTST --table AR_DISP_STD --columns "ID,SQU_MTR_EFF,AREA" --fields-terminated-by ',' --null-string '' --hive-import -m 2

bin/sqoop import --connect jdbc:oracle:thin:@192.168.149.114:1521:MBTESTDB --username MTSBWTST --password MTSBWTST --table A --columns "ID,CODE,NAME" --fields-terminated-by ','  --null-string '' --hive-import -m 2

bin/sqoop import --connect jdbc:oracle:thin:@192.168.149.114:1521:MBTESTDB --username MTSBWTST --password MTSBWTST -target-dir '/a' -m 1 --table AR_DISP_STD --columns "ID,SQU_MTR_EFF,AREA" --fields-terminated-by '\t'










