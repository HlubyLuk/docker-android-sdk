.PHONY: all plain apollo

JDK_URL:= $(shell python ./jdk_latest_url.py)
CURRENT_VERSION := 7

all: plain apollo

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
	sed -e 's/^\#apollo//' ./Dockerfile \
		| docker build \
			--force-rm \
			--no-cache \
			--rm \
			--build-arg LATEST_JDK_URL="${JDK_URL}" \
			--tag=docker.dev.dszn.cz/mogen/android-sdk:apollo-latest \
			--tag=docker.dev.dszn.cz/mogen/android-sdk:apollo-${CURRENT_VERSION} \
			-

#.PHONY: build plain apollo
#SED_PATTERN=
#CURRENT_PREFIX=
#build:
#	sed -e 's/${SED_PATTERN}//' ./Dockerfile \
#		| docker build \
#			--force-rm \
#			--no-cache \
#			--rm \
#			--build-arg LATEST_JDK_URL="${JDK_URL}" \
#			--tag=docker.dev.dszn.cz/mogen/android-sdk:${CURRENT_PREFIX}latest \
#			--tag=docker.dev.dszn.cz/mogen/android-sdk:${CURRENT_PREFIX}${CURRENT_VERSION} \
#			-
