build:
	docker build \
		--compress \
		--file=Dockerfile \
		--force-rm \
		--no-cache \
		--rm \
		--tag="docker.dev.dszn.cz/mogen/android-sdk:6" \
		--tag="docker.dev.dszn.cz/mogen/android-sdk:latest" \
		.

build-apollo:
	sed -e "s/^# //" ./Dockerfile \
		| docker build \
			--compress \
			--file=Dockerfile \
			--force-rm \
			--no-cache \
			--rm \
			--tag="docker.dev.dszn.cz/mogen/android-sdk:6-apollo" \
			--tag="docker.dev.dszn.cz/mogen/android-sdk:latest-apollo" \
			-

run:
	docker run \
		--interactive \
		--rm \
		--tty \
		docker.dev.dszn.cz/mogen/android-sdk:latest

remove-all:
	docker image ls \
		| tail +2 \
		| tr -s " " \
		| cut -d " " -f 3 \
		| xargs docker image rm --force

clean:
	docker image ls \
		| grep -ve "android-sdk" \
		| tail +2 \
		| tr -s " " \
		| cut -d " " -f 3 \
		| xargs docker image rm --force
