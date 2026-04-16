# Metodologia

Abordagem experimental aplicada:

1. Levantamento de alternativas (VM vs container, imagens disponíveis).
2. Implementação de protótipo com Docker Compose para garantir reprodutibilidade.
3. Validação através de execução de ferramentas clássicas (Metasploit, Armitage) e testes de atualização (`apt`).
4. Documentação acadêmica e registro das limitações e decisões técnicas.

Critérios de avaliação:

- Disponibilidade do desktop via navegador.
- Capacidade de instalar/atualizar pacotes via APT.
- Integração de serviços (PostgreSQL) necessários para ferramentas de pentest.
