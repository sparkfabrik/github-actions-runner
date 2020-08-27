all: build-docker-image cli

cli:
	docker run --rm -it --entrypoint /bin/bash sparkfabrik/github-actions-runner:latest

build-docker-image:
	docker build -t sparkfabrik/github-actions-runner:latest -f Dockerfile .

push-docker-image: build-docker-image
	docker push sparkfabrik/github-actions-runner:latest

build-test-docker-image:
	docker build -t sparkfabrik/github-actions-runner:test -f Dockerfile .

push-test-docker-image: build-test-docker-image
	docker push sparkfabrik/github-actions-runner:test
