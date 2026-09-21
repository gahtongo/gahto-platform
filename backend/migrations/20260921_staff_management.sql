BEGIN;

ALTER TABLE public.admin_users
    ADD COLUMN IF NOT EXISTS totp_secret VARCHAR(255);

CREATE TABLE IF NOT EXISTS public.staff_members (
    id SERIAL PRIMARY KEY,
    staff_id VARCHAR(50) NOT NULL UNIQUE,
    first_name VARCHAR(100) NOT NULL,
    middle_name VARCHAR(100),
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE,
    phone VARCHAR(50),
    position VARCHAR(150) NOT NULL,
    department VARCHAR(150),
    photo_url VARCHAR(500),
    status VARCHAR(50) NOT NULL DEFAULT 'pending_approval',
    date_joined TIMESTAMP WITHOUT TIME ZONE,
    created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS ix_staff_members_id ON public.staff_members (id);
CREATE UNIQUE INDEX IF NOT EXISTS ix_staff_members_staff_id ON public.staff_members (staff_id);
CREATE UNIQUE INDEX IF NOT EXISTS ix_staff_members_email ON public.staff_members (email);

CREATE TABLE IF NOT EXISTS public.staff_cards (
    id SERIAL PRIMARY KEY,
    card_id VARCHAR(100) NOT NULL UNIQUE,
    staff_id INTEGER NOT NULL REFERENCES public.staff_members(id) ON DELETE CASCADE,
    verification_token VARCHAR(255) NOT NULL UNIQUE,
    status VARCHAR(50) NOT NULL DEFAULT 'active',
    version INTEGER NOT NULL DEFAULT 1,
    issued_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT NOW(),
    expires_at TIMESTAMP WITHOUT TIME ZONE,
    revoked_at TIMESTAMP WITHOUT TIME ZONE,
    revocation_reason VARCHAR(500)
);

CREATE INDEX IF NOT EXISTS ix_staff_cards_id ON public.staff_cards (id);
CREATE UNIQUE INDEX IF NOT EXISTS ix_staff_cards_card_id ON public.staff_cards (card_id);
CREATE UNIQUE INDEX IF NOT EXISTS ix_staff_cards_verification_token ON public.staff_cards (verification_token);
CREATE INDEX IF NOT EXISTS ix_staff_cards_staff_id ON public.staff_cards (staff_id);

COMMIT;
