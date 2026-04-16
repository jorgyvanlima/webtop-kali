# Segurança

Princípios adotados:

- Minimizar a superfície de ataque usando imagens oficiais e atualizações regulares.
- Evitar exposição desnecessária: usar VPN/proxy reverso para acessar o Webtop.
- Separar serviços críticos (ex.: banco de dados) quando necessário.

Recomendações práticas:

- Aplicar regras de firewall (GCP: regras de firewall para a VPC) liberando apenas IPs/portes necessários.
- Configurar autenticação forte para quaisquer painéis administrativos.
- Monitorar logs e atualizações de segurança da imagem base.

Considerações sobre dados sensíveis

- Não manter user credentials em repositório público.
- Usar secrets management (Docker secrets, vault, GitHub Secrets) para credenciais em automação.
