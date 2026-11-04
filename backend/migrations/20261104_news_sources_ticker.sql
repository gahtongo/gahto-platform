BEGIN;

ALTER TABLE public.news_posts
  ADD COLUMN IF NOT EXISTS source_links json NOT NULL DEFAULT '[]'::json,
  ADD COLUMN IF NOT EXISTS ticker_pinned boolean NOT NULL DEFAULT false;

COMMIT;
