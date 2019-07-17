FROM debian:stable AS openjdk8_builder

LABEL maintainer="lukas.hlubucek@gmail.com"
LABEL version="4"

ARG URL_KEY=https://adoptopenjdk.jfrog.io/adoptopenjdk/api/gpg/key/public
ARG URL_REPO=https://adoptopenjdk.jfrog.io/adoptopenjdk/deb/
RUN set -e \
&& apt update \
&& apt install -y --no-install-recommends \
gnupg \
software-properties-common \
unzip \
wget \
&& wget -qO - ${URL_KEY} | apt-key add - \
&& add-apt-repository --yes --update ${URL_REPO} \
&& apt install -y --no-install-recommends adoptopenjdk-8-hotspot \
&& rm -rf /var/lib/apt/lists/*

FROM openjdk8_builder AS android_builder

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
&& yes y | sdkmanager --licenses

FROM android_builder AS apolo_builder
RUN set -e \
&& apt update \
&& apt install -y --no-install-recommends curl \
&& curl -sL https://deb.nodesource.com/setup_12.x | bash - \
&& apt-get install -y nodejs \
&& npm install -g apollo-codegen@0.19.1 \
&& rm -rf /var/lib/apt/lists/*

FROM apolo_builder AS project_builder

# # For debug uncomment.
# # Copy files and directories in context into `/tmp`.
# # Muset allow in `.dockerignore`.
# WORKDIR /tmp
# COPY ./* ./
