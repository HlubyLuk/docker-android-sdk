FROM gradle:jdk8-slim

LABEL maintainer="lukas.hlubucek@gmail.com"
LABEL version="1"

USER root:root

WORKDIR /tmp
ARG SDK=sdk-tools-linux-4333796.zip
ADD https://dl.google.com/android/repository/${SDK} ./
RUN set -e \
&& unzip ${SDK} > /dev/null \
&& rm -v ${SDK}

WORKDIR /opt
ENV ANDROID_HOME=/opt/sdk \
ANDROID_SDK_ROOT=/opt/sdk \
REPO_OS_OVERRIDE=linux
RUN set -e \
&& mkdir -p /opt/sdk /root/.android \
&& touch /root/.android/repositories.cfg \
&& mv /tmp/tools /opt/sdk \
&& ln -s /opt/sdk/tools/bin/* /bin/ \
&& yes y | sdkmanager --licenses > /dev/null
