run-mysql:
	docker run --name mysql -p 3306:3306 -e MYSQL_ROOT_PASSWORD=123456 -d mysql

build-docker:
	docker build -t gin-blog-docker .

delete-docker:
	docker rmi -f gin-blog-docker

run-docker:
	docker run --link mysql:mysql -p 8000:8000 gin-blog-docker

	