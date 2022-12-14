# Gerar imagem
`docker build -t alexfdealmeida/udemy-docker-php-messages-app .`

# Empurrar imagem
`docker push alexfdealmeida/udemy-docker-php-messages-app`

Obs: Antes de empurrar deve-se autenticar no terminal (docker login).

# Executar container da imagem
## Sem volume
`docker run -d -p 80:80 --name my_udemy_docker_php_messages_app --rm alexfdealmeida/udemy-docker-php-messages-app`

## Com volume anônimo
`docker run -d -p 80:80 --name my_udemy_docker_php_messages_app --rm -v /data alexfdealmeida/udemy-docker-php-messages-app`

## Com volume nomeado
`docker run -d -p 80:80 --name my_udemy_docker_php_messages_app --rm -v php_messages_volume:/var/www/html/messages alexfdealmeida/udemy-docker-php-messages-app`

## Com volume "bind mount"
`docker run -d -p 80:80 --name my_udemy_docker_php_messages_app --rm -v C:\workspace-personal\github\udemy-docker\2-volumes\messages:/var/www/html/messages alexfdealmeida/udemy-docker-php-messages-app`

## Com volume "bind mount" (atualização do projeto em tempo real)
`docker run -d -p 80:80 --name my_udemy_docker_php_messages_app --rm -v C:\workspace-personal\github\udemy-docker\2-volumes\:/var/www/html/ alexfdealmeida/udemy-docker-php-messages-app`

# Acessar aplicacão
`http://localhost:80`

## Exibir conteúdo do arquivo
`http://localhost/messages/msg-[index].txt`

Exemplo: `http://localhost/messages/msg-0.txt`