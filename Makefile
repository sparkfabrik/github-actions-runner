all: build-docker-image push-docker-image

build-docker-image:
	docker build -t sparkfabrik/github-actions-runner:latest -f Dockerfile .

push-docker-image:
	docker push sparkfabrik/github-actions-runner:latest