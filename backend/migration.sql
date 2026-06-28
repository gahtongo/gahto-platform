-- GAHTO Migration Script
-- Run this AFTER restoring gahtobackup.sql

-- 1. Update 'reports' table with new geocoding fields
ALTER TABLE public.reports
ADD COLUMN IF NOT EXISTS full_address TEXT,
ADD COLUMN IF NOT EXISTS city CHARACTER VARYING(255),
ADD COLUMN IF NOT EXISTS state CHARACTER VARYING(255),
ADD COLUMN IF NOT EXISTS country CHARACTER VARYING(255),
ADD COLUMN IF NOT EXISTS postal_code CHARACTER VARYING(50),
ADD COLUMN IF NOT EXISTS nearby_landmark CHARACTER VARYING(255);

-- 2. Insert new site settings keys for address management
INSERT INTO public.site_settings (key, value, description, is_public, created_at, updated_at)
VALUES
('nigeria_office_address', '2 Onola Balemo Quarters, Ado Ekiti', 'Full address for the Ado Ekiti office.', true, NOW(), NOW()),
('abuja_office_address', 'No 4, MukB Estate by A. A. Rano Filling Station, along Dape Lifecamp Abuja.', 'Full address for the Abuja office.', true, NOW(), NOW()),
('mali_office_address', '5em plaque, Garantiguibougou, Bamako, Mali', 'Full address for the Mali office.', true, NOW(), NOW())
ON CONFLICT (key) DO NOTHING;

-- 3. Ensure Resend config is ready in backend .env (Manual Step)
-- 4. Verify all constraints and sequences
SELECT setval('public.site_settings_id_seq', (SELECT MAX(id) FROM public.site_settings));
SELECT setval('public.reports_id_seq', (SELECT MAX(id) FROM public.reports));
