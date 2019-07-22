build:
	docker build \
		--compress \
		--file=Dockerfile \
		--force-rm \
		--no-cache \
		--rm \
		--tag="android-sdk:4" \
		--tag="android-sdk:latest" \
		.

run:
	docker run \
		--interactive \
		--rm \
		--tty \
		android-sdk:latest

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
