# Orquestração e Gestão Multiusuário para Webtop Kali

Este documento apresenta um estudo das opções de orquestração e gestão para suportar o modelo recomendado de "um container por usuário" no projeto Webtop Kali. Descreve alternativas, arquitetura sugerida, trade‑offs, fluxo de provisionamento e recomendações práticas para inclusão na dissertação.

## Problema a resolver

O objetivo é permitir que múltiplos alunos/usuários usem instâncias Kali isoladas simultaneamente, com provisionamento automático, roteamento web e limpeza de recursos ao final da sessão.

## Opções de orquestração

1) Docker Compose (escala manual / pequeno porte)

- Descrição: manter múltiplos serviços configurados em um `docker-compose.yml` (cada serviço representando um container de usuário) ou gerar arquivos compose dinamicamente.
- Vantagens: simplicidade, baixo overhead, fácil para demonstração acadêmica.
- Limitações: escalabilidade limitada, gerenciamento manual de muitos serviços, sem agendamento automático.
- Uso recomendado: laboratórios com poucas sessões concorrentes (até ~10) e administração manual/semiautomática.

2) Docker Swarm (orquestração leve)

- Descrição: orquestrador integrado ao Docker que permite deploy de serviços em cluster, load‑balancing e escala via `docker service scale`.
- Vantagens: mais escalável que Compose, integração direta com Docker Engine.
- Limitações: ecossistema menor que Kubernetes; menos recursos avançados.
- Uso recomendado: ambientes intermédios com necessidade de escala moderada sem complexidade do Kubernetes.

3) Kubernetes (recomendado para produção/escala)

- Descrição: orquestrador padrão da indústria para deploy e gestão de containers; permite autoscaling, tolerâncias, políticas de rede e operadores customizados.
- Vantagens: escalabilidade, APIs para provisionamento dinâmico, suporte a Ingress controllers (Traefik, Nginx), ResourceQuota, e integração com ferramentas de CI/CD.
- Limitações: curva de aprendizado, overhead de infraestrutura.
- Padrão de implantação: cada sessão de usuário é um `Pod` (ou Deployment) com limits/requests; usar `PersistentVolumeClaim` para dados persistentes por usuário.

4) Soluções especializadas (Kasm Workspaces, Open source alternatives)

- Kasm Workspaces: solução pronta para Webtop multiusuário — orquestra provisionamento de containers por sessão, autenticação e UI.
- Apache Guacamole: gateway de portas para VNC/RDP/SSH com UI, pode ser usado como cliente web conectado a containers provisionados por outro sistema.
- Vantagem: menor esforço de integração; Kasm fornece políticas, audit logs e limpeza automática.

## Arquitetura sugerida (nível médio)

- Frontend: Gateway/Portal Web com autenticação (OAuth2/SSO) — fornece login e seleciona/solicita sessão.
- Orquestrador: Kubernetes (ou Swarm para escala reduzida) — cria um Pod/container por sessão com a imagem Kali.
- Proxy reverso / Ingress: Traefik ou Nginx Ingress Controller — roteia subdomínios ou caminhos para containers de sessão; suporta TLS e certificados automáticos.
- Broker de sessão: componente leve que gerencia o lifecycle (criar, garantir readiness, expor endpoint, encerrar) — pode ser um pequeno serviço em Python/Go ou usar API do Kasm.
- Armazenamento: PVC por usuário (se precisar persistência) ou volumes efêmeros para sessões temporárias.

Fluxo simplificado:

1. Usuário autentica no Portal.
2. Portal solicita criação de sessão ao Broker.
3. Broker cria um Pod no Kubernetes com labels do usuário e configura Ingress/Route.
4. Assim que a sessão fica pronta, broker retorna URL (ex.: `https://kali.example.com/user123`).
5. Ao logout/timeout, broker destrói o Pod e libera recursos.

## Requisitos operacionais e boas práticas

- Limitar recursos por sessão (`cpu`, `memory`) para evitar noisy neighbors.
- Usar `liveness` e `readiness` probes para garantir que a sessão esteja funcional antes de expor o endpoint.
- Implementar policy de TTL/garantia de limpeza (pod eviction após X minutos ociosos).
- Registrar logs e auditoria (quem iniciou sessão, IP, tempo de duração).
- Gerenciar imagens com tags imutáveis e pipelines de construção (CI) para controle de versão da imagem base.

## Roteamento e TLS

- Usar Ingress + Let's Encrypt (via cert-manager) ou Traefik para TLS automático.
- Recomenda-se usar subdomínios por usuário (`user123.kali.example.com`) ou caminhos com tokens curtos; subdomínios facilitam isolamento de cookies e políticas.

## Segurança

- Não expor portas VNC diretamente ao público; sempre encapsular via proxy com autenticação.
- Isolar redes de containers e aplicar políticas de network (Kubernetes NetworkPolicy) para limitar acessos.
- Usar secrets manager para credenciais (não commitar em Git).

## Comparação resumida e recomendação

- Desenvolvimento / prova de conceito: `docker-compose` com scripts para criar múltiplos containers (rápido).
- Ambiente acadêmico com número moderado de usuários: `Docker Swarm` ou k8s local (k3s).
- Produção ou laboratório com muitos usuários: `Kubernetes + Broker custom` ou `Kasm Workspaces` (se quiser solução pronta com suporte empresarial).

Recomendação para este projeto de pós‑graduação: documentar duas opções e implementar a prova de conceito com `docker-compose` multiusuário (para demonstração), enquanto descreve a arquitetura Kubernetes + Ingress + Broker como solução escalável e parte das futuras implementações (capítulo de trabalho futuro).

## Itens a incluir no repositório (sugestão prática)

- `docs/orquestracao.md` (este arquivo).
- `examples/docker-compose.multi.yml` — exemplo didático criando 2‑3 containers Kali mapeados em portas distintas.
- `examples/broker/README.md` — esboço de como implementar um pequeno broker que usa `kubectl`/K8s API para criar sessões.
- `infra/Caddyfile` ou `infra/traefik.yml` — exemplo mínimo de proxy reverso para TLS.

---

Se desejar, posso: (a) gerar o `examples/docker-compose.multi.yml` e commitar; (b) esboçar o Broker (ex.: `broker.py`) que provisiona pods via `kubectl`/K8s API; ou (c) preparar um capítulo detalhado para a dissertação comparando as soluções.
