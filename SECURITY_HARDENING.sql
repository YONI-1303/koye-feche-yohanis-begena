-- Koye Feche Yohanis Begena — security hardening applied 2026-11-07
-- Removes anonymous API execution from legacy SECURITY DEFINER helpers and
-- restricts the leaderboard RPC to an enrolled student or assigned class staff.

begin;

revoke execute on function public.set_surafel_mentor()
  from public, anon, authenticated, service_role;

revoke execute on function public.handle_new_user()
  from public, anon, authenticated, service_role;

revoke execute on function public.lookup_student_login(text)
  from public, anon, authenticated;

revoke execute on function public."current_role"()
  from public, anon, authenticated, service_role;

revoke execute on function public.get_class_leaderboard(uuid)
  from public, anon;
grant execute on function public.get_class_leaderboard(uuid)
  to authenticated;

revoke execute on function public.is_admin()
  from public, anon;
grant execute on function public.is_admin()
  to authenticated;

revoke execute on function public.is_mentor_or_admin()
  from public, anon;
grant execute on function public.is_mentor_or_admin()
  to authenticated;

create or replace function public.get_class_leaderboard(p_class_id uuid)
returns table(
  rank_no bigint,
  student_id uuid,
  full_name text,
  public_student_id text,
  completed_lessons bigint,
  total_lessons bigint,
  progress_percent integer,
  last_completed_at timestamptz
)
language plpgsql
security definer
set search_path = ''
as $function$
begin
  if (select auth.uid()) is null
     or not (
       (select private.is_kfy_class_staff(p_class_id))
       or exists (
         select 1
         from public.enrollments e
         where e.class_id = p_class_id
           and e.student_id = (select auth.uid())
           and e.status = 'active'
       )
     )
  then
    raise exception 'Not authorized to view this class leaderboard'
      using errcode = '42501';
  end if;

  return query
  with lesson_total as (
    select count(*)::bigint as total
    from public.lessons l
    where l.class_id = p_class_id
      and l.published = true
  ),
  student_list as (
    select e.student_id, p.full_name, p.student_id as public_student_id
    from public.enrollments e
    join public.profiles p on p.id = e.student_id
    where e.class_id = p_class_id
      and e.status = 'active'
      and p.role = 'student'
  ),
  progress_data as (
    select
      s.student_id,
      s.full_name,
      s.public_student_id,
      count(lp.id) filter (where lp.completed = true)::bigint as completed_lessons,
      max(lp.completed_at) filter (where lp.completed = true) as last_completed_at
    from student_list s
    cross join lesson_total lt
    left join public.lesson_progress lp
      on lp.student_id = s.student_id
     and lp.class_id = p_class_id
    group by s.student_id, s.full_name, s.public_student_id
  ),
  ranked as (
    select
      row_number() over (
        order by pd.completed_lessons desc,
                 pd.last_completed_at desc nulls last,
                 pd.full_name asc
      ) as rank_no,
      pd.student_id,
      pd.full_name,
      pd.public_student_id,
      pd.completed_lessons,
      lt.total as total_lessons,
      case
        when lt.total = 0 then 0
        else round((pd.completed_lessons::numeric / lt.total) * 100)::integer
      end as progress_percent,
      pd.last_completed_at
    from progress_data pd
    cross join lesson_total lt
  )
  select
    r.rank_no,
    r.student_id,
    r.full_name,
    r.public_student_id,
    r.completed_lessons,
    r.total_lessons,
    r.progress_percent,
    r.last_completed_at
  from ranked r
  order by r.rank_no;
end;
$function$;

commit;
