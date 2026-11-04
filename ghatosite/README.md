This is a [Next.js](https://nextjs.org) project bootstrapped with [`create-next-app`](https://nextjs.org/docs/app/api-reference/cli/create-next-app).

## GAHTO news and seasonal settings

The public news page shows the latest story first, then groups current-year stories by month and earlier stories by year. Editors may add multiple named source URLs to one story. The live ticker automatically omits stories older than one calendar month unless an editor selects “Keep in ticker beyond one month.” Existing single `external_link` stories remain supported.

Before deploying the corresponding backend image, back up the GAHTO database and apply `backend/migrations/20261104_news_sources_ticker.sql` to the GAHTO database. The migration only adds `source_links` and `ticker_pinned` to `news_posts`. Do not recreate the database or other projects' containers.

Super-admins can set `seasonal_theme` (`off` or `christmas`), `seasonal_start`, and `seasonal_end` in Settings. The decorative cap appears beside the unchanged logo only while today's date in Africa/Lagos is within the selected inclusive range. With missing dates or theme `off`, no decoration appears.

## Private report evidence deployment

Report evidence must not remain under the public `/uploads` route. The backend now writes new evidence to `/app/private_evidence`, backed by the GAHTO-only `backend/private_evidence` bind mount. Admins view it through `GET /api/v1/reports/admin/{report_id}/evidence` with their existing bearer token. The public report submission route and the `reports.evidence_url` column are unchanged.

Before replacing the live GAHTO backend, back up its database and `backend/uploads`, build the new images, and run the legacy migration's read-only inventory with `python -m migrations.migrate_report_evidence` in the new backend image. Stop **only** the GAHTO backend before running `python -m migrations.migrate_report_evidence --apply` in a one-off container using the production Compose files. The script copies and checksum-verifies the referenced files, changes only report evidence references, and removes only their public originals. It leaves a private manifest for audit. Start the new backend, verify its health and protected evidence access, then replace the GAHTO frontend. Do not stop the shared Nginx service or any other project's containers. If the migration errors, do not start the new frontend; inspect the manifest and backup before retrying.

## Getting Started

First, run the development server:

```bash
npm run dev
# or
yarn dev
# or
pnpm dev
# or
bun dev
```

Open [http://localhost:3000](http://localhost:3000) with your browser to see the result.

You can start editing the page by modifying `app/page.tsx`. The page auto-updates as you edit the file.

This project uses [`next/font`](https://nextjs.org/docs/app/building-your-application/optimizing/fonts) to automatically optimize and load [Geist](https://vercel.com/font), a new font family for Vercel.

## Learn More

To learn more about Next.js, take a look at the following resources:

- [Next.js Documentation](https://nextjs.org/docs) - learn about Next.js features and API.
- [Learn Next.js](https://nextjs.org/learn) - an interactive Next.js tutorial.

You can check out [the Next.js GitHub repository](https://github.com/vercel/next.js) - your feedback and contributions are welcome!

## Deploy on Vercel

The easiest way to deploy your Next.js app is to use the [Vercel Platform](https://vercel.com/new?utm_medium=default-template&filter=next.js&utm_source=create-next-app&utm_campaign=create-next-app-readme) from the creators of Next.js.

Check out our [Next.js deployment documentation](https://nextjs.org/docs/app/building-your-application/deploying) for more details.
