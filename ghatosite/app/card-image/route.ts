// Keep card asset proxying outside /api because production Nginx routes that
// prefix to FastAPI. Re-export the existing handler to preserve one policy.
export { GET } from "../api/proxy-image/route";
