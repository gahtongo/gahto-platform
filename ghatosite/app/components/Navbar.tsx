"use client";

import Link from "next/link";
import Image from "next/image";
import { useEffect, useState } from "react";
import { usePathname } from "next/navigation";
import LogoOptionsModal from "./LogoOptionsModal";
import IntroVideoModal from "./IntroVideoModal";
import {
  HeartHandshake,
  ShieldAlert,
  X,
  Menu,
  Newspaper,
  Calendar,
  Clock
} from "lucide-react";

function LiveClock() {
  const [time, setTime] = useState<Date | null>(null);

  useEffect(() => {
    setTime(new Date());
    const timer = setInterval(() => setTime(new Date()), 1000);
    return () => clearInterval(timer);
  }, []);

  if (!time) return null;

  return (
    <div className="flex items-center gap-2 sm:gap-3 px-3 sm:px-4 py-1.5 rounded-full bg-slate-50 border border-slate-100 text-[10px] sm:text-[11px] font-bold text-slate-500 uppercase tracking-wider shadow-sm animate-pulse-subtle">
      <div className="flex items-center gap-1 sm:gap-1.5 border-r border-slate-200 pr-2 sm:pr-3">
        <Calendar className="h-3 w-3 text-red-500" />
        <span className="hidden xs:inline">
          {time.toLocaleDateString("en-NG", {
            day: "numeric",
            month: "short",
          })}
        </span>
        <span className="xs:hidden">
          {time.getDate()}/{time.getMonth() + 1}
        </span>
      </div>
      <div className="flex items-center gap-1 sm:gap-1.5">
        <Clock className="h-3 w-3 text-blue-600" />
        <span className="tabular-nums">
          {time.toLocaleTimeString("en-NG", {
            hour: "numeric",
            minute: "2-digit",
          })}
        </span>
      </div>
    </div>
  );
}

export default function Navbar() {
  const pathname = usePathname();
  const [mobileOpen, setMobileOpen] = useState(false);
  const [logoModalOpen, setLogoModalOpen] = useState(false);
  const [showIntro, setShowIntro] = useState(false);
  const [seasonalSettings, setSeasonalSettings] = useState<Record<string, string>>({});
  const [today, setToday] = useState("");

  useEffect(() => {
    const apiBase = process.env.NEXT_PUBLIC_API_BASE_URL || "http://127.0.0.1:8000";
    fetch(`${apiBase}/api/v1/settings/public`)
      .then((response) => response.ok ? response.json() : [])
      .then((data: { key: string; value: string }[]) => {
        if (Array.isArray(data)) setSeasonalSettings(Object.fromEntries(data.filter((item) => item.key.startsWith("seasonal_")).map((item) => [item.key, item.value])));
      })
      .catch(() => {});
    const refreshDate = () => setToday(new Intl.DateTimeFormat("en-CA", { timeZone: "Africa/Lagos", year: "numeric", month: "2-digit", day: "2-digit" }).format(new Date()));
    refreshDate();
    const timer = setInterval(refreshDate, 60_000);
    return () => clearInterval(timer);
  }, []);

  const showChristmas = seasonalSettings.seasonal_theme === "christmas" && Boolean(today && seasonalSettings.seasonal_start && seasonalSettings.seasonal_end) && today >= seasonalSettings.seasonal_start && today <= seasonalSettings.seasonal_end;

  const navItems = [
    { name: "Home", href: "/" },
    { name: "Get Help", href: "/help" },
    { name: "Campaigns", href: "/campaigns" },
    { name: "News", href: "/news" },
    { name: "Trafficking", href: "/trafficking" },
    { name: "About", href: "/about" },
    { name: "Contact", href: "/contact" },
  ];

  useEffect(() => {
    setMobileOpen(false);
  }, [pathname]);

  useEffect(() => {
    if (!mobileOpen) {
      document.body.style.overflow = "";
      return;
    }


    const handleEsc = (event: KeyboardEvent) => {
      if (event.key === "Escape") {
        setMobileOpen(false);
      }
    };

    document.body.style.overflow = "hidden";
    document.addEventListener("keydown", handleEsc);

    return () => {
      document.body.style.overflow = "";
      document.removeEventListener("keydown", handleEsc);
    };
  }, [mobileOpen]);

  return (
    <>
      <header className="sticky top-0 z-[80] border-b border-gray-200 bg-white/92 backdrop-blur-xl shadow-sm animate-navbar-entry">
        <div className="mx-auto flex max-w-7xl flex-wrap items-center justify-between gap-y-3 px-4 py-3 sm:px-6">

          <button
            onClick={() => setLogoModalOpen(true)}
            className="group flex min-w-0 shrink-0 items-center gap-2 text-left sm:gap-3"
          >
            <div className="relative flex h-12 w-12 shrink-0 items-center justify-center rounded-xl bg-white shadow-md ring-1 ring-black/5 transition group-hover:shadow-red-500/20 sm:h-16 sm:w-16">
              <Image
                src="/logo.png"
                alt="GAHTO Logo"
                fill
                sizes="80px"
                className="object-cover transition-transform duration-300 group-hover:scale-105"
                priority
              />
              {showChristmas && <Image src="/images/seasonal/christmas-cap.svg" alt="" aria-hidden="true" width={32} height={32} className="pointer-events-none absolute -right-2 -top-2 z-10 h-7 w-7 rotate-12 sm:h-9 sm:w-9" />}
            </div>

            <div className="min-w-0 leading-tight text-left">
              <p
                className="text-xl font-extrabold tracking-tight text-blue-800 transition hover:text-red-600 sm:text-2xl"
              >
                GAHTO
              </p>

              <p className="block max-w-[150px] text-[10px] leading-tight text-slate-500 sm:max-w-[220px] sm:text-[12px] sm:font-medium">
                <span className="sm:hidden">Global Anti Human Trafficking Org.</span>
                <span className="hidden sm:inline">
                  Global Anti Human<br />Trafficking Organization
                </span>
              </p>
            </div>
          </button>

          <div className="order-3 flex w-full items-center justify-between gap-2 border-t border-slate-100 pt-2 md:order-none md:w-auto md:flex-col md:items-center md:border-0 md:pt-0">
            <LiveClock />
            <span className="text-right text-[9px] font-extrabold tracking-[0.04em] text-blue-900 sm:text-[10px] md:text-center">
              RESCUE · PROTECT · RESTORE · EMPOWER
            </span>
          </div>

          <nav className="order-4 hidden w-full items-center justify-center gap-4 border-t border-slate-100 pt-3 md:flex xl:gap-8">

            {navItems.map((item) => {
              const active = pathname === item.href;
              return (
                  <Link
                    key={item.name}
                    href={item.href}
                    className="group relative text-[14px] font-bold tracking-wide px-1 transition-colors duration-200"
                >
                  <span
                    className={`transition-colors duration-200 ${
                      active
                        ? "text-blue-900 border-b-2 border-red-500 pb-0.5"
                        : "text-gray-700 hover:text-blue-700"
                    }`}
                  >
                    {item.name}
                  </span>
                </Link>
              );
            })}

          </nav>

          <div className="hidden shrink-0 items-center gap-2 md:order-none md:flex">
            <Link
              href="/report"
              className="inline-flex items-center gap-2 rounded-xl bg-red-600 px-3.5 py-2.5 text-sm font-semibold text-white shadow-md transition hover:scale-[1.03] hover:shadow-red-500/35 sm:px-4"
            >
              <ShieldAlert className="h-4 w-4" />
              <span>Report</span>
            </Link>

            <Link
              href="/donate"
              className="inline-flex items-center gap-2 rounded-xl bg-blue-900 px-3.5 py-2.5 text-sm font-semibold text-white shadow-md transition hover:scale-[1.03] sm:px-4"
            >
              <HeartHandshake className="h-4 w-4" />
              <span>Donate</span>
            </Link>
          </div>

          <button
            type="button"
            aria-label={mobileOpen ? "Close menu" : "Open menu"}
            aria-expanded={mobileOpen}
            onClick={() => setMobileOpen((prev) => !prev)}
            className="order-2 inline-flex h-11 w-11 items-center justify-center rounded-xl border border-gray-200 bg-white text-slate-900 shadow-sm transition hover:border-red-200 hover:text-red-600 md:hidden"
          >
            {mobileOpen ? <X className="h-5 w-5" /> : <Menu className="h-5 w-5" />}
          </button>
        </div>
      </header>

      <LogoOptionsModal
        open={logoModalOpen}
        onClose={() => setLogoModalOpen(false)}
        onWatchVideo={() => setShowIntro(true)}
      />

      {showIntro && (
        <IntroVideoModal
          forceShow={true}
          onClose={() => setShowIntro(false)}
        />
      )}

      {mobileOpen && (
        <>
          <button
            type="button"
            aria-label="Close mobile menu overlay"
            onClick={() => setMobileOpen(false)}
            className="fixed inset-0 z-[85] bg-slate-950/55 backdrop-blur-[2px] md:hidden"
          />

          <div className="fixed inset-x-0 top-[112px] z-[90] mx-4 max-h-[calc(100dvh-128px)] overflow-y-auto rounded-[1.75rem] border border-slate-200 bg-white p-4 shadow-2xl md:hidden">
            <div className="mb-4 rounded-2xl bg-gradient-to-r from-blue-900 to-slate-900 px-4 py-4 text-white">
              <div className="flex items-center gap-3">
                <div className="flex h-11 w-11 items-center justify-center rounded-2xl bg-white/10">
                  <Newspaper className="h-5 w-5 text-white" />
                </div>
                <div>
                  <p className="text-sm font-semibold tracking-wide text-white/80">
                    Navigation
                  </p>
                  <p className="text-base font-bold">Explore GAHTO</p>
                </div>
              </div>
            </div>

            <nav className="space-y-2">
              {navItems.map((item) => {
                const active = pathname === item.href;

                return (
                  <Link
                    key={item.name}
                    href={item.href}
                    className={`flex items-center justify-between rounded-2xl px-4 py-3 text-sm font-semibold transition ${
                      active
                        ? "bg-blue-50 text-blue-900 ring-1 ring-blue-100"
                        : "text-slate-700 hover:bg-slate-50 hover:text-red-600"
                    }`}
                  >
                    <span>{item.name}</span>
                    {active && (
                      <span className="h-2.5 w-2.5 rounded-full bg-red-500" />
                    )}
                  </Link>
                );
              })}
            </nav>

            <div className="mt-4 grid grid-cols-2 gap-3">
              <Link
                href="/report"
                className="inline-flex items-center justify-center gap-2 rounded-2xl bg-red-600 px-4 py-3 text-sm font-semibold text-white shadow-md transition hover:bg-red-700"
              >
                <ShieldAlert className="h-4 w-4" />
                <span>Report</span>
              </Link>

              <Link
                href="/donate"
                className="inline-flex items-center justify-center gap-2 rounded-2xl bg-blue-900 px-4 py-3 text-sm font-semibold text-white shadow-md transition hover:bg-blue-800"
              >
                <HeartHandshake className="h-4 w-4" />
                <span>Donate</span>
              </Link>
            </div>
          </div>
        </>
      )}
    </>
  );
}
