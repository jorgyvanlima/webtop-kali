# Limitação técnica: Sessão gráfica única por container e soluções

Resumo
-----
Este documento explica uma limitação arquitetural observada no protótipo Webtop Kali: a existência de uma sessão gráfica única por container (single‑user graphical session) que impede o suporte confiável a múltiplos usuários concorrentes na mesma instância. Descrevemos o problema, por que ele ocorre, sua caracterização como limitação (não bug), e apresentamos soluções profissionais e recomendações para o projeto de dissertação.

1. O que ocorre tecnicamente
---------------------------
No modelo atual do projeto, cada container mantém um único servidor gráfico (X11/Wayland/KasmVNC) e uma única sessão associada a um único `DISPLAY`. Quando dois ou mais clientes tentam se conectar simultaneamente à mesma instância, o servidor gráfico e o backend WebVNC podem trocar o foco da sessão para o último cliente conectado. Esse comportamento gera:

- perda de atualização da tela (tela preta);
- congelamento ou perda de controle da sessão;
- desconexões intermitentes para usuários anteriores.

2. Bug ou limitação conhecida?
-----------------------------
Trata‑se de uma limitação arquitetural conhecida de soluções simples baseadas em VNC/Web Desktop. Projetos e imagens públicas (ex.: imagens LinuxServer.io com VNC) operam por design em modo single‑seat — isto é, uma sessão por container. A documentação upstream costuma indicar esse modelo de uso; portanto, o comportamento observado é esperado e não um defeito de implementação do projeto.

3. É possível habilitar múltiplos usuários no mesmo container?
----------------------------------------------------------
Resposta curta: não de forma segura e reprodutível.

Motivo técnico:

- existe apenas um `DISPLAY` e um servidor gráfico ativo;
- múltiplas sessões concorrentemente no mesmo servidor gráfico não garantem isolamento e provocam condições de corrida e perda de sessão;
- muitas aplicações gráficas pressupõem um ambiente de usuário único (home, sockets, DBus, permissões).

4. Soluções profissionais e recomendações
--------------------------------------

4.1. Recomendada — 1 container por usuário (escala horizontal)

Descrição: provisionar uma instância do mesmo container para cada usuário; cada container expõe sua própria porta (ou é roteado por um gateway/proxy) e executa uma sessão gráfica isolada.

Vantagens:
- isolamento total entre usuários;
- fácil auditoria e controle de recursos;
- compatível com pipelines de provisionamento (Docker Compose, Ansible, Terraform).

Exemplo simplificado de `docker-compose.yml` multiusuário (ilustrativo):

```yaml
version: '3.9'
services:
  kali-userA:
    image: lscr.io/linuxserver/kali-linux:latest
    ports: ["3001:3001"]
    volumes: ["./data/userA:/config"]
  kali-userB:
    image: lscr.io/linuxserver/kali-linux:latest
    ports: ["3002:3001"]
    volumes: ["./data/userB:/config"]
```

4.2. Solução enterprise — Plataformas como Kasm Workspaces

Descrição: Kasm e soluções equivalentes implementam um gateway e orquestram containers por sessão, oferecendo autenticação, provisionamento sob demanda, limpeza de trabalho, e escalonamento.

Vantagens:
- Multiusuário real com isolamento forte;
- integração com autenticação (LDAP/SSO);
- gerenciamento centralizado de imagens e políticas de segurança.

4.3. Alternativa — Máquinas virtuais por usuário

Descrição: provisionar VMs (mais pesadas) ao invés de containers quando for necessária maior compatibilidade com sessões gráficas completas.

5. Como documentar isso na dissertação e no repositório
-----------------------------------------------------
Sugestão de inclusão no `docs/` do repositório e na seção de limitações da dissertação:

1. Explicar tecnicamente o que causa a limitação (DISPLAY único, single‑seat).
2. Apresentar experimentos que reproduzam o problema (relatar cenário de teste: dois navegadores tentando acessar a mesma URL; evidências: logs, screenshot de tela preta).
3. Fornecer as soluções e justificar a opção escolhida para o projeto (ex.: optar por 1 container/usuário por critérios de segurança e escalabilidade).
4. Incluir uma tabela comparativa de arquiteturas (ver `docs/webtop-kali.md`).

6. Texto pronto para inserir no relatório (sugestão formal)
--------------------------------------------------------
> Durante a validação experimental, identificou‑se uma limitação arquitetural relevante: o protótipo utiliza um modelo de sessão gráfica única por container. Tal configuração, comum em imagens WebVNC e implementações simplificadas, não suporta a presença de múltiplos clientes concorrentes sem degradação da experiência (perda de sessão, troca de foco e desconexões). Reconhece‑se que este comportamento é consequência do modelo single‑seat adotado e não de um defeito de implementação. Para usos em contexto de laboratório multiusuário recomenda‑se o provisionamento de um container por usuário ou a adoção de plataformas especializadas (por exemplo, Kasm Workspaces), que orquestram containers por sessão e oferecem mecanismos de autenticação, isolamento e escalonamento.

7. Referências técnicas adicionais
---------------------------------
- Documentação LinuxServer.io — uso e limitações de imagens com VNC
- Kasm Technologies — arquitetura e whitepapers
- Artigos sobre gerenciamento de sessões gráficas e isolamento em containers
