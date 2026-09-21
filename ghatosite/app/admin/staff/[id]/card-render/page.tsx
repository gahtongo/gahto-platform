"use client";

import { useEffect, useRef, useState } from "react";
import { useParams, useRouter } from "next/navigation";
import { ChevronLeft, Download, Loader2 } from "lucide-react";
import Link from "next/link";
import { QRCodeSVG } from "qrcode.react";
import { toPng } from "html-to-image";

export default function CardRender() {
  const { id } = useParams();
  const router = useRouter();

  const [member, setMember] = useState<any>(null);
  const [activeCard, setActiveCard] = useState<any>(null);
  const [loading, setLoading] = useState(true);
  const [renderingSide, setRenderingSide] = useState<"Front" | "Back" | null>(null);

  const cardFrontRef = useRef<HTMLDivElement>(null);
  const cardBackRef = useRef<HTMLDivElement>(null);
  const [founderSignatureUrl, setFounderSignatureUrl] = useState<string | null>(null);

  useEffect(() => {
    const token = localStorage.getItem("gahto_admin_token");
    if (!token) {
      router.replace("/admin/login");
      return;
    }

    const fetchStaffData = async () => {
      try {
        const [staffRes, cardsRes, settingsRes] = await Promise.all([
          fetch(`${process.env.NEXT_PUBLIC_API_BASE_URL}/api/v1/staff/${id}`, {
            headers: { Authorization: `Bearer ${token}` }
          }),
          fetch(`${process.env.NEXT_PUBLIC_API_BASE_URL}/api/v1/staff/${id}/cards`, {
            headers: { Authorization: `Bearer ${token}` }
          }),
          fetch(`${process.env.NEXT_PUBLIC_API_BASE_URL}/api/v1/settings/admin`, {
            headers: { Authorization: `Bearer ${token}` }
          })
        ]);

        if (staffRes.ok) setMember(await staffRes.json());
        if (cardsRes.ok) {
          const cards = await cardsRes.json();
          setActiveCard(cards.find((c: any) => c.status === "active"));
        }
        if (settingsRes.ok) {
          const settingsData = await settingsRes.json();
          const signature = settingsData.find((s: any) => s.key === "founder_signature");
          if (signature) setFounderSignatureUrl(signature.value);
        }

        // Enforce Super Admin Only
        const meRes = await fetch(`${process.env.NEXT_PUBLIC_API_BASE_URL}/api/v1/admin/me`, {
           headers: { Authorization: `Bearer ${token}` }
        });
        if (meRes.ok) {
           const me = await meRes.json();
           if (me.role !== "super_admin") {
              router.replace("/admin/staff");
              return;
           }
        }
      } catch (err) {
        console.error(err);
      } finally {
        setLoading(false);
      }
    };

    fetchStaffData();
  }, [id, router]);

  const handleDownload = async (ref: React.RefObject<HTMLDivElement | null>, side: "Front" | "Back") => {
    if (!ref?.current) return;
    setRenderingSide(side);

    try {
      await document.fonts.ready;
      const images = Array.from(ref.current.querySelectorAll("img"));
      await Promise.all(images.map(async (image) => {
        const optional = image.dataset.exportOptional === "true";
        if (!image.complete) {
          await new Promise<void>((resolve, reject) => {
            image.addEventListener("load", () => resolve(), { once: true });
            image.addEventListener("error", () => optional ? resolve() : reject(new Error("Card image failed to load")), { once: true });
          });
        }
        if (image.decode) await image.decode().catch(() => undefined);
      }));
      const dataUrl = await toPng(ref.current, {
        pixelRatio: 4,
        cacheBust: true,
        backgroundColor: "#ffffff",
      });

      const link = document.createElement("a");
      link.download = `GAHTO_ID_${member.staff_id}_${side}.png`;
      link.href = dataUrl;
      document.body.appendChild(link);
      link.click();
      link.remove();
    } catch (error) {
      console.error(`Card ${side} export failed`, error);
      alert(`Unable to download the ${side.toLowerCase()} card. Please refresh once and try again.`);
    } finally {
      setRenderingSide(null);
    }
  };

  const absoluteAssetUrl = (url: string | null) => {
    if (!url) return "";
    if (url.startsWith("http://") || url.startsWith("https://")) return url;
    const apiBase = process.env.NEXT_PUBLIC_API_BASE_URL || "http://127.0.0.1:8000";
    return `${apiBase.replace(/\/$/, "")}/${url.replace(/^\//, "")}`;
  };

  const proxyUrl = (url: string | null) => {
    const absoluteUrl = absoluteAssetUrl(url);
    return absoluteUrl ? `/card-image?url=${encodeURIComponent(absoluteUrl)}` : "";
  };

  const exportAssetUrl = (url: string | null) => {
    if (!url) return "";
    try {
      const parsed = new URL(url, window.location.origin);
      if (parsed.pathname.startsWith("/images/")) return parsed.pathname;
    } catch {
      return "";
    }
    return proxyUrl(url);
  };

  if (loading) return <div className="p-10 text-center text-slate-500">Loading...</div>;
  if (!member || !activeCard) return <div className="p-10 text-center text-red-500">Active card not found.</div>;

  const verificationUrl = `${process.env.NEXT_PUBLIC_FRONTEND_URL || "https://gahto.org"}/verify/staff/${activeCard.verification_token}`;

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <div className="flex items-center gap-3">
          <Link href={`/admin/staff/${id}`} className="flex h-10 w-10 items-center justify-center rounded-xl bg-white text-slate-500 shadow-sm transition hover:bg-slate-50 hover:text-slate-900">
            <ChevronLeft className="h-5 w-5" />
          </Link>
          <div>
            <h1 className="text-2xl font-bold text-slate-900">Render ID Card</h1>
            <p className="text-sm text-slate-500">High-resolution export for printing.</p>
          </div>
        </div>

        <div className="flex gap-2">
          <button
            onClick={() => handleDownload(cardFrontRef, "Front")}
            disabled={renderingSide !== null}
            className="inline-flex items-center gap-2 rounded-xl bg-blue-900 px-4 py-2 text-sm font-semibold text-white shadow-sm transition hover:bg-blue-800 disabled:opacity-50"
          >
            {renderingSide === "Front" ? <Loader2 className="h-4 w-4 animate-spin" /> : <Download className="h-4 w-4" />}
            {renderingSide === "Front" ? "Rendering..." : "Download Front"}
          </button>
          <button
            onClick={() => handleDownload(cardBackRef, "Back")}
            disabled={renderingSide !== null}
            className="inline-flex items-center gap-2 rounded-xl bg-red-600 px-4 py-2 text-sm font-semibold text-white shadow-sm transition hover:bg-red-700 disabled:opacity-50"
          >
            {renderingSide === "Back" ? <Loader2 className="h-4 w-4 animate-spin" /> : <Download className="h-4 w-4" />}
            {renderingSide === "Back" ? "Rendering..." : "Download Back"}
          </button>
        </div>
      </div>

      <div className="flex flex-wrap justify-center gap-10 bg-slate-200 p-10 rounded-2xl overflow-hidden">
        {/* GAHTO Professional ID Card Template (FRONT) */}
        <div
          ref={cardFrontRef}
          className="relative bg-white overflow-hidden shadow-2xl shrink-0"
          style={{ width: "340px", height: "540px" }}
        >
          {/* Layered brand corners */}
          <div className="absolute left-0 top-0 h-16 w-[72px] rounded-br-[64px] bg-red-600"></div>
          <div className="absolute left-0 top-0 h-[50px] w-[58px] rounded-br-[54px] border-b-[3px] border-r-[3px] border-white/80"></div>
          <div className="absolute right-0 top-0 h-16 w-[78px] rounded-bl-[68px] bg-blue-900"></div>
          <div className="absolute right-0 top-0 h-[50px] w-16 rounded-bl-[58px] border-b-[3px] border-l-[3px] border-white/80"></div>
          <div className="absolute right-[62px] top-[48px] h-2.5 w-2.5 rounded-full bg-red-600 ring-2 ring-white"></div>

          <div className="relative z-10 pt-8 pb-3 flex flex-col items-center">
            {/* Logo area - Increased from 16 to 20 */}
            <div className="w-[88px] h-[88px] bg-white rounded-full flex items-center justify-center p-1.5 shadow-md mb-2 relative z-20 ring-1 ring-slate-100">
               <img src="/logo.png" alt="GAHTO" className="w-full h-full object-contain" crossOrigin="anonymous" />
            </div>

            {/* Text styling updated to ensure readability with a subtle white glow/shadow against the blue corner */}
            <div className="text-center px-4">
              <h2 className="text-[12px] font-black text-blue-950 uppercase tracking-[0.06em] leading-tight">Global Anti Human<br/>Trafficking Organization</h2>
            </div>
          </div>

          {/* Faint Background Watermark */}
          <div className="absolute inset-0 flex items-center justify-center opacity-[0.03] pointer-events-none">
            <img src="/logo.png" alt="" className="w-48 h-48 grayscale" crossOrigin="anonymous" />
          </div>

          <div className="relative z-10 px-6 mt-1 flex flex-col items-center">
            <div className="relative flex w-full justify-center">
              <div className="w-[152px] h-[168px] rounded-xl overflow-hidden border-[3px] border-white shadow-lg bg-slate-100 flex items-center justify-center ring-1 ring-slate-200">
                {member.photo_url ? (
                  <img src={proxyUrl(member.photo_url)} alt="Staff" className="w-full h-full object-cover object-top" crossOrigin="anonymous" />
                ) : (
                  <div className="text-4xl font-bold text-slate-300">
                    {member.first_name[0]}{member.last_name[0]}
                  </div>
                )}
              </div>

              <div className="absolute bottom-0 right-0 flex flex-col items-center">
                <div className="rounded-md border border-slate-200 bg-white p-1 shadow-sm">
                  <QRCodeSVG value={verificationUrl} size={50} />
                </div>
                <p className="mt-1 text-[6px] font-bold uppercase tracking-widest text-slate-400">Scan to Verify</p>
              </div>
            </div>

            {/* Details */}
            <div className="mt-3 w-full text-center">
              <h1 className="text-[22px] font-extrabold text-blue-950 leading-tight uppercase tracking-wide">
                {member.first_name} <br/> {member.last_name}
              </h1>
              <div className="mt-1 flex items-center justify-center gap-2">
                <div className="h-[2px] w-8 bg-red-600"></div>
                <p className="max-w-[210px] text-[12px] font-bold text-red-600 uppercase tracking-[0.14em] leading-tight">{member.position}</p>
                <div className="h-[2px] w-8 bg-red-600"></div>
              </div>
              <div className="mt-2 inline-flex items-center gap-2 rounded-full border border-blue-100 bg-blue-50 px-3 py-1.5">
                <span className="text-[8px] font-bold uppercase tracking-[0.14em] text-slate-500">Staff ID</span>
                <span className="text-[11px] font-black tracking-wide text-blue-950">{member.staff_id}</span>
              </div>
            </div>
          </div>

          {/* Bottom Branding Footer */}
          <div className="absolute bottom-0 left-0 right-0 h-10 flex items-center justify-center bg-blue-950 text-white overflow-hidden">
             {/* Diagonal accent */}
             <div className="absolute left-0 top-0 bottom-0 w-16 bg-red-600" style={{ transform: "skewX(-30deg) translateX(-10px)" }}></div>

             <p className="relative z-10 text-[8px] font-bold uppercase tracking-[0.2em] opacity-90 pl-6">
                Say No to Human Trafficking
             </p>
          </div>
        </div>

        {/* GAHTO Professional ID Card Template (BACK) */}
        <div
          ref={cardBackRef}
          className="relative bg-white overflow-hidden shadow-2xl shrink-0 border border-slate-200"
          style={{ width: "340px", height: "540px" }}
        >
          {/* Header Bar */}
          <div className="h-12 bg-blue-950 w-full flex items-center justify-center">
             <p className="text-white font-bold text-[10px] tracking-widest uppercase">Property of GAHTO</p>
          </div>

          <div className="px-6 py-6 flex flex-col h-[calc(100%-48px)]">

            <div className="text-center space-y-3 mb-8 text-[11px] leading-relaxed text-slate-700">
               <p className="font-bold text-black text-[13px] mb-2 uppercase tracking-wide">Authorized Personnel</p>
               <p>
                 This card identifies the bearer as an official staff member of the <strong>Global Anti Human Trafficking Organization (GAHTO)</strong>.
               </p>
               <p>
                 If found, please return to any GAHTO office or contact our administrative headquarters immediately.
               </p>
            </div>

            <div className="space-y-1 mb-8">
               <div className="flex text-[10px] border-b border-slate-200 pb-1">
                 <span className="w-20 font-bold text-blue-950 uppercase">Blood Grp:</span>
                 <span className="text-slate-700">________________</span>
               </div>
               <div className="flex text-[10px] border-b border-slate-200 pb-1 pt-2">
                 <span className="w-20 font-bold text-blue-950 uppercase">Emg. Phone:</span>
                 <span className="text-slate-700">________________</span>
               </div>
               <div className="flex text-[10px] border-b border-slate-200 pb-1 pt-2">
                 <span className="w-20 font-bold text-blue-950 uppercase">Issue Date:</span>
                 <span className="text-slate-700">{new Date(activeCard.issued_at).toLocaleDateString()}</span>
               </div>
            </div>

            {/* Signature Area */}
            <div className="mt-auto flex flex-col items-center mb-6">
               <div className="h-12 w-32 border-b-2 border-slate-900 mb-1 flex items-end justify-center relative">
                  <img
                    src={exportAssetUrl(founderSignatureUrl || "/images/signature.png")}
                    alt="Authorized signature"
                    data-export-optional="true"
                    className="h-10 w-auto object-contain absolute bottom-1"
                    crossOrigin="anonymous"
                  />
               </div>
               <p className="text-[10px] font-bold text-slate-900 uppercase">P. K. Michael</p>
               <p className="text-[8px] font-bold text-red-600 uppercase tracking-widest">Founder / President</p>
            </div>

            <div className="text-center text-[9px] text-slate-500 font-medium">
               <p>www.gahto.org | +234 805 050 3535</p>
               <p>No. 2, Onala-Quarters, Ado-Ekiti</p>
            </div>
          </div>
        </div>

      </div>
    </div>
  );
}
