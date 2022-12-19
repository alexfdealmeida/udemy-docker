# Gerar imagem
`docker build -t alexfdealmeida/udemy-docker-compose-python-flask-app .`

# Empurrar imagem
`docker push alexfdealmeida/udemy-docker-compose-python-flask-app`

Obs: Antes de empurrar deve-se autenticar no terminal (docker login).

# Criar rede
`docker network create flask_network`

# Executar container da imagem
`docker run -d -p 5000:5000 --name my_udemy_docker_compose_python_flask_app --rm --network flask_network alexfdealmeida/udemy-docker-compose-python-flask-app`

# Acessar aplicacão
`http://localhost:5000`

# Inserir usuário (Postman)
`POST http://localhost:5000/inserthost`