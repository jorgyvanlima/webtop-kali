#!/usr/bin/env bash
set -euo pipefail

echo "[+] Atualizando repositórios e pacotes"
apt-get update && apt-get upgrade -y

echo "[+] Instalando dependências básicas"
apt-get install -y curl gnupg2 wget lsb-release build-essential

echo "[+] Instalando PostgreSQL (dependência do Metasploit)"
apt-get install -y postgresql postgresql-contrib

echo "[+] Instalando Metasploit Framework e Armitage"
apt-get install -y metasploit-framework armitage || true

echo "[+] Iniciando e habilitando PostgreSQL"
systemctl enable --now postgresql || true

if command -v msfdb >/dev/null 2>&1; then
  echo "[+] Inicializando msfdb (se aplicável)"
  msfdb init || true
fi

echo "[+] Instalação concluída. Verifique logs para eventuais erros."
