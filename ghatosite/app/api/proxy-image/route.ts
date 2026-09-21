import { NextRequest, NextResponse } from "next/server";

export async function GET(req: NextRequest) {
  const url = req.nextUrl.searchParams.get("url");

  if (!url) {
    return new NextResponse("Missing url parameter", { status: 400 });
  }

  try {
    const requestedUrl = new URL(url);
    if (!['http:', 'https:'].includes(requestedUrl.protocol) || !requestedUrl.pathname.startsWith('/uploads/')) {
      return new NextResponse('Unsupported image URL', { status: 403 });
    }
    const filename = requestedUrl.pathname.split('/').pop() || '';
    if (!filename.startsWith('staff_') && !filename.startsWith('setting_')) {
      return new NextResponse('Image is not an approved card asset', { status: 403 });
    }

    const publicApiUrl = process.env.NEXT_PUBLIC_API_BASE_URL;
    if (!publicApiUrl) return new NextResponse('API URL is not configured', { status: 503 });
    const allowedHost = new URL(publicApiUrl).host;
    if (requestedUrl.host !== allowedHost) {
      return new NextResponse('Image host is not allowed', { status: 403 });
    }

    const internalBase = process.env.INTERNAL_API_BASE_URL?.replace(/\/$/, '');
    const fetchUrl = internalBase ? `${internalBase}${requestedUrl.pathname}` : requestedUrl.toString();
    const response = await fetch(fetchUrl, { cache: 'no-store' });
    if (!response.ok) {
      throw new Error(`Failed to fetch image: ${response.statusText}`);
    }

    const arrayBuffer = await response.arrayBuffer();
    const buffer = Buffer.from(arrayBuffer);

    const headers = new Headers();
    headers.set("Content-Type", response.headers.get("Content-Type") || "image/jpeg");
    headers.set("Access-Control-Allow-Origin", "*");
    headers.set("Cache-Control", "private, max-age=300");

    return new NextResponse(buffer, {
      status: 200,
      headers: headers,
    });
  } catch {
    return new NextResponse("Unable to load image", { status: 502 });
  }
}
