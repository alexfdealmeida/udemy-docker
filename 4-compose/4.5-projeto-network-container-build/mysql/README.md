# Gerar imagem
`docker build -t alexfdealmeida/udemy-docker-compose-mysql-db .`

# Empurrar imagem
`docker push alexfdealmeida/udemy-docker-compose-mysql-db`

Obs: Antes de empurrar deve-se autenticar no terminal (docker login).

# Criar rede
`docker network create flask_network`

# Executar container da imagem
`docker run -d -p 3306:3306 --name my_udemy_docker_compose_mysql_db --rm --network flask_network -e MYSQL_ALLOW_EMPTY_PASSWORD=True alexfdealmeida/udemy-docker-compose-mysql-db`

# Acessar banco
`http://localhost:3306`