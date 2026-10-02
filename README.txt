OPERAÇÃO ELEIÇÕES 2026 — CPR I

VERSÃO SEM LOGIN PARA O MILITAR

1. SUPABASE
- Crie um projeto no Supabase.
- Abra SQL Editor.
- Execute todo o arquivo schema.sql.
- O script cria a tabela ocorrencias e o bucket de fotografias.

2. INDEX.HTML
Abra o index.html e substitua:
SUPABASE_URL = 'COLOQUE_AQUI_SUA_URL_SUPABASE';
SUPABASE_ANON_KEY = 'COLOQUE_AQUI_SUA_ANON_KEY';

Altere também:
ADMIN_PASSWORD='CPRI-2026';
para um código definido pela administração.

3. FLUXO
- O militar entra no site e clica em Lançar ocorrência.
- Não há login.
- O militar informa nome, matrícula, posto/graduação, equipe e ocorrência.
- Ao enviar, o sistema gera um protocolo CPRI-AAAA-XXXXXX.
- As fotos são enviadas para o Storage do Supabase.
- O ADM entra em Painel Administrativo e informa o código.
- O painel mostra estatísticas, gráficos, filtros, detalhes, fotos, mapa, CSV e impressão/PDF.

4. RELATÓRIO
- O botão Excel/CSV baixa os registros filtrados em formato compatível com Excel.
- O botão Relatório/PDF abre a impressão do navegador. Escolha "Salvar como PDF".

5. SEGURANÇA — IMPORTANTE
Esta versão foi feita para ser simples e sem login do militar. O código do ADM é um bloqueio de interface, não uma autenticação real de banco. Como o navegador usa a ANON KEY, um usuário tecnicamente avançado pode inspecionar as requisições.

Para uso institucional com informações sensíveis, recomenda-se uma segunda etapa com:
- Supabase Auth somente para ADM; ou
- Edge Function para validar o acesso administrativo;
- RLS restritiva para impedir leitura pública;
- bucket privado para fotos.

Nunca coloque a service_role key no HTML.
