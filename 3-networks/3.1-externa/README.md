# Gerar imagem
`docker build -t alexfdealmeida/udemy-docker-python-flask-app .`

# Empurrar imagem
`docker push alexfdealmeida/udemy-docker-python-flask-app`

Obs: Antes de empurrar deve-se autenticar no terminal (docker login).

# Executar container da imagem
`docker run -d -p 5000:5000 --name my_udemy_docker_python_flask_app --rm alexfdealmeida/udemy-docker-python-flask-app`

# Acessar aplicacão
`http://localhost:5000`