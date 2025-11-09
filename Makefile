.PHONY: pack-app build-image

pack-app:
	./mvnw install
build-image:
	docker build -t springboot-aws:latest .
push-image:
	docker push springboot-aws:latest