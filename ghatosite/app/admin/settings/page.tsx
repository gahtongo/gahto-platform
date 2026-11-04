"use client";

import { useEffect, useMemo, useState } from "react";
import { useAuthApi } from "@/hooks/useAuthApi";
import {
  CheckCircle2,
  Globe,
  Loader2,
  Mail,
  MapPin,
  MessageCircleHeart,
  PhoneCall,
  Save,
  Settings2,
  ShieldAlert,
  Sparkles,
  XCircle,
} from "lucide-react";

type Setting = {
  id: number;
  key: string;
  value: string;
  description?: string;
  is_public: boolean;
};

type SettingsMap = Record<string, Setting>;

const orderedKeys = [
  "founder_signature",
  "whatsapp_number",
  "emergency_phone",
  "nigeria_office_phone",
  "mali_office_phone",
  "support_email",
  "intro_video_url",
  "facebook_url",
  "twitter_url",
  "nigeria_office_address",
  "abuja_office_address",
  "mali_office_address",
  "impact_cases_reported",
  "impact_victims_supported",
  "impact_communities_reached",
  "impact_volunteers",
  "seasonal_theme",
  "seasonal_start",
  "seasonal_end",
];

const keyMeta: Record<
  string,
  {
    label: string;
    helper: string;
    icon: React.ComponentType<{ className?: string }>;
    group: "Emergency & Support" | "Office Lines" | "Social Channels" | "System Config" | "Our Impact" | "Seasonal Branding";
    placeholder: string;
    type?: "text" | "file" | "date" | "theme";
  }
> = {
  impact_cases_reported: { label: "Cases Reported", helper: "Approved public impact figure.", icon: Settings2, group: "Our Impact", placeholder: "2,000+" },
  impact_victims_supported: { label: "Victims Supported", helper: "Approved public impact figure.", icon: Settings2, group: "Our Impact", placeholder: "250+" },
  impact_communities_reached: { label: "Communities Reached", helper: "Approved public impact figure.", icon: Settings2, group: "Our Impact", placeholder: "50+" },
  impact_volunteers: { label: "Volunteers", helper: "Approved public impact figure.", icon: Settings2, group: "Our Impact", placeholder: "150+" },
  seasonal_theme: { label: "Decoration", helper: "Choose a decorative accent; the official GAHTO logo remains unchanged.", icon: Sparkles, group: "Seasonal Branding", placeholder: "Off", type: "theme" },
  seasonal_start: { label: "Start date", helper: "First date the decoration may appear.", icon: Sparkles, group: "Seasonal Branding", placeholder: "YYYY-MM-DD", type: "date" },
  seasonal_end: { label: "End date", helper: "Decoration automatically disappears after this date.", icon: Sparkles, group: "Seasonal Branding", placeholder: "YYYY-MM-DD", type: "date" },
  founder_signature: {
    label: "Founder Signature",
    helper: "Upload the signature image for the back of the GAHTO ID Cards.",
    icon: Settings2,
    group: "System Config",
    placeholder: "Upload PNG/JPG",
    type: "file",
  },
  whatsapp_number: {
    label: "WhatsApp Number",
    helper: "Primary WhatsApp support line used on the public site.",
    icon: MessageCircleHeart,
    group: "Emergency & Support",
    placeholder: "+2348000000000",
  },
  emergency_phone: {
    label: "Emergency Phone",
    helper: "Main emergency reporting line for urgent outreach.",
    icon: ShieldAlert,
    group: "Emergency & Support",
    placeholder: "+2348000000000",
  },
  nigeria_office_phone: {
    label: "Nigeria Office Phone",
    helper: "Displayed on the contact page and quick call options.",
    icon: PhoneCall,
    group: "Office Lines",
    placeholder: "+2348000000000",
  },
  mali_office_phone: {
    label: "Mali Office Phone",
    helper: "Displayed for Mali office contact and outreach.",
    icon: PhoneCall,
    group: "Office Lines",
    placeholder: "+22370000000",
  },
  support_email: {
    label: "Support Email",
    helper: "Main support inbox shown across the website.",
    icon: Mail,
    group: "Emergency & Support",
    placeholder: "info@gahto.org",
  },
  intro_video_url: {
    label: "Intro Video URL",
    helper: "Path or URL for the landing page intro video.",
    icon: Sparkles,
    group: "Emergency & Support",
    placeholder: "/vid/intro_vid.mp4",
  },
  facebook_url: {
    label: "Facebook URL",
    helper: "Official public Facebook page link.",
    icon: Globe,
    group: "Social Channels",
    placeholder: "https://facebook.com/...",
  },
  twitter_url: {
    label: "Twitter / X URL",
    helper: "Official X account for updates and announcements.",
    icon: Globe,
    group: "Social Channels",
    placeholder: "https://x.com/...",
  },
  nigeria_office_address: {
    label: "Nigeria Office Address (Ado)",
    helper: "Full address for the Ado Ekiti office.",
    icon: MapPin,
    group: "Office Lines",
    placeholder: "2 Onola Balemo Quarters, Ado Ekiti",
  },
  abuja_office_address: {
    label: "Abuja Office Address",
    helper: "Full address for the Abuja office.",
    icon: MapPin,
    group: "Office Lines",
    placeholder: "No 4, MukB Estate...",
  },
  mali_office_address: {
    label: "Mali Office Address",
    helper: "Full address for the Mali office.",
    icon: MapPin,
    group: "Office Lines",
    placeholder: "5em plaque, Garantiguibougou, Bamako, Mali",
  },
};

export default function AdminSettingsPage() {
  const API_BASE =
    process.env.NEXT_PUBLIC_API_BASE_URL || "http://127.0.0.1:8000";

  const authFetch = useAuthApi();
  const assetUrl = (value: string) => value.startsWith("/") ? `${API_BASE}${value}` : value;

  const [settings, setSettings] = useState<SettingsMap>({});
  const [loading, setLoading] = useState(true);
  const [savingKey, setSavingKey] = useState<string | null>(null);
  const [statusText, setStatusText] = useState("");
  const [errorText, setErrorText] = useState("");

  const fetchSettings = async () => {
    try {
      setLoading(true);
      setErrorText("");
      setStatusText("");

      const res = await authFetch(`${API_BASE}/api/v1/settings/admin`, {
        cache: "no-store",
      });

      const data = await res.json();

      if (!res.ok) {
        setErrorText(data.detail || "Failed to load settings.");
        return;
      }

      const mapped = (Array.isArray(data) ? data : []).reduce<SettingsMap>(
        (acc, item) => {
          acc[item.key] = item;
          return acc;
        },
        {}
      );

      setSettings(mapped);
    } catch {
      setErrorText("Unable to load settings right now.");
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchSettings();
  }, []);

  const updateValue = (key: string, value: string) => {
    setSettings((prev) => ({
      ...prev,
      [key]: {
        ...prev[key],
        value,
      },
    }));
  };

  const uploadFileSetting = async (key: string, file: File) => {
    try {
      setSavingKey(key);
      setStatusText("");
      setErrorText("");

      const formData = new FormData();
      formData.append("file", file);

      const res = await authFetch(`${API_BASE}/api/v1/settings/admin/upload?key=${key}`, {
        method: "POST",
        body: formData,
      });

      const data = await res.json();

      if (!res.ok) {
        setErrorText(data.detail || "Failed to upload setting file.");
        return;
      }

      setSettings((prev) => ({
        ...prev,
        [key]: data,
      }));
      setStatusText(`${keyMeta[key]?.label || key} uploaded successfully.`);
    } catch {
      setErrorText("Unable to upload setting right now.");
    } finally {
      setSavingKey(null);
    }
  };

  const saveSetting = async (key: string) => {
    const setting = settings[key];
    if (!setting && !keyMeta[key]) return;
    const value = setting?.value?.trim() || "";
    if (key.startsWith("impact_") && !/^\d[\d,]*\+?$/.test(value)) {
      setErrorText("Enter a number such as 250+ or 2,000+.");
      return;
    }
    if (key === "seasonal_theme" && !["off", "christmas"].includes(value)) {
      setErrorText("Choose Off or Christmas.");
      return;
    }
    if ((key === "seasonal_start" || key === "seasonal_end") && value && !/^\d{4}-\d{2}-\d{2}$/.test(value)) {
      setErrorText("Enter a valid date in YYYY-MM-DD format.");
      return;
    }

    try {
      setSavingKey(key);
      setStatusText("");
      setErrorText("");

      const exists = Boolean(setting?.id);
      const res = await authFetch(exists ? `${API_BASE}/api/v1/settings/admin/${key}` : `${API_BASE}/api/v1/settings/admin`, {
        method: exists ? "PUT" : "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          ...(exists ? { value } : { key, value, is_public: true, description: keyMeta[key].helper }),
        }),
      });

      const data = await res.json();

      if (!res.ok) {
        setErrorText(data.detail || "Failed to save setting.");
        return;
      }

      setSettings((prev) => ({
        ...prev,
        [key]: data,
      }));
      setStatusText(`${keyMeta[key]?.label || key} updated successfully.`);
    } catch {
      setErrorText("Unable to save setting right now.");
    } finally {
      setSavingKey(null);
    }
  };

  const groupedSections = useMemo(() => {
    const sections: Record<string, string[]> = {
      "System Config": [],
      "Emergency & Support": [],
      "Office Lines": [],
      "Social Channels": [],
      "Our Impact": [],
      "Seasonal Branding": [],
    };

    orderedKeys.forEach((key) => {
      if ((settings[key] || key.startsWith("impact_") || key.startsWith("seasonal_")) && keyMeta[key]) {
        sections[keyMeta[key].group].push(key);
      }
    });

    return sections;
  }, [settings]);

  const stats = useMemo(() => {
    const available = orderedKeys.filter((key) => !!settings[key]).length;
    const publicCount = orderedKeys.filter(
      (key) => settings[key]?.is_public
    ).length;

    return {
      total: available,
      publicCount,
      emergencyReady:
        !!settings.emergency_phone?.value && !!settings.whatsapp_number?.value,
    };
  }, [settings]);

  return (
    <div className="space-y-6">
      <section className="rounded-[2rem] border border-slate-200 bg-white p-6 shadow-sm sm:p-8">
        <div className="flex flex-col gap-6 lg:flex-row lg:items-start lg:justify-between">
          <div>
            <p className="text-sm font-semibold uppercase tracking-[0.16em] text-blue-900">
              Site Control Center
            </p>
            <h2 className="mt-3 text-3xl font-bold tracking-tight text-slate-950">
              Public contact and channel settings
            </h2>
            <p className="mt-4 max-w-3xl leading-relaxed text-slate-600">
              Manage the live numbers, support email, social channels, and public
              communication endpoints displayed across GAHTO’s website.
            </p>

            <div className="mt-5 inline-flex items-center gap-2 rounded-2xl border border-violet-200 bg-violet-50 px-4 py-3 text-sm font-semibold text-violet-700">
              <Sparkles className="h-4 w-4" />
              <span>Premium admin control layer</span>
            </div>
          </div>

          <div className="grid grid-cols-2 gap-3 sm:grid-cols-3">
            <div className="rounded-2xl border border-slate-200 bg-slate-50 px-4 py-3 text-center">
              <p className="text-xs font-semibold uppercase tracking-[0.14em] text-slate-500">
                Loaded
              </p>
              <p className="mt-2 text-2xl font-bold text-slate-950">
                {stats.total}
              </p>
            </div>

            <div className="rounded-2xl border border-slate-200 bg-slate-50 px-4 py-3 text-center">
              <p className="text-xs font-semibold uppercase tracking-[0.14em] text-slate-500">
                Public
              </p>
              <p className="mt-2 text-2xl font-bold text-slate-950">
                {stats.publicCount}
              </p>
            </div>

            <div className="rounded-2xl border border-slate-200 bg-slate-50 px-4 py-3 text-center col-span-2 sm:col-span-1">
              <p className="text-xs font-semibold uppercase tracking-[0.14em] text-slate-500">
                Emergency
              </p>
              <p
                className={`mt-2 text-sm font-bold ${
                  stats.emergencyReady ? "text-emerald-600" : "text-amber-600"
                }`}
              >
                {stats.emergencyReady ? "Ready" : "Needs review"}
              </p>
            </div>
          </div>
        </div>
      </section>

      {(statusText || errorText) && (
        <div className="space-y-3">
          {statusText && (
            <div className="flex items-start gap-2 rounded-2xl border border-emerald-200 bg-emerald-50 px-4 py-3 text-sm text-emerald-700">
              <CheckCircle2 className="mt-0.5 h-4 w-4 shrink-0" />
              <span>{statusText}</span>
            </div>
          )}

          {errorText && (
            <div className="flex items-start gap-2 rounded-2xl border border-red-200 bg-red-50 px-4 py-3 text-sm text-red-700">
              <XCircle className="mt-0.5 h-4 w-4 shrink-0" />
              <span>{errorText}</span>
            </div>
          )}
        </div>
      )}

      {loading ? (
        <section className="rounded-[2rem] border border-slate-200 bg-white p-10 shadow-sm">
          <div className="flex min-h-[220px] items-center justify-center">
            <div className="inline-flex items-center gap-3 text-slate-600">
              <Loader2 className="h-5 w-5 animate-spin" />
              <span>Loading settings...</span>
            </div>
          </div>
        </section>
      ) : (
        Object.entries(groupedSections).map(([sectionTitle, keys]) => (
          <section
            key={sectionTitle}
            className="rounded-[2rem] border border-slate-200 bg-white p-6 shadow-sm sm:p-8"
          >
            <div className="mb-6 flex items-center gap-3">
              <div className="flex h-11 w-11 items-center justify-center rounded-2xl bg-blue-50 text-blue-900">
                <Settings2 className="h-5 w-5" />
              </div>
              <div>
                <p className="text-lg font-bold text-slate-900">
                  {sectionTitle}
                </p>
                <p className="text-sm text-slate-500">
                  Update the public-facing values for this section.
                </p>
              </div>
            </div>

            <div className="grid gap-4">
              {keys.map((key) => {
                const setting = settings[key];
                const meta = keyMeta[key];
                const Icon = meta.icon;

                return (
                  <div
                    key={key}
                    className="rounded-[1.5rem] border border-slate-200 bg-slate-50/70 p-5"
                  >
                    <div className="flex flex-col gap-4 lg:flex-row lg:items-start lg:justify-between">
                      <div className="flex min-w-0 gap-4">
                        <div className="flex h-12 w-12 shrink-0 items-center justify-center rounded-2xl bg-white text-blue-900 shadow-sm">
                          <Icon className="h-5 w-5" />
                        </div>

                        <div className="min-w-0">
                          <p className="font-semibold text-slate-900">
                            {meta.label}
                          </p>
                          <p className="mt-1 text-sm leading-6 text-slate-500">
                            {meta.helper}
                          </p>
                          <p className="mt-2 text-xs font-semibold uppercase tracking-[0.14em] text-slate-400">
                            Key: {key}
                          </p>
                        </div>
                      </div>

                      <div className="flex min-w-0 flex-1 flex-col gap-3 lg:max-w-2xl">
                        {meta.type === "file" ? (
                           <div className="flex flex-col gap-2">
                              {setting?.value && (
                                <img src={assetUrl(setting.value)} alt="preview" className="h-16 w-auto object-contain border rounded-md p-1 bg-white mb-2" />
                              )}
                              <input
                                type="file"
                                accept="image/png, image/jpeg, image/webp"
                                onChange={(e) => {
                                  if (e.target.files?.[0]) uploadFileSetting(key, e.target.files[0]);
                                }}
                                className="w-full text-sm text-slate-500 file:mr-4 file:py-2 file:px-4 file:rounded-xl file:border-0 file:text-sm file:font-semibold file:bg-blue-50 file:text-blue-700 hover:file:bg-blue-100"
                              />
                           </div>
                        ) : meta.type === "theme" ? (
                          <select value={setting?.value || "off"} onChange={(e) => updateValue(key, e.target.value)} className="w-full rounded-2xl border border-slate-200 bg-white px-4 py-3 text-sm text-slate-900">
                            <option value="off">Off</option>
                            <option value="christmas">Christmas cap</option>
                          </select>
                        ) : (
                          <input
                            type={meta.type === "date" ? "date" : "text"}
                            value={setting?.value || ""}
                            onChange={(e) => updateValue(key, e.target.value)}
                            placeholder={meta.placeholder}
                            className="w-full rounded-2xl border border-slate-200 bg-white px-4 py-3 text-sm text-slate-900 outline-none transition focus:border-blue-900 focus:ring-2 focus:ring-blue-900/15"
                          />
                        )}

                        <div className="flex flex-wrap items-center gap-3">
                          <span
                            className={`rounded-full px-3 py-1 text-[11px] font-semibold uppercase tracking-[0.14em] ${
                              setting?.is_public
                                ? "bg-emerald-50 text-emerald-700"
                                : "bg-slate-100 text-slate-700"
                            }`}
                          >
                            {setting?.is_public ? "Public" : "Private"}
                          </span>

                          <button
                            type="button"
                            onClick={() => saveSetting(key)}
                            disabled={savingKey === key}
                            className="inline-flex items-center gap-2 rounded-xl bg-blue-900 px-4 py-2.5 text-sm font-semibold text-white transition hover:bg-blue-800 disabled:opacity-70"
                          >
                            {savingKey === key ? (
                              <Loader2 className="h-4 w-4 animate-spin" />
                            ) : (
                              <Save className="h-4 w-4" />
                            )}
                            <span>
                              {savingKey === key ? "Saving..." : "Save"}
                            </span>
                          </button>
                        </div>
                      </div>
                    </div>
                  </div>
                );
              })}
            </div>
          </section>
        ))
      )}
    </div>
  );
}
