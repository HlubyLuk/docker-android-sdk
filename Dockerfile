FROM debian:stable as builder_jdk
WORKDIR /tmp
ARG JDK_URL=https://github.com/AdoptOpenJDK/openjdk8-binaries/releases/download
ARG JDK_ARCHIVE=OpenJDK8U-jdk_x64_linux_hotspot_8u222b10.tar.gz
ADD ${JDK_URL}/jdk8u222-b10/${JDK_ARCHIVE} .
RUN set -e \
&& tar -xf ${JDK_ARCHIVE} \
&& rm -rfv ${JDK_ARCHIVE}

# FROM node:lts-slim as builder_node
# RUN npm install -g apollo-codegen@0.19.1

FROM debian:stable as builder_sdk
WORKDIR /tmp
ARG SDK=sdk-tools-linux-4333796.zip
ADD https://dl.google.com/android/repository/${SDK} ./
RUN set -e \
&& apt update -qq \
&& apt install -yqq --no-install-recommends unzip \
&& unzip ${SDK} > /dev/null \
&& rm -v ${SDK}

FROM debian:stable-slim

LABEL maintainer="lukas.hlubucek@gmail.com"
LABEL version="4"

COPY --from=builder_jdk /tmp /opt
# COPY --from=builder_node /usr/local /opt/node
COPY --from=builder_sdk /tmp /opt/sdk

ENV ANDROID_HOME=/opt/sdk \
ANDROID_SDK_ROOT=/opt/sdk \
REPO_OS_OVERRIDE=linux \
PATH=/opt/sdk/tools/bin:/opt/node/bin:/opt/jdk8u222-b10/bin:$PATH
RUN set -e \
&& mkdir -p /opt/sdk /root/.android \
&& touch /root/.android/repositories.cfg \
&& yes y | sdkmanager --licenses

# # For debug uncomment.
# # Copy files and directories in context into `/tmp`.
# # Muset allow in `.dockerignore`.
# WORKDIR /tmp
# COPY ./* ./
