-- Koye Feche Yohanis Begena — feature upgrade
-- This migration was applied to Supabase project tgckbznefwexvgttkgha on 2026-11-07.
-- Safe to re-run: table/columns/indexes are guarded and policies are replaced by name.

begin;

-- 1) Allow each Mezmur to have an optional YouTube video.
alter table public.mezmur
  add column if not exists youtube_url text;

-- 2) Mentor notices / warnings for individual students.
create table if not exists public.student_warnings (
  id uuid primary key default gen_random_uuid(),
  student_id uuid not null references public.profiles(id) on delete cascade,
  class_id uuid not null references public.classes(id) on delete cascade,
  created_by uuid references public.profiles(id) on delete set null,
  title text not null default 'Mentor warning',
  message text not null check (length(trim(message)) > 0),
  severity text not null default 'warning'
    check (severity in ('reminder', 'warning', 'serious')),
  status text not null default 'active'
    check (status in ('active', 'resolved')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  resolved_at timestamptz,
  resolved_by uuid references public.profiles(id) on delete set null
);

create index if not exists student_warnings_student_created_idx
  on public.student_warnings (student_id, created_at desc);
create index if not exists student_warnings_class_created_idx
  on public.student_warnings (class_id, created_at desc);
create index if not exists student_warnings_created_by_idx
  on public.student_warnings (created_by);
create index if not exists student_warnings_resolved_by_idx
  on public.student_warnings (resolved_by);

alter table public.student_warnings enable row level security;
revoke all on table public.student_warnings from anon;
grant select, insert, update, delete on table public.student_warnings to authenticated;

drop policy if exists student_warnings_read_own_or_class_staff
  on public.student_warnings;
create policy student_warnings_read_own_or_class_staff
  on public.student_warnings
  for select
  to authenticated
  using (
    (select auth.uid()) = student_id
    or (select private.is_kfy_class_staff(class_id))
  );

drop policy if exists student_warnings_staff_insert
  on public.student_warnings;
create policy student_warnings_staff_insert
  on public.student_warnings
  for insert
  to authenticated
  with check (
    (select private.is_kfy_class_staff(class_id))
    and created_by = (select auth.uid())
    and exists (
      select 1
      from public.enrollments e
      where e.class_id = student_warnings.class_id
        and e.student_id = student_warnings.student_id
    )
  );

drop policy if exists student_warnings_staff_update
  on public.student_warnings;
create policy student_warnings_staff_update
  on public.student_warnings
  for update
  to authenticated
  using ((select private.is_kfy_class_staff(class_id)))
  with check (
    (select private.is_kfy_class_staff(class_id))
    and exists (
      select 1
      from public.enrollments e
      where e.class_id = student_warnings.class_id
        and e.student_id = student_warnings.student_id
    )
  );

drop policy if exists student_warnings_staff_delete
  on public.student_warnings;
create policy student_warnings_staff_delete
  on public.student_warnings
  for delete
  to authenticated
  using ((select private.is_kfy_class_staff(class_id)));

-- 3) Attach the video supplied by the app owner to the existing Mezmur.
update public.mezmur
set youtube_url = 'https://youtu.be/HESNDX4_nWw?si=f178xgcHSuF3LwGJ'
where id = '326a6c07-7898-4f15-861c-2d006b418c1b'
  and title_am = 'ሰላም ለማርያም';

commit;
