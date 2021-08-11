.PHONY: all plain apollo

CURRENT_VERSION := 8

all: plain apollo ndk

plain:
	docker build \
		--file=Dockerfile \
		--force-rm \
		--no-cache \
		--rm \
		--tag=docker.dev.dszn.cz/mogen/android-sdk:latest \
		--tag=docker.dev.dszn.cz/mogen/android-sdk:${CURRENT_VERSION} \
		.

apollo:
	sed -e 's/^\#apollo //' ./Dockerfile \
		| docker build \
			--force-rm \
			--no-cache \
			--rm \
			--tag=docker.dev.dszn.cz/mogen/android-sdk:apollo-latest \
			--tag=docker.dev.dszn.cz/mogen/android-sdk:apollo-${CURRENT_VERSION} \
			-

ndk:
	sed -e 's/^\#ndk //' ./Dockerfile \
		| docker build \
			--force-rm \
			--no-cache \
			--rm \
			--tag=docker.dev.dszn.cz/mogen/android-sdk:ndk-latest \
			--tag=docker.dev.dszn.cz/mogen/android-sdk:ndk-${CURRENT_VERSION} \
			-
