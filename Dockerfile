FROM busybox:latest as builder_jdk
WORKDIR /tmp
ARG LATEST_JDK_URL
ADD ${LATEST_JDK_URL} .
RUN set -e \
&& tar -xf ${PWD}/*\.gz \
&& rm ./*\.gz \
&& mkdir -p /tmp/java \
&& mv ./jdk8u*/* ./java

FROM busybox:latest as builder_sdk
WORKDIR /tmp
ARG SDK_ARCHIVE=sdk-tools-linux-4333796.zip
ADD https://dl.google.com/android/repository/${SDK_ARCHIVE} ./
RUN set -e \
&& unzip ${SDK_ARCHIVE} > /dev/null \
&& rm -v ${SDK_ARCHIVE}

#apollo FROM node:lts-slim as builder_node
#apollo RUN npm install -g apollo-codegen@0.19.1

FROM debian:stable-slim
LABEL maintainer="lukas.hlubucek@gmail.com"
LABEL version 7
COPY --from=builder_jdk /tmp/java /opt/java
COPY --from=builder_sdk /tmp /opt/sdk
#apollo COPY --from=builder_node /usr/local /opt/node
ENV \
ANDROID_HOME=/opt/sdk \
ANDROID_SDK_ROOT=/opt/sdk \
JAVA_HOME="/opt/java" \
PATH="/opt/java/bin:/opt/sdk/tools/bin:${PATH}" \
REPO_OS_OVERRIDE=linux
#apollo ENV PATH="/opt/node/bin:${PATH}"
RUN set -e \
&& mkdir -p /opt/sdk /root/.android \
&& touch /root/.android/repositories.cfg \
&& yes y | sdkmanager --licenses
