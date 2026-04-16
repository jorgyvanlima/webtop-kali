# Arquitetura do Webtop Kali

Visão geral:

- O Webtop roda dentro de um container Docker, fornecendo um ambiente gráfico (desktop) acessível via browser.
- A imagem base sugerida é mantida por LinuxServer.io, reduzindo a superfície de manutenção.
- Um proxy reverso (nginx/Caddy) pode ser usado para TLS, autenticação e roteamento.

Componentes:

- Container `kali-webtop`: ambiente Kali com desktop e serviços necessários.
- Banco de dados (PostgreSQL) dentro do container ou serviço separado para Metasploit.
- Proxy reverso fora do container para fornecer HTTPS válido e regras de segurança.

Rede e portas:

- Porta principal exposta: `3001/tcp` (Webtop)
- Recomenda-se bloquear acesso por IP e abrir somente para redes confiáveis ou via VPN.

Persistência:

- Volumes mapeados para `./data/config` preservam configurações e dados entre reinícios.
