#这是文件 bin/setenv.sh
#它将由 bin/jmeter 提供
#使用比默认值更大的堆 但更小的元空间
#export HEAP="-Xms8G -Xmx8G -XX:MaxMetaspaceSize=8G"
export JVM_ARGS="-Xms8g -Xmx8g -XX:MaxMetaspaceSize=8g"
#尝试从操作系统猜测语言环境。空格作为值是故意的!
#export JMETER_LANGUAGE=" "