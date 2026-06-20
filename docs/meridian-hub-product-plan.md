# Meridian Hub Product Plan

## 1. Overall Assessment
Meridian Hub is a strong internal operations concept because it expands the existing time tracker into a single cloud-backed hub for small-company workflows. The idea is best approached as a modular web app: launch with time tracking plus a very small company operating expense/payment capture workflow, then add richer tracking for subscriptions, business insurance, vendor bills, recurring expenses, receipts, and reporting over time.

The current company size of three team members is an advantage for Version 1 because the product can stay simple, feedback loops are short, and adoption can be measured directly through daily use. The biggest architecture decision is to avoid building separate disconnected apps; instead, create one shared authentication, user, company, reporting, and storage foundation that supports modules such as Time and Expenses.

## 2. Suggested Improvements
- Define the hub as a collection of modules, starting with Time Tracking and Expenses.
- Clarify user roles early: owner/admin, team member, and possibly read-only reviewer.
- Keep Version 1 focused on daily entry capture instead of full accounting.
- Add status concepts only where they matter immediately, such as marking a company operating expense, vendor bill, subscription, insurance payment, or recent payment as paid.
- Standardize reporting around date ranges, users, projects, categories, and exportable summaries.
- Use cloud authentication and row-level permissions from the beginning so multi-user sync is not retrofitted later.
- Treat receipt uploads as a Version 0.2 or 0.3 feature unless they are required for this week.

## 3. Features to Remove from Version 1
Remove or defer these from the first build to reduce risk:

- Full mobile app and desktop app builds.
- Advanced accounting workflows such as invoicing, bank feeds, taxes, reconciliation, and double-entry bookkeeping.
- Complex recurring expense automation.
- Receipt OCR or automatic data extraction.
- Sophisticated dashboards with many charts.
- Deep integrations with Zoho Books, FreshBooks, payroll, or payment processors.
- Granular permissions beyond admin and team member.
- Offline-first sync conflict resolution.

## 4. Recommended Version 1 Scope
Version 1 should prove that two or more team members can reliably enter and view shared operating data in the cloud.

### Version 1 Must Include
- Sign in for at least two users.
- Shared company workspace.
- Time entry creation with date, user, project, task type, notes, and hours.
- Basic time list with filters by user, project, and date range.
- A simple reports view showing total hours by user and project.
- Simple company operating expense/payment entry with date, vendor/payee, amount, category, description, status, and paid marker.
- Cloud database persistence.
- Basic responsive web layout.

### Version 1 Success Criteria
- You and at least one other member can log in separately.
- Both users can create time entries and see synced updates.
- A recent company payment, such as a subscription, business insurance payment, or vendor bill, can be entered and marked paid.
- Basic totals are visible without exporting data manually.

## 5. Version Roadmap

### Version 0.1 — Cloud Time Tracking MVP
- Add authentication.
- Add company/workspace data model.
- Move time entries from browser-only storage to cloud storage.
- Support create, edit, delete, and list for time entries.
- Add basic reporting by user, project, and date range.

### Version 0.2 — Simple Company Expenses and Payments
- Add company operating expense/payment entry form.
- Add categories for subscriptions, business insurance, software, professional services, utilities, vendors/payees, amount, payment date, due date, and paid/unpaid status.
- Add expense list filters.
- Add totals by month, category, and status.

### Version 0.3 — Receipts and Recurring Expenses
- Add receipt upload storage.
- Link files to expense records.
- Add recurring expense templates.
- Add recurring expense reminders or manual generation.

### Version 0.4 — Dashboard and Reports
- Add unified dashboard for time and expenses.
- Add charts for weekly hours, monthly expenses, unpaid expenses, and project totals.
- Add CSV export.
- Add saved report filters.

### Version 0.5 — Admin Controls and Auditability
- Add role-based access controls.
- Add audit fields and activity history.
- Add archive behavior for projects, categories, and vendors.
- Add company settings.

### Version 1.0 — Stable Internal Operations Hub
- Polish navigation and onboarding.
- Add stronger validation, error handling, and empty states.
- Add backups/export strategy.
- Add privacy and retention documentation.
- Prepare mobile-friendly layouts for future app wrappers.

## 6. Database and Storage Recommendations
Use a managed cloud backend with authentication, relational data, file storage, and security rules. Supabase is a strong fit for this project because it provides Postgres, authentication, row-level security, file storage, and straightforward web app integration. Firebase is also viable, but the reporting and relational nature of time entries, users, vendors, expenses, projects, and categories makes Postgres especially practical.

Recommended stack:

- Database: Supabase Postgres.
- Authentication: Supabase Auth.
- File storage: Supabase Storage for receipts.
- Security: Row-level security scoped by company/workspace membership.
- Frontend: Current web app can evolve first; later consider React, Next.js, or another component framework once the product outgrows a single-file prototype.
- Backups: scheduled database backups plus periodic CSV exports for business continuity.

## 7. Local Storage vs Cloud Sync Recommendation
Cloud sync should be required from Version 0.1 because the primary use case is multi-user team tracking. Local storage can remain only as a temporary draft convenience, not as the source of truth.

Recommended approach:

- Cloud database is the source of truth.
- Browser local storage may store draft form values, UI preferences, and last-used filters.
- Do not rely on local storage for team records once multiple users are involved.
- Avoid offline-first complexity until there is clear evidence that users need it.

## 8. Monetization Suggestions
The current plan says monetization is not applicable, which makes sense for an internal company tool. If Meridian Hub later becomes useful outside the company, monetization options could include:

- Internal-only: no monetization; treat it as an operational productivity tool.
- Small business SaaS: monthly subscription per company or per active user.
- Module pricing: base hub plus paid expense, reporting, or receipt modules.
- Service model: setup/customization fee for similar small companies.
- Freemium is not recommended early because support and cloud costs can grow before the product is validated.

## 9. Potential Problems or Risks
- Scope creep from trying to compete with Zoho Books or FreshBooks too early.
- Sync and permissions bugs if cloud architecture is added late.
- Poor adoption if entry screens take too many clicks.
- Data privacy issues if users can see records outside their company/workspace.
- Receipt storage costs if files are large and retention is undefined.
- Reporting complexity if projects, task types, vendors, and categories are not standardized.
- Migration risk if the current local-only time tracker data needs to be imported into the cloud.
- Lack of audit history for paid/unpaid changes and edits.

## 10. Build Complexity Rating
Build complexity rating: 6 out of 10.

The basic hub is moderate complexity because time and expense entry forms are straightforward. Complexity increases because the app requires cloud sync, authentication, permissions, reporting, and future receipt storage. The project becomes much harder if it expands into accounting, bank syncing, invoicing, payroll, or offline-first behavior.

## User Flow

### New User / Team Member Flow
1. User opens Meridian Hub.
2. User signs in.
3. User lands on dashboard.
4. User chooses Time Tracker or Expenses.
5. User creates an entry.
6. Entry saves to the cloud.
7. Dashboard and reports update for permitted users.

### Time Tracking Flow
1. Select project.
2. Select task type.
3. Enter date.
4. Enter hours manually or use timer.
5. Add notes.
6. Save time entry.
7. View entry in recent activity and reports.

### Company Expense / Payment Flow
1. The responsible company operator opens Expenses.
2. Choose New Company Expense or New Payment.
3. Enter vendor/payee, amount, date, category, and description for items such as subscriptions, business insurance, software, or vendor bills.
4. Set status as paid or unpaid.
5. Save record.
6. View totals and filtered company expense list.

### Admin Flow
1. Admin signs in.
2. Admin manages users, projects, categories, and vendors.
3. Admin reviews reports.
4. Admin exports data when needed.

## Screen Layout Recommendations

### Splash / Sign-in Page
- Meridian Hub logo and short tagline.
- Sign-in form.
- Short explanation: Time, expenses, and reports for Meridian operations.
- Minimal content to keep the entry point professional.

### Dashboard
- Top navigation for Dashboard, Time Tracker, Expenses, Reports, and Settings.
- Summary cards:
  - Hours this week.
  - Hours this month.
  - Expenses this month.
  - Unpaid expenses.
- Recent activity list.
- Quick actions:
  - Add time entry.
  - Add expense/payment.

### Time Tracker
- Entry form at top or left.
- Timer/manual entry switch.
- Recent time entries table.
- Filters for date range, user, project, and task type.
- Small report summary for total hours.

### Expense Tracker
- Company operating expense/payment form, primarily for one operator rather than employee reimbursements.
- Paid/unpaid status control.
- Vendor/payee and category fields for subscriptions, business insurance, software, professional services, utilities, and other company costs.
- Company expense list table.
- Filters for status, category, vendor, and date range.
- Later: receipt or policy/document upload area.

### Reports
- Date range selector.
- Report tabs for Time, Expenses, and Combined Summary.
- Export CSV button.
- Charts should stay simple in early versions.

### Settings
- Company profile.
- Users and roles.
- Projects.
- Task types.
- Expense categories.
- Vendors/payees.

## Data Structure

### companies
- id
- name
- created_at
- updated_at

### users
- id
- email
- display_name
- created_at
- updated_at

### company_members
- id
- company_id
- user_id
- role
- status
- created_at

### projects
- id
- company_id
- name
- status
- created_at
- updated_at

### task_types
- id
- company_id
- name
- status
- created_at
- updated_at

### time_entries
- id
- company_id
- user_id
- project_id
- task_type_id
- entry_date
- start_time
- end_time
- duration_minutes
- notes
- created_at
- updated_at

### vendors
- id
- company_id
- name
- status
- created_at
- updated_at

### expense_categories
- id
- company_id
- name
- status
- created_at
- updated_at

### expenses
- id
- company_id
- entered_by_user_id
- vendor_id
- category_id
- expense_date
- due_date
- paid_date
- amount_cents
- currency
- status
- description
- expense_kind
- is_recurring
- recurring_template_id
- created_at
- updated_at

### receipts
- id
- company_id
- expense_id
- storage_path
- file_name
- content_type
- file_size
- uploaded_by
- created_at

### recurring_expense_templates
- id
- company_id
- vendor_id
- category_id
- amount_cents
- currency
- frequency
- next_due_date
- status
- notes
- created_at
- updated_at

## Development Roadmap

### Phase 1 — Product Foundation
- Confirm Version 0.1 scope.
- Decide backend provider.
- Define roles and permissions.
- Create database schema.
- Plan migration from current local time entries if needed.

### Phase 2 — Cloud Time Tracker
- Add sign-in.
- Add company workspace.
- Replace local-only time entry storage with cloud persistence.
- Add time entry CRUD.
- Add basic filters and reports.

### Phase 3 — Company Expense MVP
- Add company operating expense/payment form.
- Add expense list and filters for subscriptions, business insurance, software, professional services, utilities, and vendor bills.
- Add paid/unpaid status.
- Add monthly totals.

### Phase 4 — Reports and Exports
- Add unified dashboard cards.
- Add CSV export.
- Add basic charts.
- Add report filters.

### Phase 5 — Receipts and Recurring Expenses
- Add receipt upload storage.
- Add recurring expense templates.
- Add due/paid tracking improvements.

### Phase 6 — Hardening
- Add audit history for edits and payments.
- Add stronger validation and error states.
- Add backup/export procedures.
- Improve responsive design for future mobile app work.
