# Dificuldades e soluções

Possíveis dificuldades encontradas e abordagens de mitigação:

- Problema: Falha na instalação de pacotes gráficos por ausência de dependências.
  - Solução: usar imagem base que já contenha o desktop ou instalar pacotes necessários via script.

- Problema: Exposição direta sem TLS.
  - Solução: configurar proxy reverso (Caddy para Let's Encrypt) ou usar VPN.

- Problema: Performance em VPS com recursos limitados.
  - Solução: aumentar `shm_size`, alocar CPU/memória adequadas ou usar múltiplos hosts.
