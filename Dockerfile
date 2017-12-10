FROM java:openjdk-8-jre

#ENV DEBIAN_FRONTEND noninteractive
#ENV SCALA_VERSION 2.11
#ENV KAFKA_VERSION 2.11.1.0.0
#ENV KAFKA_HOME /opt/kafka_"$SCALA_VERSION"-"$KAFKA_VERSION"
ENV TOOLS=/tools
# ENV ZK=zookeeper
ENV KK=kafka
#ENV KM=kafka_manager


RUN apt-get update
RUN apt-get install -y supervisor dnsutils
RUN rm -rf /var/lib/apt/lists/*
RUN apt-get clean

# Create installation directories
# RUN mkdir -p "$TOOLS"/"$ZK"
RUN mkdir -p ${TOOLS}/${KK}
#RUN mkdir -p "$TOOLS"/"$KM"

# Install zookeeper
# RUN cd "$TOOLS"/"$ZK"
# ADD zookeeper-3.4.10.tar.gz zookeeper-3.4.10.tar.gz
# RUN tar -xzf zookeeper-3.4.10.tar.gz -C .
# RUN rm zookeeper-3.4.10.tar.gz
# RUN mkdir /tools/zookeeper/data

# Install kafka
WORKDIR ${TOOLS}/${KK}
COPY kafka_2.11-1.0.0.tgz .
RUN tar -xzf kafka_2.11-1.0.0.tgz 
RUN rm kafka_2.11-1.0.0.tgz
RUN mkdir ${TOOLS}/${KK}/logs

# Install kafka manager
# RUN cd "$TOOLS"/"$KM"
# ADD kafka-manager-1.3.3.15.zip kafka-manager-1.3.3.15.zip
# RUN unzip kafka-manager-1.3.3.15.zip

# ADD scripts/start-zookeeper.sh /usr/bin/start-zookeeper.sh
ADD scripts/start-kafka.sh /usr/bin/start-kafka.sh
# RUN chmod 777 /usr/bin/start-kafka.sh
# ADD scripts/start-kafka-manager.sh /usr/bin/start-kafka-manager.sh

ADD supervisor/kafka.conf /etc/supervisor/conf.d/

# 2181 - zookeeper, 9092 - kafka, 9050 - kafka-manager
EXPOSE 9092

CMD ["supervisord", "-n"]