#!/usr/bin/env bash
set -euo pipefail

echo "[+] Ajustes pós-instalação: permissões e limpeza"

# Exemplo: criar diretório de logs e ajustar permissões
mkdir -p /var/log/webtop-kali || true
chown -R root:root /var/log/webtop-kali || true

echo "[+] Ajustando fuso horário (opcional)"
timedatectl set-timezone America/Belem || true

echo "[+] Limpando cache de pacotes"
apt-get clean || true

echo "[+] Pós-instalação concluída"
