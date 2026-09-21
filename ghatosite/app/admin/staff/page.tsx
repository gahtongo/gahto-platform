"use client";

import { useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import { CheckCircle2, ChevronRight, Eye, MoreHorizontal, Plus, ShieldCheck, UserPlus, XCircle } from "lucide-react";
import Link from "next/link";

export default function AdminStaffPage() {
  const router = useRouter();
  const [staff, setStaff] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);
  const [adminRole, setAdminRole] = useState("super_admin");

  useEffect(() => {
    const token = localStorage.getItem("gahto_admin_token");
    if (!token) {
      router.replace("/admin/login");
      return;
    }

    const fetchData = async () => {
      try {
        const [staffRes, meRes] = await Promise.all([
           fetch(`${process.env.NEXT_PUBLIC_API_BASE_URL}/api/v1/staff`, {
             headers: { Authorization: `Bearer ${token}` }
           }),
           fetch(`${process.env.NEXT_PUBLIC_API_BASE_URL}/api/v1/admin/me`, {
             headers: { Authorization: `Bearer ${token}` }
           })
        ]);

        if (staffRes.ok) {
          const data = await staffRes.json();
          setStaff(data);
        }
        if (meRes.ok) {
           const me = await meRes.json();
           setAdminRole(me.role);
        }
      } catch (err) {
        console.error(err);
      } finally {
        setLoading(false);
      }
    };
    fetchData();
  }, [router]);

  return (
    <div className="space-y-6">
      <div className="flex flex-col gap-4 sm:flex-row sm:items-center sm:justify-between">
        <div>
          <h1 className="text-2xl font-bold text-slate-900">Staff Management</h1>
          <p className="text-sm text-slate-500">Manage GAHTO personnel and ID cards.</p>
        </div>

        <Link
          href="/admin/staff/new"
          className="inline-flex items-center gap-2 rounded-xl bg-blue-900 px-4 py-2.5 text-sm font-semibold text-white shadow-sm hover:bg-blue-800"
        >
          <UserPlus className="h-4 w-4" />
          Add Staff Member
        </Link>
      </div>

      <div className="overflow-hidden rounded-2xl border border-slate-200 bg-white shadow-sm">
        <div className="overflow-x-auto">
          <table className="w-full text-left text-sm">
            <thead className="bg-slate-50 text-slate-600">
              <tr>
                <th className="px-6 py-4 font-semibold">Staff ID</th>
                <th className="px-6 py-4 font-semibold">Name</th>
                <th className="px-6 py-4 font-semibold">Role / Dept</th>
                <th className="px-6 py-4 font-semibold">Status</th>
                <th className="px-6 py-4 font-semibold text-right">Actions</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-slate-100 text-slate-700">
              {loading ? (
                <tr>
                  <td colSpan={5} className="py-8 text-center text-slate-500">
                    Loading staff records...
                  </td>
                </tr>
              ) : staff.length === 0 ? (
                <tr>
                  <td colSpan={5} className="py-8 text-center text-slate-500">
                    No staff records found.
                  </td>
                </tr>
              ) : (
                staff.map((member) => (
                  <tr key={member.id} className="transition hover:bg-slate-50">
                    <td className="whitespace-nowrap px-6 py-4 font-medium text-slate-900">
                      {member.staff_id}
                    </td>
                    <td className="px-6 py-4">
                      <div className="font-semibold text-slate-900">
                        {member.first_name} {member.last_name}
                      </div>
                      <div className="text-xs text-slate-500">{member.email || "No email"}</div>
                    </td>
                    <td className="px-6 py-4">
                      <div className="font-medium text-slate-900">{member.position}</div>
                      <div className="text-xs text-slate-500">{member.department || "-"}</div>
                    </td>
                    <td className="px-6 py-4">
                      {member.status === "active" && (
                        <span className="inline-flex items-center gap-1 rounded-full bg-emerald-50 px-2.5 py-1 text-xs font-semibold text-emerald-700 ring-1 ring-inset ring-emerald-600/20">
                          <CheckCircle2 className="h-3 w-3" /> Active
                        </span>
                      )}
                      {member.status === "pending_approval" && (
                        <span className="inline-flex items-center gap-1 rounded-full bg-amber-50 px-2.5 py-1 text-xs font-semibold text-amber-700 ring-1 ring-inset ring-amber-600/20">
                          Pending Approval
                        </span>
                      )}
                      {member.status === "inactive" && (
                        <span className="inline-flex items-center gap-1 rounded-full bg-slate-100 px-2.5 py-1 text-xs font-semibold text-slate-600 ring-1 ring-inset ring-slate-500/20">
                          Inactive
                        </span>
                      )}
                    </td>
                    <td className="px-6 py-4 text-right">
                      {adminRole === "super_admin" ? (
                        <Link
                          href={`/admin/staff/${member.id}`}
                          className="inline-flex items-center gap-1.5 rounded-lg border border-slate-200 bg-white px-3 py-1.5 text-xs font-semibold text-slate-700 hover:bg-slate-50"
                        >
                          <Eye className="h-3.5 w-3.5" /> View
                        </Link>
                      ) : (
                        <span className="text-xs text-slate-400 italic">No access</span>
                      )}
                    </td>
                  </tr>
                ))
              )}
            </tbody>
          </table>
        </div>
      </div>
    </div>
  );
}