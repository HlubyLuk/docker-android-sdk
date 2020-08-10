.PHONY: all plain apollo

JDK_URL:= $(shell python ./jdk_latest_url.py)
CURRENT_VERSION := 7

all: plain apollo ndk

plain:
	docker build \
		--file=Dockerfile \
		--force-rm \
		--no-cache \
		--rm --build-arg LATEST_JDK_URL="${JDK_URL}" \
		--tag=docker.dev.dszn.cz/mogen/android-sdk:latest \
		--tag=docker.dev.dszn.cz/mogen/android-sdk:${CURRENT_VERSION} \
		.

apollo:
	sed -e 's/^\#apollo //' ./Dockerfile \
		| docker build \
			--force-rm \
			--no-cache \
			--rm \
			--build-arg LATEST_JDK_URL="${JDK_URL}" \
			--tag=docker.dev.dszn.cz/mogen/android-sdk:apollo-latest \
			--tag=docker.dev.dszn.cz/mogen/android-sdk:apollo-${CURRENT_VERSION} \
			-

ndk:
	sed -e 's/^\#ndk //' ./Dockerfile \
		| docker build \
			--force-rm \
			--no-cache \
			--rm \
			--build-arg LATEST_JDK_URL="${JDK_URL}" \
			--tag=docker.dev.dszn.cz/mogen/android-sdk:ndk-latest \
			--tag=docker.dev.dszn.cz/mogen/android-sdk:ndk-${CURRENT_VERSION} \
			-
