# Decisões técnicas

1. Uso de imagem oficial LinuxServer.io

- Justificativa: imagens mantidas por comunidade/organizadas reduzem risco e custo de manutenção.

2. Uso de Docker Compose

- Permite versionamento da configuração e reprodutibilidade para ambiente de laboratório.

3. Não construir Dockerfile customizado (quando possível)

- Evita responsabilidade por manutenção e vulnerabilidades introduzidas por configurações incorretas.

4. Exposição de portas e segurança

- Decidiu-se expor `3001` para compatibilidade com a instância atual; reforçar com proxy TLS e firewall.
