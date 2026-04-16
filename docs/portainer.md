# Portainer: Gestão Web de Containers para o Webtop Kali

Visão resumida
--------------
Portainer é uma interface web leve para gestão de ambientes Docker (e Kubernetes). No contexto do projeto Webtop Kali, o Portainer pode ser usado como painel de operações para:

- provisionar e monitorar containers Kali por usuário;
- gerir stacks e templates para criar rapidamente instâncias padronizadas;
- inspecionar logs, recursos e rede dos containers;
- aplicar políticas básicas de RBAC e endpoints.

Endereço de acesso no ambiente atual
-----------------------------------
HTTP: http://35.239.158.122:9000/
HTTPS (Portainer reconfigurado): https://35.239.158.122:9444/

Instalação recomendada (recapitulando e ajustando porta)
-------------------------------------------------------
Remova container que falhou (se existir):

```bash
docker rm -f portainer || true
```

Subir Portainer em portas não conflitantes (exemplo recomendado):

```bash
docker run -d \
  --name portainer \
  --restart unless-stopped \
  -p 9000:9000 \
  -p 9444:9443 \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v portainer_data:/data \
  portainer/portainer-ce:latest
```

Por que usar `9444:9443` em vez de `9443:9443`?
- evita conflito se outro serviço já usa 9443 no host.

Como o Portainer pode ajudar no modelo "1 container por usuário"
-------------------------------------------------------------
1. Templates / Stacks
- Crie templates de stack com o mesmo `docker-compose` para Kali; os administradores podem disparar novas instâncias a partir do template.

2. Provisionamento rápido
- A UI do Portainer permite criar containers ou stacks via formulário, acelerando a criação de instâncias para alunos.

3. Monitoramento e Logs
- Visualização centralizada do uso de CPU/Memory, logs e estado dos containers, útil para troubleshooting em sala.

4. RBAC e equipes
- Configure usuários/teams e limites de acesso para permitir que instrutores administrem e estudantes apenas visualizem ou iniciem stacks predefinidos.

5. Endpoints múltiplos
- O Portainer pode gerir múltiplos endpoints Docker (hosts). Pode ser usado como painel central para vários nós que executam sessions Kali.

Fluxo de uso sugerido (laboratório com instrutor)
------------------------------------------------
1. Instrutor define um template/stack (Kali Webtop) com volume e limites de recursos.
2. Instrutor usa Portainer para lançar N instâncias (cada uma em porta distinta ou via proxy/ingress).
3. Cada instância recebe label `user=<nome>` e `session=<id>` para auditoria.
4. Ao final da aula, instrutor remove os stacks ou configura TTL para limpeza automática (scripts CRON).

Integração com orquestração
---------------------------
- Docker Compose: Portainer gerencia stacks Compose e é ótimo para POC e pequenas turmas.
- Docker Swarm / Kubernetes: Portainer suporta Swarm e oferece integração com K8s (a versão Portainer Business tem mais features); para produção, usar Kubernetes + broker é mais recomendado.

Segurança e boas práticas
------------------------
- Habilitar TLS no Portainer (para o endpoint HTTPS) e usar autenticação forte.
- Proteger acesso ao painel (IP allowlist, VPN ou firewall na GCP).
- Não expor `docker.sock` sem controles: ele dá controle total do host; use Gateways/agent quando possível.
- Configurar backups de `portainer_data`.

Limitações do Portainer no contexto multiusuário
-----------------------------------------------
- Não é, por si só, um orquestrador de sessões por usuário — facilita gerenciamento, mas o provisionamento dinâmico em escala exige orquestrador (Swarm/K8s) ou um broker extra.
- Para workflows de auto‑provisionamento por login, combine Portainer com scripts/CI ou use Kasm/solução dedicada.

Exemplo prático: template de stack simplificado (usar em Portainer > Templates)

```yaml
version: '3.9'
services:
  kali-webtop:
    image: lscr.io/linuxserver/kali-linux:latest
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=America/Belem
    ports:
      - "3001:3001"
    volumes:
      - ./data/{{USER}}:/config
    restart: unless-stopped
```

Observação: no template, substituir `{{USER}}` por identificador de usuário; ao usar Portainer templates, você pode parametrizar campos.

Conclusão e recomendação para a dissertação
-------------------------------------------
Inclua o Portainer como solução web operacional no capítulo de implantação: descreva o conflito de portas encontrado, a decisão de realocação (9000/9444), e apresente Portainer como ferramenta de gestão para o laboratório, ressaltando que, em escala, deve ser complementado por orquestração (k8s) ou por soluções especializadas (Kasm).
