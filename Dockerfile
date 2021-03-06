FROM jenkins/slave:3.19-1

MAINTAINER Ythalo Rossy <ythalorossy@gmail.com>

LABEL Description="This is a base image, which allows connecting Jenkins agents via JNLP protocols" Vendor="Jenkins project" Version="3.19"

COPY jenkins-slave /usr/local/bin/jenkins-slave

USER root

# Install Maven

ENV MAVEN_VERSION=3.3.9
ENV MAVEN_HOME=/opt/mvn

# change to tmp folder
WORKDIR /tmp

# Download and extract maven to opt folder
RUN wget --no-check-certificate --no-cookies http://archive.apache.org/dist/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz \
    && wget --no-check-certificate --no-cookies http://archive.apache.org/dist/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz.md5 \
        && echo "$(cat apache-maven-${MAVEN_VERSION}-bin.tar.gz.md5) apache-maven-${MAVEN_VERSION}-bin.tar.gz" | md5sum -c \
	    && tar -zvxf apache-maven-${MAVEN_VERSION}-bin.tar.gz -C /opt/ \
	        && ln -s /opt/apache-maven-${MAVEN_VERSION} /opt/mvn \
		    && rm -f apache-maven-${MAVEN_VERSION}-bin.tar.gz \
		        && rm -f apache-maven-${MAVEN_VERSION}-bin.tar.gz.md5

# add executables to path
RUN update-alternatives --install "/usr/bin/mvn" "mvn" "/opt/mvn/bin/mvn" 1 && \
    update-alternatives --set "mvn" "/opt/mvn/bin/mvn"

USER jenkins

ENTRYPOINT ["jenkins-slave"]
