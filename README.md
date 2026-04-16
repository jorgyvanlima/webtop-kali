# Webtop Kali — Repositório Técnico e Artigo

Projeto do Grupo D — Especialização em Sistemas de Segurança Integrada da Informação e Cibersegurança (UFPA).

Este repositório contém todos os artefatos para reproduzir um Webtop Kali (desktop Kali via navegador) orientado a ensino e pesquisa.

Principais itens
----------------
- `docs/webtop-kali.md` — Documento principal em formato de artigo técnico (introdução, metodologia, arquitetura, segurança, orquestração, resultados, conclusão).
- `docker-compose.yml` — Definição POC do serviço `kali-webtop`.
- `scripts/` — Scripts de instalação e pós‑instalação (`install-armitage.sh`, `post-install.sh`).
- `docs/orquestracao.md` — Estudo sobre orquestração (Compose, Swarm, Kubernetes, Kasm).
- `docs/limitacoes-multiusuario.md` — Limitação single‑seat e soluções.
- `docs/portainer.md` — Guia de instalação e uso do Portainer como painel de gestão.

Objetivo deste README
----------------------
Fornecer instruções claras para iniciar o ambiente rapidamente e apontar para o documento técnico completo (`docs/webtop-kali.md`) para avaliação acadêmica.

Instalação rápida
-----------------
Pré‑requisitos mínimos:

- Host Linux com Docker e Docker Compose instalados.
- Acesso SSH e privilégios de administrador.

Comandos básicos:

```bash
git clone https://github.com/jorgyvanlima/webtop-kali.git
cd webtop-kali
docker compose up -d
```

Verificações úteis
------------------

- Logs: `docker compose logs -f`
- Entrar no contêiner: `docker exec -it kali-webtop bash`
- Status dos containers: `docker ps`

Como usar a documentação acadêmica
----------------------------------
Abra `docs/webtop-kali.md` para leitura em formato artigo. O documento contém: introdução, revisão bibliográfica, detalhamento de arquitetura, procedimentos de deploy, análise de orquestração, segurança, validação experimental, limitações, conclusão e referências.

Publicação e colaboração
-------------------------
O repositório está pronto para push no GitHub (já configurado). Para contribuir: clone, crie uma branch com sua feature, e abra um Pull Request.

Suporte e próximas etapas
-------------------------
Posso:
- Converter `docs/webtop-kali.md` em PDF (Pandoc) e commitar o artefato.
- Gerar `examples/docker-compose.multi.yml` para POC multiusuário.
- Esboçar um broker para Kubernetes (`examples/broker/`).

Escolha uma ação ou peça revisão do documento técnico.

---
Licença: MIT. Consulte `LICENSE`.
