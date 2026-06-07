-- Run this in Supabase SQL Editor

create table products (
  id bigint generated always as identity primary key,
  name text not null,
  price numeric(10, 2) not null check (price >= 0),
  category text,
  stock integer check (stock >= 0),
  created_at timestamptz default now()
);

-- Index for faster ILIKE search
create index products_name_lower_idx on products (lower(name));

-- RLS: open access (no auth needed)
alter table products enable row level security;
create policy "Allow all" on products for all using (true) with check (true);
