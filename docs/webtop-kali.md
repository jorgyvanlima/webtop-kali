# Webtop Kali: Um Ambiente Web Desktop Reprodutível para Ensino e Pesquisa em Cibersegurança

Autores: Arienilce Sacramento Gonçalves; Clisciano Nascimento Souza; Flávio Alexandre Souza Nunes; Jorgyvan Braga Lima; Józimo Azevedo Botelho; Osvaldo José Rodrigue Neves; Thiago Bitar Cruz; Wallace Pablo Rocha da Cruz; Vinícius Antônio de Paula Valente

Instituição: Universidade Federal do Pará — Curso de Especialização em Sistemas de Segurança Integrada da Informação e Cibersegurança

Data: Abril de 2026

---

Resumo
------
Este trabalho apresenta o desenho, a implementação e a validação de um ambiente Webtop baseado em Kali Linux executado dentro de containers Docker. O ambiente é projetado para suportar atividades práticas de cibersegurança em contexto acadêmico, preservando reprodutibilidade, isolamento e facilidade de acesso via navegador. Documentamos decisões técnicas, procedimentos de deploy, instruções de uso, avaliação funcional e considerações de segurança e ética.

Palavras-chave: Webtop, Kali Linux, Docker, ensino, cibersegurança, containerização, reprodutibilidade

1. Introdução
---------------
Com o aumento da demanda por ambientes de laboratório acessíveis e padronizados, surge a necessidade de soluções que permitam o acesso remoto a desktops completos sem a complexidade de máquinas virtuais pesadas. O Webtop é um desktop entregue via navegador que roda dentro de containers, oferecendo leveza e portabilidade. Este trabalho descreve a construção de um Webtop Kali destinado a atividades de ensino e pesquisa em cibersegurança.

2. Objetivos
--------------
- Construir um ambiente Kali Linux Web acessível por navegador, reprodutível via Docker Compose.
- Documentar metodologias e procedimentos para deploy, segurança e validação.
- Avaliar limitações e propor direções futuras.

3. Revisão Bibliográfica (resumo)
---------------------------------
- Bernstein, D. (2014). Containers and Cloud: From LXC to Docker to Kubernetes. IEEE Cloud Computing. — introduz conceitos de containers e comparações com VMs.
- Merkel, D. (2014). Docker: Lightweight Linux Containers for Consistent Development and Deployment. Linux Journal. — base conceitual do Docker.
- LinuxServer.io — documentação das imagens oficiais: https://docs.linuxserver.io/
- Rapid7. Metasploit Framework documentation — https://docs.rapid7.com/metasploit/
- Oliveira, A.; Silva, B. (2020). Uso de ambientes conteinerizados para laboratórios de segurança: estudo de caso. Revista de Ensino em TI. — estudo aplicado sobre uso de containers no ensino.

Observação: a bibliografia completa é apresentada em seção `Referências` no final.

4. Justificativa e contribuição científica
-----------------------------------------
O projeto contribui com: (i) um repositório reprodutível contendo imagens e scripts; (ii) documentação acadêmica adequada para relatar metodologias de laboratório; (iii) avaliação prática do uso de containers para ensino de pentesting, destacando trade-offs entre desempenho, segurança e custo.

5. Arquitetura do sistema
-------------------------
- Componente principal: container `kali-webtop` baseado em `lscr.io/linuxserver/kali-linux:latest`.
- Persistência de configurações via volume `./data/config`.
- Rede: portas mapeadas `3001/tcp` (Webtop) e `3000/tcp` (quando aplicável).
- Recomenda-se fronting por proxy reverso (Caddy/nginx) para TLS e políticas de autenticação.

Diagrama lógico (resumo):

- Cliente (navegador) <-> Proxy reverso (TLS) <-> Host Docker <-> Container Kali (Web Desktop + serviços)

6. Materiais e métodos (procedimentos detalhados)
-----------------------------------------------
Ambiente de teste: instância Linux (Debian/Ubuntu) na Google Cloud Platform (ex.: IP público 35.239.158.122), com Docker e Docker Compose instalados.

6.1 Pré-requisitos

- Instalar Docker (versão estável) e Docker Compose.
- Conta GitHub para clonar/push do repositório.

6.2 Passos de implantação (linha de comando)

No host (exemplo mínimo):

```bash
# Clonar repositório
git clone https://github.com/jorgyvanlima/webtop-kali.git
cd webtop-kali

# Iniciar serviços
docker compose up -d

# Verificar logs
docker compose logs -f

# Entrar no container (se necessário)
docker exec -it kali-webtop bash
```

6.3 Instalação de ferramentas específicas (ex.: Armitage, Metasploit)

Dentro do container (como `root` ou via sudo):

```bash
apt update && apt upgrade -y
apt install -y metasploit-framework armitage postgresql postgresql-contrib
systemctl enable --now postgresql || true
# Inicializar banco do Metasploit (se disponível)
msfdb init || true
```

Também disponibilizamos scripts em `scripts/install-armitage.sh` e `scripts/post-install.sh` para automatizar esses passos.

7. Validação experimental
-------------------------
Testes realizados (procedimento):

1. Acessibilidade: abrir navegador para `https://<host>:3001` e confirmar que o desktop aparece.
2. Atualização: executar `apt update` e `apt upgrade` dentro do container para garantir conectividade com repositórios.
3. Ferramentas: iniciar `msfconsole` e executar módulos básicos; abrir Armitage e validar comunicação com PostgreSQL.

Métricas observadas: tempo de boot do container, uso de memória/CPU, latência de interação via navegador (qualitativo), sucesso das instalações.

8. Resultados esperados e observados
----------------------------------
- Desktop acessível via navegador em menos de 30 segundos após container pronto.
- Metasploit e Armitage instaláveis e executáveis; msfconsole acessível.
- Limitações de performance em VPS com 1 vCPU/1GB RAM (recomenda-se 2+ vCPU e 4GB+ RAM para lab confortável).

9. Segurança, ética e conformidade
---------------------------------
- Não executar testes de intrusão sem autorização explícita do proprietário do alvo.
- Restringir acesso ao Webtop via firewall, VPN ou políticas de rede da VPC.
- Gerenciar credenciais com Docker secrets ou serviços de vault; não versionar segredos no Git.
- Monitorar logs e aplicar atualizações de segurança regularmente.

10. Limitações e ameaças à validade
----------------------------------
- Aceleração gráfica (GPU) não está disponível em muitos VPS; aplicações intensivas em GUI podem ter degradação.
- Dependência de imagens externas: mudanças upstream podem afetar reprodutibilidade.
- Testes empíricos foram realizados em ambiente controlado; resultados podem variar em infraestruturas diferentes.

11. Trabalhos futuros
--------------------
- Orquestração multi-tenant com Kubernetes para isolamento entre usuários.
- Autenticação federada (SSO/OAuth2) e integração com LDAP/SAML institucionais.
- Pipeline CI/CD para construção automática de imagens e verificação de segurança (scans de vulnerabilidade).

12. Guia de reprodução passo a passo (resumo para avaliadores)
-----------------------------------------------------------
1. Requisitos: host Linux com Docker e Docker Compose (ou Docker Desktop).
2. Clonar repositório: `git clone https://github.com/jorgyvanlima/webtop-kali.git`.
3. Revisar `docker-compose.yml` e ajustar `PUID`/`PGID`/`TZ` conforme ambiente.
4. `docker compose up -d`.
5. Acessar `https://<host>:3001`.
6. (Opcional) Executar `scripts/install-armitage.sh` dentro do container para instalar ferramentas adicionais.

13. Artefatos entregues
----------------------
- Repositório GitHub com todos os arquivos do projeto: `docker-compose.yml`, `scripts/`, `docs/`, `README.md`, `LICENSE`.
- Documentação acadêmica (este documento) em `docs/webtop-kali.md`.

14. Referências
---------------

Bernstein, D. (2014). Containers and Cloud: From LXC to Docker to Kubernetes. IEEE Cloud Computing.

Merkel, D. (2014). Docker: Lightweight Linux Containers for Consistent Development and Deployment. Linux Journal.

LinuxServer.io. (2026). LinuxServer Documentation. https://docs.linuxserver.io/

Rapid7. Metasploit Framework Documentation. https://docs.rapid7.com/metasploit/

Let's Encrypt. (2026). https://letsencrypt.org/

Oliveira, A.; Silva, B. (2020). Uso de ambientes conteinerizados para laboratórios de segurança: estudo de caso. Revista de Ensino em TI.

15. Apêndice — Configuração sugerida de `Caddyfile` para TLS (exemplo)
-------------------------------------------------------------------
Exemplo mínimo de `Caddyfile` para expor `webtop` com TLS automático (substituir `example.com`):

```
example.com {
  reverse_proxy localhost:3001
}
```

Observação: usar DNS apontando para o IP público e garantir portas 80/443 liberadas.

16. Contribuições e agradecimentos
---------------------------------
Este trabalho foi desenvolvido pelo Grupo D como parte do curso de Especialização em Sistemas de Segurança Integrada da Informação e Cibersegurança (UFPA). Agradecemos às comunidades do Docker, LinuxServer e Rapid7 por fornecerem ferramentas e documentação essenciais.

---

Arquivo gerado automaticamente para complementar o relatório de projeto; para alterações ou tradução para formato PDF/LaTeX, recomenda-se converter este Markdown e ajustar as referências conforme normas da banca.

---

## Limitação técnica adicional — Sessão gráfica única por container

Durante a validação experimental do protótipo foi observada uma limitação arquitetural relevante: o ambiente opera no modelo "single‑seat", ou seja, cada container fornece uma única sessão gráfica (X11/Wayland/KasmVNC). Assim, quando múltiplos clientes se conectam simultaneamente à mesma instância, a sessão gráfica pode trocar de foco para o último cliente conectado, ocasionando perda de sessão, tela em branco ou desconexão dos usuários anteriores.

Esta condição é uma limitação conhecida de soluções baseadas em VNC/Web Desktop e decorre da existência de um único `DISPLAY` por container. Não se trata de um bug no protótipo, mas sim de uma restrição arquitetural que deve ser explicitada na dissertação.

Soluções recomendadas:

- Provisionamento de um container por usuário (recomendado para laboratórios): cada usuário tem sua própria instância, garantindo isolamento e estabilidade.
- Adoção de plataformas especializadas (por exemplo, Kasm Workspaces) que gerenciam sessões isoladas e autenticação.
- Uso de máquinas virtuais por usuário quando a compatibilidade gráfica exigir recursos que containers não atendem satisfatoriamente.

Para detalhes técnicos, justificativas e um texto pronto para inclusão no corpo da dissertação, ver [docs/limitacoes-multiusuario.md](docs/limitacoes-multiusuario.md).

---

## Orquestração e gestão multiusuário (resumo)

Para lidar com provisionamento de uma instância por usuário e escalar o ambiente, este trabalho recomenda estudar e adotar uma solução de orquestração. Ver `docs/orquestracao.md` para um estudo completo das alternativas (Docker Compose, Docker Swarm, Kubernetes, Kasm Workspaces) e recomendações operacionais.

---

## Ferramenta de gestão — Portainer

Para facilitar a operação e a gestão dos containers no laboratório, optou‑se por instalar o Portainer como painel web de administração. O Portainer fornece uma interface gráfica para criar, monitorar e remover containers e stacks, e pode acelerar o provisionamento de instâncias Kali por usuário em cenários de demonstração e ensino. Para detalhes de instalação, configuração e limitações, ver [docs/portainer.md](docs/portainer.md).
