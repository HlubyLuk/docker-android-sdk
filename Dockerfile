FROM adoptopenjdk:8 as builder_sdk
WORKDIR /tmp
ARG SDK_ARCHIVE=commandlinetools-linux-7583922_latest.zip
ADD https://dl.google.com/android/repository/${SDK_ARCHIVE} ./
ENV \
ANDROID_HOME=/tmp \
ANDROID_SDK_ROOT=/tmp
RUN set -e \
&& apt update \
&& apt install unzip
RUN set -e \
&& unzip ${SDK_ARCHIVE} > /dev/null \
&& rm -v ${SDK_ARCHIVE}
RUN set -e \
&& mkdir -p /opt/sdk /root/.android \
&& touch /root/.android/repositories.cfg \
&& yes y | /tmp/cmdline-tools/bin/sdkmanager --sdk_root="/tmp" --licenses
#ndk RUN set -e && /tmp/cmdline-tools/bin/sdkmanager --sdk_root="/tmp" ndk-bundle

#apollo FROM node:lts-slim as builder_node
#apollo RUN npm install -g apollo-codegen@0.19.1

FROM adoptopenjdk:11
LABEL maintainer="lukas.hlubucek@gmail.com"
LABEL version 8
COPY --from=builder_sdk /tmp /opt/sdk
#apollo COPY --from=builder_node /usr/local /opt/node
ENV \
ANDROID_HOME=/opt/sdk \
ANDROID_SDK_ROOT=/opt/sdk \
PATH="/opt/sdk/cmdline-tools/bin/:${PATH}" \
REPO_OS_OVERRIDE=linux
#apollo ENV PATH="/opt/node/bin:${PATH}"
RUN set -e \
&& mkdir -p /opt/sdk /root/.android \
&& touch /root/.android/repositories.cfg
