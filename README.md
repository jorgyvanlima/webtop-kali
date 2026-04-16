# Webtop Kali — Ambiente Web Desktop para Estudos de Cibersegurança

Grupo D — Curso de Especialização em Sistemas de Segurança Integrada da Informação e Cibersegurança (UFPA)

Autores: Arienilce Sacramento Gonçalves, Clisciano Nascimento Souza, Flávio Alexandre Souza Nunes,
Jorgyvan Braga Lima, Józimo Azevedo Botelho, Osvaldo José Rodrigue Neves, Thiago Bitar Cruz,
Wallace Pablo Rocha da Cruz, Vinícius Antônio de Paula Valente

---

Abstract
--------
Este repositório contém a implementação, scripts e documentação de um ambiente Webtop baseado em
Kali Linux rodando via container Docker. O objetivo é fornecer um ambiente reprodutível para ensino,
pesquisa e exercícios práticos de cibersegurança, com foco em disponibilidade, reprodutibilidade e
segurança aplicada.

Motivação
----------
Ambientes de ensino e laboratório se beneficiam da padronização e isolamento providos por containers.
O Webtop permite que alunos acessem um desktop Kali completo via navegador, sem instalar nada localmente.

Estrutura do repositório
------------------------
- `docker-compose.yml` — definição do serviço `kali-webtop`.
- `scripts/` — scripts de instalação (`install-armitage.sh`) e pós-instalação (`post-install.sh`).
- `docs/` — arquivos com arquitetura, decisões técnicas, metodologia, segurança, dificuldades e sugestões futuras.
- `screenshots/` — local para evidências visuais.
- `LICENSE` — licença MIT.

Instalação (servidor Linux com Docker)
-------------------------------------
Pré-requisitos:

- Docker instalado e funcionando
- Docker Compose
- Porta `3001/tcp` liberada no firewall (ou proxy reverso configurado)

Procedimento:

1. Clone o repositório:

   git clone https://github.com/jorgyvanlima/webtop-kali.git
   cd webtop-kali

2. Revise `docker-compose.yml` e, se necessário, ajuste `PUID`, `PGID`, `TZ` e volumes.

3. Inicie os serviços:

   docker compose up -d

4. Acesse o Webtop: `https://<IP_DO_SERVIDOR>:3001` (substitua `<IP_DO_SERVIDOR>` pelo IP público ou nome DNS).

Configurar TLS e proxy reverso (recomendado)
-----------------------------------------
Para ter HTTPS com certificado válido, recomendamos colocar um proxy reverso (Caddy ou nginx) na frente do
serviço. Exemplo com Caddy (resumo):

1. Instalar Caddy no host.
2. Configurar Caddyfile com domínio apontando para o IP e rota para `localhost:3001`.
3. Caddy obtém certificados Let's Encrypt automaticamente.

Validação e testes
------------------
- Executar `docker logs kali-webtop` para verificar inicialização.
- Entrar no container (se necessário): `docker exec -it kali-webtop bash`.
- Atualizar pacotes: `apt update && apt upgrade -y`.
- Testar Metasploit: `msfconsole`.
- Testar Armitage (se instalado) e confirmar operação do PostgreSQL.

Boas práticas de segurança
--------------------------
- Use VPN/IP allowlist para restringir acesso.
- Não exponha portas administrativas ao público.
- Use imagens oficiais e mantenha atualizações.
- Gerencie credenciais com Docker secrets ou Vault.

Publicação no GitHub
--------------------
Se desejar que eu tente publicar diretamente deste ambiente, preciso que confirme qual método de autenticação
está configurado aqui:

- SSH (chave pública configurada em GitHub) — posso executar `git` e `git push`.
- HTTPS com PAT — você pode fornecer PAT aqui (não recomendado via chat); melhor você executar `git push` localmente.

Comandos sugeridos (usar SSH quando possível):

   git init
   git add .
   git commit -m "Initial commit: Webtop Kali"
   git branch -M main
   git remote add origin git@github.com:jorgyvanlima/webtop-kali.git
   git push -u origin main

Metodologia (resumo acadêmico)
-----------------------------
O trabalho adotou abordagem experimental aplicada: levantamento de soluções, implementação de protótipo
reprodutível com Docker Compose, validação por execução de ferramentas de pentest e documentação das
decisões técnicas e limitações.

Limitations (resumo)
--------------------
- Dependência de rede estável e latência adequada.
- Potenciais limitações gráficas dependendo do host.
- Necessidade de gestão de segurança para uso em produção.

Contribuições
-------------
- Ambiente Kali reprodutível e documentado.
- Scripts para instalação de ferramentas de pentest.
- Documentação acadêmica pronta para relatório/TCC.

Contato
-------
Para dúvidas, revisão de texto acadêmico, geração de diagrama de arquitetura ou tentativa de push para o GitHub,
responda neste chat indicando como prefere autenticar o push (SSH/HTTPS) e se quer que eu tente o envio direto.
