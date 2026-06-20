# Meridian Hub Supabase Setup

This app now includes Phase 1/2 Supabase scaffolding for authentication, a company workspace, and user-aware cloud time entries while preserving local browser storage as a fallback.

## 1. Create the Supabase project

1. Create a Supabase project.
2. Enable Email/Password authentication in Supabase Auth.
3. Open the SQL editor.
4. Run `docs/supabase-schema.sql`.

## 2. Create the first workspace records

After creating the first user in Supabase Auth, run the bootstrap SQL comments at the bottom of `docs/supabase-schema.sql`:

```sql
insert into public.companies (name, created_by)
values ('Meridian ITP', '<auth-user-id>')
returning id;

insert into public.company_members (company_id, user_id, role)
values ('<company-id>', '<auth-user-id>', 'owner');
```

Copy the returned company id.

## 3. Configure the app

In `index.html`, fill in `SUPABASE_CONFIG`:

```js
const SUPABASE_CONFIG = {
  url: "https://your-project-ref.supabase.co",
  anonKey: "your-supabase-anon-key",
  companyId: "your-company-id"
};
```

If these values are empty, the app intentionally stays in local mode and continues to use browser `localStorage`.

## 4. Current behavior

- Signed-out or unconfigured app: time entries save locally in the browser.
- Signed-in and configured app: time entries load from the shared Supabase `time_entries` table.
- New cloud time entries include `company_id` and `user_id`.
- Edits and deletes are scoped to the configured company id.

## 5. Next hardening step

The next backend hardening step should be an owner/admin member-management screen so the owner can invite the second team member without manually inserting rows in SQL.
