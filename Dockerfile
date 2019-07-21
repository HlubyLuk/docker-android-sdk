FROM debian:stable as builder_sdk

WORKDIR /opt
ARG JDK=OpenJDK8U-jdk_x64_linux_hotspot_8u222b10.tar.gz
ARG JDK_URL=https://github.com/AdoptOpenJDK/openjdk8-binaries/releases/download
ADD ${JDK_URL}/jdk8u222-b10/${JDK} /opt
RUN set -e \
&& tar -xf ${JDK} \
&& rm -rfv ${JDK}
ENV PATH=/opt/jdk8u222-b10/bin:$PATH

WORKDIR /tmp
ARG SDK=sdk-tools-linux-4333796.zip
ADD https://dl.google.com/android/repository/${SDK} ./
RUN set -e \
&& apt update -qq \
&& apt install -yqq --no-install-recommends unzip \
&& unzip ${SDK} > /dev/null \
&& rm -v ${SDK} \
&& rm -rf /var/lib/apt/lists/*

WORKDIR /opt
ENV ANDROID_HOME=/opt/sdk \
ANDROID_SDK_ROOT=/opt/sdk \
REPO_OS_OVERRIDE=linux
RUN set -e \
&& mkdir -p /opt/sdk /root/.android \
&& touch /root/.android/repositories.cfg \
&& mv /tmp/tools /opt/sdk \
&& ln -s /opt/sdk/tools/bin/* /bin/ \
&& yes y | sdkmanager --licenses

FROM node:lts-slim as builder_node
RUN npm install -g apollo-codegen@0.19.1

FROM debian:stable-slim

LABEL maintainer="lukas.hlubucek@gmail.com"
LABEL version="5"

COPY --from=builder_sdk /opt /opt
COPY --from=builder_node /usr/local /opt/node
ENV ANDROID_HOME=/opt/sdk \
ANDROID_SDK_ROOT=/opt/sdk \
REPO_OS_OVERRIDE=linux \
NODE_PATH=/opt/npm-installed \
PATH=/opt/node/bin:/opt/jdk8u222-b10/bin:$PATH
RUN set -e \
&& mkdir -p /opt/sdk /root/.android \
&& touch /root/.android/repositories.cfg

# # For debug uncomment.
# # Copy files and directories in context into `/tmp`.
# # Muset allow in `.dockerignore`.
# WORKDIR /tmp
# COPY ./* ./
