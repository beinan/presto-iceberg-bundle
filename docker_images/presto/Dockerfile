FROM centos:7

ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'

RUN yum install -y tzdata openssl curl ca-certificates fontconfig gzip tar \
    && yum update -y; yum clean all

ENV JAVA_VERSION jdk-11.0.11+9

COPY slim-java* /usr/local/bin/

RUN curl -LfsSo /tmp/openjdk.tar.gz \
     https://github.com/AdoptOpenJDK/openjdk11-binaries/releases/download/jdk-11.0.11%2B9/OpenJDK11U-jdk_x64_linux_hotspot_11.0.11_9.tar.gz;

RUN echo "e99b98f851541202ab64401594901e583b764e368814320eba442095251e78cb /tmp/openjdk.tar.gz" | sha256sum -c ;

RUN mkdir -p /opt/java/openjdk; \
    cd /opt/java/openjdk; \
    tar -xf /tmp/openjdk.tar.gz --strip-components=1; \
    export PATH="/opt/java/openjdk/bin:$PATH"; \
    /usr/local/bin/slim-java.sh /opt/java/openjdk; \
    rm -rf /tmp/openjdk.tar.gz;


RUN yum install -y setuptools epel-release && \
    yum install -y python-pip && \
    pip install --upgrade pip==9.0.3 && \
    pip install --upgrade setuptools==36.8.0 `# latest version for Python 2.6` && \
    pip install supervisor && \
    yum install -y vim;

# cleanup
RUN    yum -y clean all && rm -rf /tmp/* /var/tmp/*;

# JMX to Prometheus exporter
RUN curl -LfsSo /jmx_prometheus_javaagent.jar https://repo1.maven.org/maven2/io/prometheus/jmx/jmx_prometheus_javaagent/0.16.0/jmx_prometheus_javaagent-0.16.0.jar

ENV JAVA_HOME=/opt/java/openjdk \
    PATH="/opt/java/openjdk/bin:$PATH"


