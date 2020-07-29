FROM busybox:latest as builder_jdk
WORKDIR /tmp
ARG JDK_URL=https://github.com/AdoptOpenJDK/openjdk8-binaries/releases/download
ARG JDK_DIR=jdk8u262-b10
ARG JDK_ARCHIVE=OpenJDK8U-jdk_x64_linux_hotspot_8u262b10.tar.gz
ADD ${JDK_URL}/${JDK_DIR}/${JDK_ARCHIVE} .
RUN set -e \
&& tar -xf ${JDK_ARCHIVE} \
&& rm -rfv ${JDK_ARCHIVE}

# FROM node:lts-slim as builder_node
# RUN npm install -g apollo-codegen@0.19.1

FROM busybox:latest as builder_sdk
WORKDIR /tmp
ARG SDK_ARCHIVE=sdk-tools-linux-4333796.zip
ADD https://dl.google.com/android/repository/${SDK_ARCHIVE} ./
RUN set -e \
&& unzip ${SDK_ARCHIVE} > /dev/null \
&& rm -v ${SDK_ARCHIVE}

FROM debian:stable-slim
LABEL maintainer="lukas.hlubucek@gmail.com"
LABEL version="6"
ARG JDK_DIR=jdk8u262-b10
COPY --from=builder_jdk /tmp /opt
# COPY --from=builder_node /usr/local /opt/node
COPY --from=builder_sdk /tmp /opt/sdk
ENV \
ANDROID_HOME=/opt/sdk \
ANDROID_SDK_ROOT=/opt/sdk \
JAVA_HOME="/opt/${JDK_DIR}" \
PATH=/opt/sdk/tools/bin:/opt/node/bin:/opt/${JDK_DIR}/bin:$PATH \
REPO_OS_OVERRIDE=linux
RUN set -e \
&& mkdir -p /opt/sdk /root/.android \
&& touch /root/.android/repositories.cfg \
&& yes y | sdkmanager --licenses \
&& sdkmanager ndk-bundle \
&& sdkmanager --list | grep -e "build-tools" | cut -d "|" -f 1 | tr -s " " | sort | tail --lines=5 | sed -e "s/ //g" | xargs -n 1 -I {} sdkmanager "{}" \
&& sdkmanager --list | grep -e "platform" | grep -e "android" | cut -d "|" -f 1 | sed -e "s/ //g" | sort  --key=2 --field-separator="-" --general-numeric-sort | tail --line=5 | xargs -n 1 -I {} sdkmanager "{}"

## ## For debug uncomment.
## ## Copy files and directories in context into `/tmp`.
## ## Muset allow in `.dockerignore`.
## WORKDIR /tmp
## COPY ./* ./
