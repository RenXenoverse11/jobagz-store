-- Run this in Supabase SQL Editor
-- For existing projects, this also removes the old category/stock columns.

create table if not exists products (
  id bigint generated always as identity primary key,
  name text not null,
  price numeric(10, 2) not null check (price >= 0),
  created_at timestamptz default now()
);

alter table products drop column if exists category;
alter table products drop column if exists stock;

-- Index for faster ILIKE search
create index if not exists products_name_lower_idx on products (lower(name));

-- RLS: open access (no auth needed)
alter table products enable row level security;
do $$
begin
  if not exists (
    select 1
    from pg_policies
    where schemaname = 'public'
      and tablename = 'products'
      and policyname = 'Allow all'
  ) then
    create policy "Allow all" on products for all using (true) with check (true);
  end if;
end
$$;
