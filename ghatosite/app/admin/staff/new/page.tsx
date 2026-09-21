"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import { ArrowLeft, Loader2, Save, UploadCloud } from "lucide-react";
import Link from "next/link";

export default function NewStaffPage() {
  const router = useRouter();

  const [loading, setLoading] = useState(false);
  const [error, setError] = useState("");

  const [formData, setFormData] = useState({
    first_name: "",
    middle_name: "",
    last_name: "",
    email: "",
    phone: "",
    position: "",
    department: "",
  });

  const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    setFormData({ ...formData, [e.target.name]: e.target.value });
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError("");
    setLoading(true);

    const token = localStorage.getItem("gahto_admin_token");
    if (!token) {
      router.replace("/admin/login");
      return;
    }

    try {
      const res = await fetch(`${process.env.NEXT_PUBLIC_API_BASE_URL}/api/v1/staff`, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          Authorization: `Bearer ${token}`,
        },
        body: JSON.stringify({
          ...formData,
          email: formData.email || undefined,
          phone: formData.phone || undefined,
          middle_name: formData.middle_name || undefined,
          department: formData.department || undefined,
        }),
      });

      const data = await res.json();

      if (!res.ok) {
        throw new Error(data.detail || "Failed to create staff member");
      }

      router.push(`/admin/staff/${data.id}`);
    } catch (err: any) {
      setError(err.message);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="mx-auto max-w-3xl space-y-6">
      <div className="flex items-center gap-3">
        <Link href="/admin/staff" className="flex h-10 w-10 items-center justify-center rounded-xl bg-white text-slate-500 shadow-sm transition hover:bg-slate-50 hover:text-slate-900">
          <ArrowLeft className="h-5 w-5" />
        </Link>
        <div>
          <h1 className="text-2xl font-bold text-slate-900">Add Staff Member</h1>
          <p className="text-sm text-slate-500">Create a new GAHTO personnel record.</p>
        </div>
      </div>

      <form onSubmit={handleSubmit} className="space-y-6 rounded-2xl border border-slate-200 bg-white p-6 shadow-sm sm:p-8">

        {error && (
          <div className="rounded-xl border border-red-200 bg-red-50 p-4 text-sm text-red-700">
            {error}
          </div>
        )}

        <div className="grid gap-6 sm:grid-cols-2">
          <div className="space-y-1.5 sm:col-span-2">
            <h3 className="text-sm font-bold text-slate-900">Personal Information</h3>
            <div className="h-px w-full bg-slate-100"></div>
          </div>

          <div className="space-y-1.5">
            <label className="text-sm font-semibold text-slate-700">First Name *</label>
            <input
              required
              type="text"
              name="first_name"
              value={formData.first_name}
              onChange={handleChange}
              className="w-full rounded-xl border border-slate-200 bg-slate-50 px-4 py-2.5 text-sm outline-none focus:border-blue-900 focus:bg-white"
            />
          </div>

          <div className="space-y-1.5">
            <label className="text-sm font-semibold text-slate-700">Middle Name</label>
            <input
              type="text"
              name="middle_name"
              value={formData.middle_name}
              onChange={handleChange}
              className="w-full rounded-xl border border-slate-200 bg-slate-50 px-4 py-2.5 text-sm outline-none focus:border-blue-900 focus:bg-white"
            />
          </div>

          <div className="space-y-1.5">
            <label className="text-sm font-semibold text-slate-700">Last Name *</label>
            <input
              required
              type="text"
              name="last_name"
              value={formData.last_name}
              onChange={handleChange}
              className="w-full rounded-xl border border-slate-200 bg-slate-50 px-4 py-2.5 text-sm outline-none focus:border-blue-900 focus:bg-white"
            />
          </div>

          <div className="space-y-1.5 sm:col-span-2 mt-4">
            <h3 className="text-sm font-bold text-slate-900">Professional Details</h3>
            <div className="h-px w-full bg-slate-100"></div>
          </div>

          <div className="space-y-1.5">
            <label className="text-sm font-semibold text-slate-700">Job Title / Position *</label>
            <input
              required
              type="text"
              name="position"
              value={formData.position}
              onChange={handleChange}
              placeholder="e.g. Lead Investigator"
              className="w-full rounded-xl border border-slate-200 bg-slate-50 px-4 py-2.5 text-sm outline-none focus:border-blue-900 focus:bg-white"
            />
          </div>

          <div className="space-y-1.5">
            <label className="text-sm font-semibold text-slate-700">Department / Unit</label>
            <input
              type="text"
              name="department"
              value={formData.department}
              onChange={handleChange}
              placeholder="e.g. Field Operations"
              className="w-full rounded-xl border border-slate-200 bg-slate-50 px-4 py-2.5 text-sm outline-none focus:border-blue-900 focus:bg-white"
            />
          </div>

          <div className="space-y-1.5 sm:col-span-2 mt-4">
            <h3 className="text-sm font-bold text-slate-900">Contact Information (Optional)</h3>
            <div className="h-px w-full bg-slate-100"></div>
          </div>

          <div className="space-y-1.5">
            <label className="text-sm font-semibold text-slate-700">Official Email</label>
            <input
              type="email"
              name="email"
              value={formData.email}
              onChange={handleChange}
              className="w-full rounded-xl border border-slate-200 bg-slate-50 px-4 py-2.5 text-sm outline-none focus:border-blue-900 focus:bg-white"
            />
          </div>

          <div className="space-y-1.5">
            <label className="text-sm font-semibold text-slate-700">Phone Number</label>
            <input
              type="text"
              name="phone"
              value={formData.phone}
              onChange={handleChange}
              className="w-full rounded-xl border border-slate-200 bg-slate-50 px-4 py-2.5 text-sm outline-none focus:border-blue-900 focus:bg-white"
            />
          </div>
        </div>

        <div className="flex items-center justify-end gap-3 pt-6">
          <Link
            href="/admin/staff"
            className="rounded-xl border border-slate-200 px-5 py-2.5 text-sm font-semibold text-slate-600 transition hover:bg-slate-50"
          >
            Cancel
          </Link>
          <button
            type="submit"
            disabled={loading}
            className="inline-flex items-center gap-2 rounded-xl bg-blue-900 px-6 py-2.5 text-sm font-semibold text-white shadow-sm transition hover:bg-blue-800 disabled:opacity-50"
          >
            {loading ? <Loader2 className="h-4 w-4 animate-spin" /> : <Save className="h-4 w-4" />}
            {loading ? "Saving..." : "Save Staff Member"}
          </button>
        </div>
      </form>
    </div>
  );
}