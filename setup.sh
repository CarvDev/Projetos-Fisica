#!/bin/bash

# Definição de cores para mensagens
VERMELHO='\033[0;31m'
VERDE='\033[0;32m'
AMARELO='\033[1;33m'
SEM_COR='\033[0m'

# --- CONFIGURAÇÃO ---
REPO_URL="https://github.com/CarvDev/Projetos-Fisica"
DEPENDENCIAS=("notebook" "numpy" "matplotlib")
# --------------------

echo -e "${AMARELO}Iniciando configuração do ambiente...${SEM_COR}"

# 1. Verifica se o módulo venv do Python 3 está instalado
if ! dpkg -s python3-venv &> /dev/null; then
    echo -e "${VERMELHO}ERRO: O pacote python3-venv não está instalado.${SEM_COR}"
    echo "O sistema precisa deste pacote para criar ambientes virtuais."
    echo "Por favor, instale-o rodando o seguinte comando:"
    echo -e "${AMARELO}sudo apt install python3-venv -y${SEM_COR}"
    exit 1
fi

# 2. Cria e inicializa o ambiente venv
if [ ! -d "venv" ]; then
    echo "Criando ambiente virtual (venv)..."
    python3 -m venv venv
else
    echo "Ambiente virtual já existe."
fi

# Ativa o ambiente
source venv/bin/activate
echo -e "${VERDE}Ambiente virtual ativado.${SEM_COR}"

# 3. Verifica e Instala Dependências
echo -e "${AMARELO}Instalando/verificando dependências...${SEM_COR}"
# Atualiza o pip primeiro
pip install --upgrade pip > /dev/null 2>&1

# Verifica se os pacotes já estão instalados
for pacote in "${DEPENDENCIAS[@]}"; do
    # 'pip show' retorna erro se o pacote não existir
    if ! pip show "$pacote" > /dev/null 2>&1; then
    	# Instala o pacote, se não existir
        echo -e "  ${AMARELO}[..] Instalando $pacote...${SEM_COR}"
        pip install "$pacote"
        if [ $? -eq 0 ]; then
             echo -e "  ${VERDE}[OK] $pacote instalado com sucesso.${SEM_COR}"
        else
             echo -e "  ${VERMELHO}[ERRO] Falha ao instalar $pacote. Por favor, verifique sua conexão com a internet.${SEM_COR}"
             exit 1
        fi
    fi
done
echo -e "${VERDE}Todas as dependências estão OK${SEM_COR}"
   
# 4. Inicia o Jupyter Notebook
echo -e "${VERDE}Iniciando Jupyter Notebook...${SEM_COR}"
jupyter notebook
