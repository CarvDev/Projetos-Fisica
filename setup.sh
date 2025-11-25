#!/bin/bash

# Definição de cores para mensagens
VERMELHO='\033[0;31m'
VERDE='\033[0;32m'
AMARELO='\033[1;33m'
SEM_COR='\033[0m'

# --- CONFIGURAÇÃO ---
REPO_URL="https://github.com/CarvDev/Projetos-Fisica"
# --------------------

echo -e "${AMARELO}Iniciando configuração do ambiente...${SEM_COR}"

# 1. Verifica se o Git está instalado
if ! command -v git &> /dev/null; then
    echo -e "${VERMELHO}ERRO: O Git não está instalado.${SEM_COR}"
    echo "Por favor, instale-o rodando o seguinte comando:"
    echo -e "${AMARELO}sudo apt install git -y${SEM_COR}"
    exit 1
fi

# 2. Verifica se o módulo venv do Python 3 está instalado
# No Linux Mint/Ubuntu, o python3 vem instalado, mas o módulo venv (python3-venv) muitas vezes é separado.
if ! dpkg -s python3-venv &> /dev/null; then
    echo -e "${VERMELHO}ERRO: O pacote python3-venv não está instalado.${SEM_COR}"
    echo "O sistema precisa deste pacote para criar ambientes virtuais."
    echo "Por favor, instale-o rodando o seguinte comando:"
    echo -e "${AMARELO}sudo apt install python3-venv -y${SEM_COR}"
    exit 1
fi

# 3. Clona o repositório
# Extrai o nome do diretório a partir da URL (ex: projeto.git -> projeto)
DIR_NAME=$(basename "$REPO_URL" .git)

if [ -d "$DIR_NAME" ]; then
    echo -e "${AMARELO}O diretório '$DIR_NAME' já existe. Pulando etapa de clonagem.${SEM_COR}"
else
    echo "Clonando repositório..."
    git clone "$REPO_URL"
    if [ $? -ne 0 ]; then
        echo -e "${VERMELHO}Falha ao clonar o repositório. Verifique a URL.${SEM_COR}"
        exit 1
    fi
fi

# 4. Entra no diretório clonado
cd "$DIR_NAME" || { echo -e "${VERMELHO}Falha ao entrar no diretório.${SEM_COR}"; exit 1; }

# 5. Cria e inicializa o ambiente venv
if [ ! -d "venv" ]; then
    echo "Criando ambiente virtual (venv)..."
    python3 -m venv venv
else
    echo "Ambiente virtual já existe."
fi

# Ativa o ambiente
source venv/bin/activate
echo -e "${VERDE}Ambiente virtual ativado.${SEM_COR}"

# 6. Instala as dependências
if [ -f "requirements.txt" ]; then
    echo "Instalando dependências..."
    pip install --upgrade pip
    pip install -r requirements.txt
    
else
    echo -e "${VERMELHO}ERRO: Arquivo requirements.txt não encontrado na raiz do repositório.${SEM_COR}"
fi

# 7. Inicia o Jupyter Notebook
echo -e "${VERDE}Iniciando Jupyter Notebook...${SEM_COR}"
jupyter notebook
