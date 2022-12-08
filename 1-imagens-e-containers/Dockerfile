# Imagem base
# Eh possivel especificar a versao. Ex.: node:14
FROM node

# Diretorio da aplicacao
WORKDIR /src

# Copiar os arquivos "package-lock.json" e "package.json" para o diretorio /src
COPY package*.json .

# Instalar pacotes do projeto
RUN npm install

# Copiar os demais arquivos para o diretorio /src
COPY . .

# Expor porta 3000
EXPOSE 3000

# Inicializar a aplicacao
CMD ["node", "app.js"]