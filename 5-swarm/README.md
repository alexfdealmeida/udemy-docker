# Private Key - AWS EC2:
`C:\Users\Alex\.ssh` (repository: credentials)

# Connection data

## Node1
`ssh -i "aws-udemy-docker.pem" ec2-user@ec2-52-7-32-16.compute-1.amazonaws.com`

## Node2
`ssh -i "aws-udemy-docker.pem" ec2-user@ec2-54-197-155-94.compute-1.amazonaws.com`

## Node3
`ssh -i "aws-udemy-docker.pem" ec2-user@ec2-44-206-231-231.compute-1.amazonaws.com`

# Docker install (All Nodes)
`sudo yum update -y`
`sudo yum install docker`
`sudo service docker start`
`sudo usermod -a -G docker ec2-user`

# Manager Node (Node1)
## Init
`docker swarm init --advertise-addr 52.7.32.16`

# Worker Node (Node2 e Node3)
## Join
`docker swarm join --token SWMTKN-1-1ycvq9t5vlacgpvnkx4jp59ytstzjgoylzmqciv9qfcquyh34o-c11p0e44m960y3ffxysthk78r 52.7.32.16:2377`

# Service
`docker service create --name nginx-swarm -p 80:80 nginx`