# Private Key - AWS EC2:
`C:\Users\Alex\.ssh` (repository: credentials)

# Connection data

## Node1
`ssh -i "aws-udemy-docker.pem" ec2-user@ec2-35-174-115-64.compute-1.amazonaws.com`

## Node2
`ssh -i "aws-udemy-docker.pem" ec2-user@ec2-34-201-77-114.compute-1.amazonaws.com`

## Node3
`ssh -i "aws-udemy-docker.pem" ec2-user@ec2-54-146-177-58.compute-1.amazonaws.com`

# Docker install (All Nodes)
`sudo yum update -y`
`sudo yum install docker`
`sudo service docker start`
`sudo usermod -a -G docker ec2-user`

# Manager Node (Node1)
## Init
`docker swarm init --advertise-addr 35.174.115.64`

## Show Join
`docker swarm join-token manager`

# Worker Node (Node2 e Node3)
## Add Join
`docker swarm join --token SWMTKN-1-35swk8r5587r0q8rsvrz99gdvasegznm3u3ni8bi2bc8qwusqt-7ygwr4pw74ju7x7sfy8eck55k 35.174.115.64:2377`

# Service

## Create
### One Instance
`docker service create --name nginx-swarm -p 80:80 nginx`

### Multiple Instances
`docker service create --name nginx-swarm --replicas 3 -p 80:80 nginx`

## List

`docker service ls`

## Remove
`docker service rm nginx-swarm`

# Compose

## One Instance
`docker stack deploy -c docker-compose.yaml nginx-swarm-compose`

## Multiple Intances
`docker service scale nginx-swarm-compose_web=3`

# Exemplo de atualização do serviço

## Imagem
`docker service update --image nginx:1.18.0 nginx-swarm-compose_web`
`docker service update --image nginx:latest nginx-swarm-compose_web`

## Rede
`docker network create --driver overlay swarm_network`
`docker service update --network-add swarm_network nginx-swarm-compose_web`