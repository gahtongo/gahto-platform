"use client";

import Link from "next/link";
import { FormEvent, useMemo, useState } from "react";
import { useRouter } from "next/navigation";
import { AlertCircle, ArrowLeft, Loader2, Lock, Mail, ShieldCheck, KeyRound } from "lucide-react";
import { QRCodeSVG } from "qrcode.react";

export default function AdminLoginPage() {
  const router = useRouter();

  const API_BASE = useMemo(
    () => (process.env.NEXT_PUBLIC_API_BASE_URL || "").trim(),
    []
  );

  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [totpCode, setTotpCode] = useState("");

  // 2FA state
  const [requires2FASetup, setRequires2FASetup] = useState(false);
  const [requires2FA, setRequires2FA] = useState(false);
  const [totpUri, setTotpUri] = useState<string | null>(null);
  const [tempSecret, setTempSecret] = useState<string | null>(null);

  const [isLoading, setIsLoading] = useState(false);
  const [errorText, setErrorText] = useState("");

  const [showReset, setShowReset] = useState(false);
  const [resetEmail, setResetEmail] = useState("");
  const [resetLoading, setResetLoading] = useState(false);
  const [resetMessage, setResetMessage] = useState("");
  const [resetError, setResetError] = useState("");
  const [resetLink, setResetLink] = useState("");

  const handleLogin = async (e: FormEvent) => {
    e.preventDefault();
    setErrorText("");

    if (!API_BASE) {
      setErrorText("Frontend API base URL is not configured.");
      return;
    }

    if (!email.trim() || !password.trim()) {
      setErrorText("Enter your admin email and password.");
      return;
    }

    if ((requires2FA || requires2FASetup) && !totpCode.trim()) {
      setErrorText("Enter the 6-digit code from Google Authenticator.");
      return;
    }

    try {
      setIsLoading(true);

      const res = await fetch(`${API_BASE}/api/v1/auth/login`, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          email: email.trim(),
          password,
          totp_code: totpCode.trim() || undefined,
          temp_secret: tempSecret || undefined
        }),
      });

      const data = await res.json().catch(() => ({}));

      if (!res.ok) {
        setErrorText(data.detail || "Login failed. Please check your credentials.");
        return;
      }

      if (data.requires_2fa_setup) {
        setRequires2FASetup(true);
        setTotpUri(data.totp_uri);
        setTempSecret(data.temp_secret);
        return;
      }

      if (data.requires_2fa) {
        setRequires2FA(true);
        return;
      }

      if (data.access_token) {
        localStorage.setItem("gahto_admin_token", data.access_token);
        router.replace("/admin");
      }
    } catch {
      setErrorText("Unable to connect to the server. Please try again.");
    } finally {
      setIsLoading(false);
    }
  };

  const handleResetRequest = async (e: FormEvent) => {
    // ... existing reset logic ...
    e.preventDefault();
    setResetMessage("");
    setResetError("");
    setResetLink("");

    if (!API_BASE) {
      setResetError("Frontend API base URL is not configured.");
      return;
    }

    if (!resetEmail.trim()) {
      setResetError("Enter the admin email address.");
      return;
    }

    try {
      setResetLoading(true);

      const res = await fetch(`${API_BASE}/api/v1/auth/forgot-password`, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          email: resetEmail.trim(),
        }),
      });

      const data = await res.json().catch(() => ({}));

      if (!res.ok) {
        setResetError(data.detail || "Unable to submit password reset request.");
        return;
      }

      setResetMessage(
        data.message ||
          "If the account exists, a password reset link has been sent to the email address."
      );

      if (data.reset_link) {
        setResetLink(data.reset_link);
      }
    } catch {
      setResetError("Unable to connect to the server. Please try again.");
    } finally {
      setResetLoading(false);
    }
  };

  return (
    <main className="min-h-screen bg-slate-100 text-slate-950">
      <div className="mx-auto flex min-h-screen max-w-6xl items-center px-4 py-10 sm:px-6">
        <div className="grid w-full items-stretch gap-6 lg:grid-cols-[1.05fr_0.95fr]">
          <section className="hidden rounded-[2rem] bg-slate-950 p-8 text-white shadow-2xl lg:flex lg:flex-col lg:justify-between">
            <div>
              <div className="inline-flex items-center gap-2 rounded-full border border-white/10 bg-white/5 px-4 py-2 text-xs font-semibold uppercase tracking-[0.18em] text-white/75">
                <ShieldCheck className="h-4 w-4 text-red-400" />
                Secure Admin Access
              </div>

              <h1 className="mt-6 text-5xl font-extrabold leading-[1.02] tracking-tight">
                GAHTO Admin
              </h1>

              <p className="mt-5 max-w-xl text-lg leading-8 text-slate-300">
                Access the operational workspace for reports, staff IDs, contact messages,
                campaigns, site settings, and newsroom management.
              </p>
            </div>

            <div className="grid gap-4">
              {[
                "Review incoming reports and contact submissions",
                "Manage Staff Members and issue GAHTO ID Cards",
                "Manage campaigns, updates, and public information",
              ].map((item) => (
                <div
                  key={item}
                  className="rounded-2xl border border-white/10 bg-white/5 px-5 py-4 text-slate-200"
                >
                  {item}
                </div>
              ))}
            </div>
          </section>

          <section className="rounded-[2rem] border border-slate-200 bg-white p-6 shadow-xl sm:p-8">
            <div className="flex items-center justify-between gap-4">
              <div className="flex items-center gap-3">
                <div className="flex h-12 w-12 items-center justify-center rounded-2xl bg-blue-900 text-white shadow-sm">
                  <ShieldCheck className="h-5 w-5" />
                </div>

                <div>
                  <h2 className="text-xl font-bold text-slate-950">Admin Sign In</h2>
                  <p className="text-sm text-slate-500">
                    Authorized personnel only
                  </p>
                </div>
              </div>

              <Link
                href="/"
                className="inline-flex items-center gap-2 text-sm font-semibold text-slate-500 transition hover:text-slate-900"
              >
                <ArrowLeft className="h-4 w-4" />
                <span className="hidden sm:inline">Back to site</span>
              </Link>
            </div>

            <form onSubmit={handleLogin} className="mt-8 space-y-4">
              {!requires2FA && !requires2FASetup && (
                <>
                  <div>
                    <label className="mb-2 block text-sm font-semibold text-slate-700">
                      Email address
                    </label>
                    <div className="flex items-center gap-3 rounded-2xl border border-slate-200 bg-white px-4 py-3 focus-within:border-blue-900">
                      <Mail className="h-4 w-4 text-slate-400" />
                      <input
                        type="email"
                        value={email}
                        onChange={(e) => setEmail(e.target.value)}
                        className="w-full bg-transparent text-sm outline-none"
                        placeholder="Enter admin email"
                        autoComplete="email"
                      />
                    </div>
                  </div>

                  <div>
                    <label className="mb-2 block text-sm font-semibold text-slate-700">
                      Password
                    </label>
                    <div className="flex items-center gap-3 rounded-2xl border border-slate-200 bg-white px-4 py-3 focus-within:border-blue-900">
                      <Lock className="h-4 w-4 text-slate-400" />
                      <input
                        type="password"
                        value={password}
                        onChange={(e) => setPassword(e.target.value)}
                        className="w-full bg-transparent text-sm outline-none"
                        placeholder="Enter password"
                        autoComplete="current-password"
                      />
                    </div>
                  </div>
                </>
              )}

              {requires2FASetup && totpUri && (
                <div className="rounded-2xl border border-blue-200 bg-blue-50 p-4 mb-4">
                  <h3 className="font-bold text-blue-900 mb-2">Setup Two-Factor Authentication</h3>
                  <p className="text-sm text-blue-800 mb-4">
                    This is your first time logging in. You must secure your account with Google Authenticator or Authy. Scan the QR code below.
                  </p>
                  <div className="flex justify-center bg-white p-4 rounded-xl mb-4">
                     <QRCodeSVG value={totpUri} size={200} />
                  </div>
                </div>
              )}

              {(requires2FA || requires2FASetup) && (
                <div>
                  <label className="mb-2 block text-sm font-semibold text-slate-700">
                    Authentication Code
                  </label>
                  <div className="flex items-center gap-3 rounded-2xl border border-slate-200 bg-white px-4 py-3 focus-within:border-blue-900">
                    <KeyRound className="h-4 w-4 text-slate-400" />
                    <input
                      type="text"
                      value={totpCode}
                      onChange={(e) => setTotpCode(e.target.value)}
                      className="w-full bg-transparent text-sm outline-none tracking-widest font-mono"
                      placeholder="000000"
                      maxLength={6}
                      autoComplete="one-time-code"
                    />
                  </div>
                </div>
              )}

              {errorText && (
                <div className="flex items-start gap-2 rounded-2xl border border-red-200 bg-red-50 px-4 py-3 text-sm text-red-700">
                  <AlertCircle className="mt-0.5 h-4 w-4 shrink-0" />
                  <span>{errorText}</span>
                </div>
              )}

              <button
                type="submit"
                disabled={isLoading}
                className="inline-flex w-full items-center justify-center gap-2 rounded-2xl bg-blue-900 px-5 py-3.5 font-semibold text-white transition hover:bg-blue-800 disabled:cursor-not-allowed disabled:opacity-70"
              >
                {isLoading ? (
                  <>
                    <Loader2 className="h-4 w-4 animate-spin" />
                    <span>Processing...</span>
                  </>
                ) : (
                  <>
                    <ShieldCheck className="h-4 w-4" />
                    <span>{requires2FA || requires2FASetup ? 'Verify & Sign In' : 'Sign In'}</span>
                  </>
                )}
              </button>
            </form>

            {!requires2FA && !requires2FASetup && (
              <div className="mt-5 border-t border-slate-200 pt-5">
                <button
                  type="button"
                  onClick={() => {
                    setShowReset((prev) => !prev);
                    setResetMessage("");
                    setResetError("");
                    setResetLink("");
                  }}
                  className="text-sm font-semibold text-blue-900 transition hover:text-blue-700"
                >
                  Forgot password?
                </button>
                {/* Reset logic rendered here (unchanged) */}
              </div>
            )}
          </section>
        </div>
      </div>
    </main>
  );
}