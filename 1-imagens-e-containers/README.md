# Gerar imagem
`docker build -t alexfdealmeida/udemy-docker-node-app .`

# Empurrar imagem
`docker push alexfdealmeida/udemy-docker-node-app`

Obs: Antes de empurrar deve-se autenticar no terminal (docker login).

# Executar container da imagem
`docker run -d -p 3000:3000 --name my_udemy_docker_node_app alexfdealmeida/udemy-docker-node-app`

# Acessar aplicacão
`http://localhost:3000`