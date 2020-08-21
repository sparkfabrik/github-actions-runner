all: build-docker-image cli

cli:
	docker run --rm -it --entrypoint /bin/bash sparkfabrik/github-actions-runner:latest

build-docker-image:
	docker build -t sparkfabrik/github-actions-runner:latest -f Dockerfile .

push-docker-image:
	docker push sparkfabrik/github-actions-runner:latest
