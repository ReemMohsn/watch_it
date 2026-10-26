-- Run once in the Supabase SQL Editor for the existing video library.
begin;

-- Deleting a playlist removes its linked videos in the same transaction.
do $$
declare
  playlist_foreign_key record;
begin
  for playlist_foreign_key in
    select conname
    from pg_constraint
    where contype = 'f'
      and conrelid = 'public.youtube_videos'::regclass
      and confrelid = 'public.playlists'::regclass
      and conkey = array[
        (
          select attnum
          from pg_attribute
          where attrelid = 'public.youtube_videos'::regclass
            and attname = 'playlist_id'
        )
      ]::smallint[]
  loop
    execute format(
      'alter table public.youtube_videos drop constraint %I',
      playlist_foreign_key.conname
    );
  end loop;

  alter table public.youtube_videos
    add constraint youtube_videos_playlist_id_fkey
    foreign key (playlist_id) references public.playlists(id)
    on delete cascade;
end;
$$;

-- The app uses authenticated teacher accounts for library management.
alter table public.playlists enable row level security;
grant delete on public.playlists to authenticated;

drop policy if exists playlists_teacher_delete on public.playlists;
create policy playlists_teacher_delete
  on public.playlists
  for delete
  to authenticated
  using ((select auth.uid()) is not null);

commit;
