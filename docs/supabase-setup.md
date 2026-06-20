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
  url: "https://lktgbqlecrjfbzejwpil.supabase.co",
  anonKey: "your-supabase-anon-key",
  companyId: "69e12bdd-170d-414a-98c4-4809254881b2"
};
```

The app also has Supabase Settings fields in the Cloud Workspace panel. Use those fields to save the URL, anon key, and company id into browser `localStorage` so they do not get wiped out when `index.html` changes during development.

If the anon key is empty, the app intentionally stays in local mode and continues to use browser `localStorage`. The user id is not the anon key; get the anon public key from **Supabase → Project Settings → API**.


## Fix invite links that open `localhost`

If an invite email opens a `localhost` URL and your browser says refused to connect, Supabase is redirecting to a local development URL instead of the URL where Meridian Hub is actually running.

To fix it:

1. In Supabase, go to **Authentication → URL Configuration**.
2. Set **Site URL** to the real URL where you open Meridian Hub.
   - If you are testing locally, start a local server first and use that exact URL, such as `http://localhost:4173`.
   - If the app is hosted somewhere, use the hosted URL, such as `https://your-domain.com`.
3. Add that same URL to **Redirect URLs**.
4. Send a new invite or password reset email after changing the URL settings.

After the invite link opens Meridian Hub successfully, use the **New Password From Invite/Reset Link** field in the Cloud Workspace panel and click **Set Password**. Then sign in with your email and new password.



## Fix `Auth session missing` when setting a password

`Auth session missing` means the app opened, but Supabase did not establish a temporary auth session from the email link. The **Set Password** button only works after an invite or password-recovery link has successfully created a session.

Important distinction:

- A **magic link** is mainly for signing in.
- A **password reset/recovery link** is the correct flow for setting or changing a password.
- An **invite link** can also work, but only if it redirects back to Meridian Hub and creates a session.

Recommended fix:

1. Enter your email in the Cloud Workspace panel.
2. Click **Send Password Reset** instead of sending another magic link from Supabase.
3. Open the reset email link in the same browser.
4. When Meridian Hub opens, enter a new password in **New Password From Invite/Reset Link**.
5. Click **Set Password**.
6. Then sign in normally with email/password.

If you still see `Auth session missing`, check the URL after clicking the email link. It should contain either a `?code=...` query parameter or auth tokens in the URL hash. The app now attempts to exchange that auth code or token hash for a Supabase session before updating the password.

## Fix `email rate limit exceeded` on magic links or invites

Supabase limits authentication emails to prevent abuse. During setup, repeated magic links, invites, confirmations, and password reset emails can temporarily hit that limit.

Recommended fixes:

1. Wait for the rate-limit window to reset before sending more auth emails.
2. In Supabase, go to **Authentication → Logs** and review the failed request details.
3. In Supabase, go to **Authentication → Rate Limits** and review which email limits are configurable for your plan.
4. For development, create a user directly in **Authentication → Users** instead of repeatedly sending magic links.
5. If available for your project settings, manually mark your test user as confirmed so you can sign in with email/password without another confirmation email.
6. For production or heavier testing, configure a custom SMTP provider so auth emails use your own provider instead of Supabase's built-in email service.

For this app, the simplest development path is usually to create your user in Supabase Auth, manually add that user to `company_members`, set a password, and sign in with email/password instead of repeatedly using magic links.

## 4. Current behavior

- Signed-out or unconfigured app: time entries save locally in the browser.
- Signed-in and configured app: time entries load from the shared Supabase `time_entries` table.
- New cloud time entries include `company_id` and `user_id`.
- Edits and deletes are scoped to the configured company id.

## 5. Next hardening step

The next backend hardening step should be an owner/admin member-management screen so the owner can invite the second team member without manually inserting rows in SQL.
