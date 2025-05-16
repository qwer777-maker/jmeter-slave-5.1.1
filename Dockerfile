FROM openjdk:8-jre
ARG JMETER_VERSION=5.1.1

# 设置工作目录
WORKDIR /opt/jmeter/apache-jmeter-$JMETER_VERSION/bin

# 复制 Jmeter
COPY apache-jmeter-${JMETER_VERSION}   /opt/jmeter
COPY sources.list   /opt/jmeter

# 安装
RUN chmod  -R 777  /opt/jmeter/apache-jmeter-$JMETER_VERSION \
    && rm /opt/jmeter/apache-jmeter-$JMETER_VERSION.tar.gz \
    && rm /etc/apt/sources.list \
    && cp /opt/jmeter/sources.list /etc/apt/sources.list \
    && rm /opt/jmeter/sources.list \
    && apt update \
    && apt install nano -y \
    && apt install net-tools  -y \
    && apt install iputils-ping -y \
    && apt install postgresql-client -y

# 设置环境变量
ENV JMETER_HOME /opt/jmeter/apache-jmeter-$JMETER_VERSION
ENV PATH="$JMETER_HOME/bin:${PATH}"


# 默认使用1099端口，可以用参数覆盖
ARG RMI_PORT=1099
ARG LOCAL_PORT=50000

ENTRYPOINT $JMETER_HOME/bin/jmeter-server \
                        -Dserver_port=${RMI_PORT} \
                        -Dserver.rmi.localport=${LOCAL_PORT} \
                        -Djava.rmi.server.hostname=${HOST_IP} \
                        -Jserver.rmi.ssl.disable=true

