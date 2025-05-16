FROM openjdk:8-jre
ARG JMETER_VERSION=5.1.1



# 复制 Jmeter
COPY apache-jmeter-${JMETER_VERSION}   /opt/jmeter/apache-jmeter-${JMETER_VERSION}
COPY sources.list   /opt/jmeter
COPY init.sh   /

# 设置工作目录
WORKDIR /opt/jmeter/apache-jmeter-$JMETER_VERSION/bin

# 安装
RUN chmod  -R 777  /opt/jmeter/apache-jmeter-$JMETER_VERSION \
    && chmod  -R 777  /init.sh \
    && rm /etc/apt/sources.list \
    && cp /opt/jmeter/sources.list /etc/apt/sources.list \
    && rm /opt/jmeter/sources.list \
    && apt-get update \
    && apt-get install  -y \
    nano \
    net-tools \
    iputils-ping \
    openssh-server \
    postgresql-client\
    && mkdir /run/sshd \
    && sed -i "s/#PubkeyAuthentication.*/PubkeyAuthentication yes/g" /etc/ssh/sshd_config  \
    && sed -i "s/#PermitRootLogin.*/PermitRootLogin yes/g" /etc/ssh/sshd_config  \
    && sed -i "s/#PasswordAuthentication.*/PasswordAuthentication yes/g" /etc/ssh/sshd_config \
    && mkdir -p ~/.ssh \
    && echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC4YRBslRzCfIARD4H9O/xzDcLXbQ9R+ml5Y9MhI2Yqxi4ih9zaewPGJEu4ZhVzjhl3Vydnip5Jh0B86MJ6c14sE+ZIYZgshDtUE4pha+0PtvmqmtduDa3IfDuxLqmRDjf4VzTJsThVCo+6Ina2OFUY6E+jZmvqTZg3y3v7SnSjo05NTRtxXGnOt9RF2TA9LPjfLAM+7DrI5VqnorZNuehcEfIDeQMGZELR1Rp9BPsAVA90MvEqXDHon7ZTxfDcwNkZ3h2KTnhtt2r5G3dqMyI3Z9qYBsMOvibhikSSuc6uwXl1hVRuoehuRYj8G1+FqKvZBWp2Abov6pPaEX5kIYW+hjQ8QTUNhBh9gB0sps+OC9VQfscmfguvSaOYHO3Pr2uhUJnmY6ZEqT7XrpgADRexgG2zuO1PwzX0syqrTN7FeEJtgB/JvkovA5ONbutKSuTQU0mlVb8VHRG3Zk6BPkPIW8xGSSiOIOhyjn5Yy4rvblqpwB/GSapavH342Nuq7jM= 347921622@qq.com" >> ~/.ssh/authorized_keys \
    && chmod 700 ~/.ssh \
    && chmod 600 ~/.ssh/authorized_keys \
    && echo "root:123456" | chpasswd

# 设置环境变量
ENV JMETER_HOME /opt/jmeter/apache-jmeter-$JMETER_VERSION
ENV PATH="$JMETER_HOME/bin:${PATH}"


# 默认使用1099端口，可以用参数覆盖
ARG RMI_PORT=1099
ARG LOCAL_PORT=50000

CMD [ "/init.sh" ]

ENTRYPOINT $JMETER_HOME/bin/jmeter-server \
                        -Dserver_port=${RMI_PORT} \
                        -Dserver.rmi.localport=${LOCAL_PORT} \
                        -Djava.rmi.server.hostname=${HOST_IP} \
                        -Jserver.rmi.ssl.disable=true
                        

