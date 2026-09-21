"use client";

import { useEffect, useState } from "react";
import { useParams } from "next/navigation";
import { AlertCircle, CheckCircle2, Loader2, ShieldAlert, ShieldCheck } from "lucide-react";
import Link from "next/link";

export default function VerifyStaffPage() {
  const { token } = useParams();
  const [card, setCard] = useState<any>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");

  useEffect(() => {
    const verifyToken = async () => {
      try {
        const res = await fetch(`${process.env.NEXT_PUBLIC_API_BASE_URL || "http://127.0.0.1:8000"}/api/v1/staff/cards/verify/${token}`);
        if (!res.ok) {
          throw new Error("Invalid or unrecognized credential.");
        }
        const data = await res.json();
        setCard(data);
      } catch (err: any) {
        setError(err.message);
      } finally {
        setLoading(false);
      }
    };

    verifyToken();
  }, [token]);

  return (
    <main className="min-h-screen bg-slate-50 py-12 px-4 sm:px-6">
      <div className="max-w-md mx-auto">
        <div className="flex justify-center mb-8">
           <img src="/logo.png" alt="GAHTO Logo" className="h-16 w-16 object-contain" />
        </div>

        <div className="rounded-[2rem] border border-slate-200 bg-white overflow-hidden shadow-xl">
          <div className="bg-slate-950 p-6 text-center text-white">
            <h1 className="text-xl font-bold tracking-wide">GAHTO VERIFICATION</h1>
            <p className="text-sm text-slate-400 mt-1">Official Personnel Check</p>
          </div>

          <div className="p-6 sm:p-8">
            {loading ? (
              <div className="flex flex-col items-center justify-center py-10 text-slate-500">
                <Loader2 className="h-8 w-8 animate-spin text-blue-900 mb-4" />
                <p>Verifying credential...</p>
              </div>
            ) : error ? (
              <div className="flex flex-col items-center justify-center py-6 text-center">
                <div className="h-16 w-16 rounded-full bg-red-100 flex items-center justify-center text-red-600 mb-4">
                  <ShieldAlert className="h-8 w-8" />
                </div>
                <h2 className="text-xl font-bold text-slate-900">Verification Failed</h2>
                <p className="text-slate-600 mt-2">{error}</p>
                <div className="mt-6 w-full rounded-xl bg-red-50 p-4 border border-red-100 text-sm text-red-800">
                  This QR code does not belong to an active GAHTO personnel. Do not trust the credential presented.
                </div>
              </div>
            ) : (
              <div className="space-y-6">
                <div className="flex justify-center">
                  <div className="h-24 w-24 rounded-full border-4 border-slate-100 bg-slate-100 overflow-hidden shadow-sm flex items-center justify-center">
                    {card.staff?.photo_url ? (
                      <img src={`${process.env.NEXT_PUBLIC_API_BASE_URL || "http://localhost:8700"}${card.staff.photo_url}`} alt="" className="h-full w-full object-cover" />
                    ) : (
                      <span className="text-2xl font-bold text-slate-400">
                        {card.staff?.first_name?.[0]}{card.staff?.last_name?.[0]}
                      </span>
                    )}
                  </div>
                </div>

                <div className="text-center">
                  <h2 className="text-2xl font-bold text-slate-900">
                    {card.staff?.first_name} {card.staff?.last_name}
                  </h2>
                  <p className="text-sm font-semibold text-red-600 uppercase tracking-widest mt-1">
                    {card.staff?.position}
                  </p>
                </div>

                <div className="rounded-xl border border-slate-100 bg-slate-50 p-4 space-y-3 text-sm">
                  <div className="flex justify-between">
                    <span className="text-slate-500">Staff ID</span>
                    <span className="font-bold text-slate-900">{card.staff?.staff_id}</span>
                  </div>
                  <div className="flex justify-between">
                    <span className="text-slate-500">Card Version</span>
                    <span className="font-semibold text-slate-700">v{card.version}</span>
                  </div>
                  <div className="flex justify-between">
                    <span className="text-slate-500">Issue Date</span>
                    <span className="font-semibold text-slate-700">
                      {new Date(card.issued_at).toLocaleDateString()}
                    </span>
                  </div>
                </div>

                {card.status === "active" ? (
                  <div className="rounded-xl bg-emerald-50 border border-emerald-200 p-4 flex items-start gap-3">
                    <CheckCircle2 className="h-5 w-5 text-emerald-600 shrink-0 mt-0.5" />
                    <div>
                      <h3 className="font-bold text-emerald-900">Active Credential</h3>
                      <p className="text-xs text-emerald-700 mt-1">
                        This individual is verified as active personnel of the Global Anti Human Trafficking Organization.
                      </p>
                    </div>
                  </div>
                ) : (
                  <div className="rounded-xl bg-red-50 border border-red-200 p-4 flex items-start gap-3">
                    <ShieldAlert className="h-5 w-5 text-red-600 shrink-0 mt-0.5" />
                    <div>
                      <h3 className="font-bold text-red-900 uppercase tracking-wide">Invalid Credential</h3>
                      <p className="text-xs text-red-700 mt-1">
                        This credential is no longer active (Status: {card.status.toUpperCase()}). Please report suspicious activity.
                      </p>
                    </div>
                  </div>
                )}
              </div>
            )}

            <div className="mt-8 text-center border-t border-slate-100 pt-6">
              <Link href="/" className="text-xs font-semibold text-blue-900 hover:underline">
                Return to GAHTO Website
              </Link>
            </div>
          </div>
        </div>
      </div>
    </main>
  );
}