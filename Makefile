.PHONY: build run stop

build:
	docker build --tag rabbitmq-server-8968:latest .

run:
	docker run --rm --tty --interactive --publish 15672:15672 --name rabbitmq-server-8968 rabbitmq-server-8968:latest

stop:
	docker stop rabbitmq-server-8968
