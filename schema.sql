-- OPERAÇÃO ELEIÇÕES 2026 — CPR I
-- Banco simplificado: o militar NÃO precisa de conta/login.
-- O painel ADM possui bloqueio de interface no HTML; para segurança forte, recomenda-se migrar o ADM para Supabase Auth/Edge Function posteriormente.

create extension if not exists pgcrypto;

create table if not exists public.ocorrencias (
  id uuid primary key default gen_random_uuid(),
  protocolo text unique not null,
  created_at timestamptz not null default now(),
  data_ocorrencia date not null,
  hora_ocorrencia time,
  natureza text not null,
  guarnicao text not null,
  municipio text not null,
  opm text,
  lancador_nome text not null,
  lancador_matricula text not null,
  lancador_posto text,
  integrantes text not null,
  endereco text not null,
  referencia text,
  zona_eleitoral text,
  local_votacao text,
  envolvidos text,
  relato text not null,
  natureza_inicial text,
  providencias text,
  encaminhamentos text,
  fotos jsonb not null default '[]'::jsonb,
  desfecho text,
  encaminhamento_final text,
  observacoes text,
  status text not null default 'NOVO' check(status in ('NOVO','EM ANÁLISE','CONCLUÍDO'))
);

create index if not exists ocorrencias_data_idx on public.ocorrencias(data_ocorrencia desc);
create index if not exists ocorrencias_status_idx on public.ocorrencias(status);
create index if not exists ocorrencias_municipio_idx on public.ocorrencias(municipio);
create index if not exists ocorrencias_protocolo_idx on public.ocorrencias(protocolo);

alter table public.ocorrencias enable row level security;

-- Sem login para lançamento: permite inserir apenas os campos necessários.
drop policy if exists "public_insere_ocorrencia" on public.ocorrencias;
create policy "public_insere_ocorrencia" on public.ocorrencias
for insert to anon, authenticated
with check (true);

-- Para o painel HTML funcionar sem login, a leitura fica aberta pela ANON KEY.
-- O bloqueio de acesso ao painel é feito pelo código ADMIN_PASSWORD do index.html.
-- Se o sistema entrar em produção com dados sensíveis, recomenda-se substituir esta política por uma Edge Function autenticada.
drop policy if exists "public_le_ocorrencias" on public.ocorrencias;
create policy "public_le_ocorrencias" on public.ocorrencias
for select to anon, authenticated
using (true);

drop policy if exists "public_atualiza_status" on public.ocorrencias;
create policy "public_atualiza_status" on public.ocorrencias
for update to anon, authenticated
using (true)
with check (true);

-- Storage para fotografias
insert into storage.buckets (id,name,public)
values ('ocorrencias','ocorrencias',true)
on conflict (id) do update set public=true;

drop policy if exists "public_upload_fotos_ocorrencias" on storage.objects;
create policy "public_upload_fotos_ocorrencias" on storage.objects
for insert to anon, authenticated
with check (bucket_id='ocorrencias');

drop policy if exists "public_view_fotos_ocorrencias" on storage.objects;
create policy "public_view_fotos_ocorrencias" on storage.objects
for select to anon, authenticated
using (bucket_id='ocorrencias');
