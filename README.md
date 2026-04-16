
# Webtop Kali — Guia Técnico e Operacional

Projeto do Grupo D — Especialização em Sistemas de Segurança Integrada da Informação e Cibersegurança (UFPA).

Este README é um manual técnico de referência para operação, replicação e avaliação do ambiente Webtop Kali presente neste repositório. Para leitura acadêmica e versões formais do trabalho, consulte `docs/webtop-kali.md` (artigo técnico).

Conteúdo do repositório
-----------------------
- `docker-compose.yml` — configuração POC para executar a instância Kali Webtop.
- `scripts/` — scripts de automação: `install-armitage.sh`, `post-install.sh`.
- `docs/` — documentação técnica e acadêmica: `webtop-kali.md`, `orquestracao.md`, `limitacoes-multiusuario.md`, `portainer.md`.
- `examples/` — (opcional) exemplos práticos (multi-compose, brokers, infra).
- `screenshots/` — evidências visuais para relatório.
- `LICENSE` — MIT.

Sumário técnico rápido
----------------------
- Requisitos: Docker Engine (20.x+), Docker Compose v2, acesso root/administrador.
- Serviço principal exposto: `3001/tcp` (Webtop). Portainer no host: `9000/9444` (HTTP/HTTPS) conforme instalação.

Instalação e deploy (passo a passo)
----------------------------------
1) Preparar host (exemplo Debian/Ubuntu):

```bash
sudo apt update && sudo apt install -y ca-certificates curl gnupg lsb-release
curl -fsSL https://get.docker.com -o get-docker.sh && sudo sh get-docker.sh
sudo apt-get install -y docker-compose-plugin
```

2) Clonar o repositório e iniciar stack:

```bash
git clone https://github.com/jorgyvanlima/webtop-kali.git
cd webtop-kali
docker compose up -d
```

3) Verificações pós‑deploy:

```bash
docker compose ps
docker compose logs -f kali-webtop
docker exec -it kali-webtop bash
```

Configuração recomendada de monitoramento e gestão
--------------------------------------------------
- Instalar Portainer para gestão via UI (ex.: `docker run -d --name portainer -p 9000:9000 -p 9444:9443 -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:latest`).
- Registrar métricas (Prometheus + cAdvisor) e configurar alertas de recursos.

Rede e segurança (produtor)
---------------------------
- Usar proxy reverso (Caddy/Traefik/Nginx) com TLS automático (Let's Encrypt via cert-manager ou Caddy integrado).
- Restringir acesso ao Portainer e ao Webtop por IP allowlists ou VPN. No GCP, usar firewall da VPC.
- Nunca versionar segredos; use Docker secrets ou um vault.
- Evitar exposição direta de `docker.sock` sem controles; executar Portainer com agent quando preciso gerenciar múltiplos hosts.

Arquitetura e orquestração
-------------------------
- POC: `docker-compose` com um serviço por instância.
- Escala: Kubernetes (k8s) com broker para provisionamento dinâmico por sessão; Ingress (Traefik/Nginx) para roteamento; PVCs para persistência opcional.
- Alternativa pronta: Kasm Workspaces para provisionamento de sessões com autenticação e limpeza automática.

Operação em laboratório (workflow)
---------------------------------
1. Instrutor cria template/stack no Portainer.
2. Para cada aluno, lança uma instância a partir do template (mapeando port, volume e labels).
3. Durante a aula, monitorar consumo e logs; ao fim, remover stacks ou automatizar limpeza via TTL.

Testes e validação
------------------
- Executar `apt update` dentro do container.
- Iniciar `msfconsole` e validar conectividade com PostgreSQL.
- Reproduzir conflito de portas (ex.: Portainer vs outro serviço) e validar mitigação (mudar mapeamento host:container).

CI/CD e geração de artefatos
---------------------------
- Recomenda-se adicionar um workflow GitHub Actions que execute: lint do Markdown, build de imagem (se houver Dockerfile), scans de segurança (Trivy) e geração de PDF do artigo (Pandoc).

Contribuição e padrões
----------------------
- Use branches `feature/*` e abra PRs para revisão.
- Documente mudanças em `CHANGELOG.md` (semântica simples).

Contato e suporte
-----------------
Abra uma issue no repositório para bugs ou discussões de melhoria. Para suporte operacional, descreva o host, versão Docker e logs relevantes.

Licença
-------
MIT — ver arquivo `LICENSE`.
