"use client";

import { useEffect, useState } from "react";
import { useParams, useRouter } from "next/navigation";
import { ArrowLeft, CheckCircle2, ChevronLeft, CreditCard, Download, Eye, Loader2, Printer, QrCode, ShieldAlert, ShieldCheck, UploadCloud, Edit3, Save, X } from "lucide-react";
import Link from "next/link";
import { QRCodeSVG } from "qrcode.react";

export default function StaffDetail() {
  const { id } = useParams();
  const router = useRouter();

  const [member, setMember] = useState<any>(null);
  const [cards, setCards] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);
  const [issuing, setIssuing] = useState(false);
  const [approving, setApproving] = useState(false);
  const [error, setError] = useState("");
  const [adminRole, setAdminRole] = useState("super_admin");

  // Edit Mode state
  const [isEditing, setIsEditing] = useState(false);
  const [editForm, setEditForm] = useState<any>({});
  const [auditReason, setAuditReason] = useState("");
  const [savingEdit, setSavingEdit] = useState(false);

  // Photo upload
  const [uploadingPhoto, setUploadingPhoto] = useState(false);

  const fetchStaffData = async (token: string) => {
    try {
      const [staffRes, cardsRes, meRes] = await Promise.all([
        fetch(`${process.env.NEXT_PUBLIC_API_BASE_URL}/api/v1/staff/${id}`, {
          headers: { Authorization: `Bearer ${token}` }
        }),
        fetch(`${process.env.NEXT_PUBLIC_API_BASE_URL}/api/v1/staff/${id}/cards`, {
          headers: { Authorization: `Bearer ${token}` }
        }),
        fetch(`${process.env.NEXT_PUBLIC_API_BASE_URL}/api/v1/admin/me`, {
          headers: { Authorization: `Bearer ${token}` }
        })
      ]);

      if (staffRes.ok) {
        const data = await staffRes.json();
        setMember(data);
        setEditForm(data);
      }
      if (cardsRes.ok) setCards(await cardsRes.json());
      if (meRes.ok) {
        const me = await meRes.json();
        if (me.role !== "super_admin") {
           // Prevent Content Admins from viewing profile
           router.replace("/admin/staff");
           return;
        }
        setAdminRole(me.role);
      }
    } catch (err) {
      setError("Failed to load staff data.");
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    const token = localStorage.getItem("gahto_admin_token");
    if (!token) {
      router.replace("/admin/login");
      return;
    }
    fetchStaffData(token);
  }, [id, router]);

  const handleApprove = async () => {
    const token = localStorage.getItem("gahto_admin_token");
    setApproving(true);
    try {
      const res = await fetch(`${process.env.NEXT_PUBLIC_API_BASE_URL}/api/v1/staff/${id}`, {
        method: "PUT",
        headers: {
          "Content-Type": "application/json",
          Authorization: `Bearer ${token}`,
        },
        body: JSON.stringify({ status: "active" })
      });
      if (!res.ok) {
        const data = await res.json();
        throw new Error(data.detail || "Failed to approve.");
      }
      await fetchStaffData(token!);
    } catch (err: any) {
      alert(err.message);
    } finally {
      setApproving(false);
    }
  };

  const handleIssueCard = async () => {
    // Enforce photo before issuing
    if (!member.photo_url) {
      alert("You must upload a staff photo before issuing an ID card.");
      return;
    }

    const token = localStorage.getItem("gahto_admin_token");
    setIssuing(true);
    try {
      const res = await fetch(`${process.env.NEXT_PUBLIC_API_BASE_URL}/api/v1/staff/${id}/cards/issue`, {
        method: "POST",
        headers: { Authorization: `Bearer ${token}` }
      });
      if (!res.ok) {
        const data = await res.json();
        throw new Error(data.detail || "Failed to issue card.");
      }
      await fetchStaffData(token!);
    } catch (err: any) {
      alert(err.message);
    } finally {
      setIssuing(false);
    }
  };

  const handleEditSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!auditReason.trim()) {
      alert("Please provide a reason for these changes (Audit trail).");
      return;
    }
    const token = localStorage.getItem("gahto_admin_token");
    setSavingEdit(true);
    try {
      // We could log the auditReason to a specific audit endpoint, but for now we just pass it or save it in notes
      const payload = {
        first_name: editForm.first_name,
        last_name: editForm.last_name,
        email: editForm.email || undefined,
        phone: editForm.phone || undefined,
        position: editForm.position,
        department: editForm.department || undefined
      };
      const res = await fetch(`${process.env.NEXT_PUBLIC_API_BASE_URL}/api/v1/staff/${id}`, {
        method: "PUT",
        headers: {
          "Content-Type": "application/json",
          Authorization: `Bearer ${token}`,
        },
        body: JSON.stringify(payload)
      });
      if (!res.ok) throw new Error("Failed to update staff.");

      setIsEditing(false);
      setAuditReason("");
      await fetchStaffData(token!);
    } catch (err: any) {
      alert(err.message);
    } finally {
      setSavingEdit(false);
    }
  };

  const handlePhotoUpload = async (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (!file) return;

    const token = localStorage.getItem("gahto_admin_token");
    setUploadingPhoto(true);

    const formData = new FormData();
    formData.append("file", file);

    try {
      const res = await fetch(`${process.env.NEXT_PUBLIC_API_BASE_URL}/api/v1/staff/${id}/photo`, {
        method: "POST",
        headers: { Authorization: `Bearer ${token}` },
        body: formData
      });
      if (!res.ok) throw new Error("Failed to upload photo");
      await fetchStaffData(token!);
    } catch (err: any) {
      alert(err.message);
    } finally {
      setUploadingPhoto(false);
    }
  };

  if (loading) return <div className="p-10 text-center text-slate-500">Loading...</div>;
  if (!member) return <div className="p-10 text-center text-red-500">Staff not found</div>;

  const activeCard = cards.find(c => c.status === "active");

  return (
    <div className="space-y-6">
      <div className="flex items-center gap-3">
        <Link href="/admin/staff" className="flex h-10 w-10 items-center justify-center rounded-xl bg-white text-slate-500 shadow-sm transition hover:bg-slate-50 hover:text-slate-900">
          <ChevronLeft className="h-5 w-5" />
        </Link>
        <div>
          <h1 className="text-2xl font-bold text-slate-900">Staff Profile</h1>
          <p className="text-sm text-slate-500">{member.staff_id}</p>
        </div>
      </div>

      <div className="grid gap-6 lg:grid-cols-3">
        {/* Profile Card */}
        <div className="col-span-1 space-y-6">
          <div className="rounded-2xl border border-slate-200 bg-white p-6 shadow-sm relative">

            {!isEditing && adminRole === "super_admin" && (
              <button
                onClick={() => setIsEditing(true)}
                className="absolute top-4 right-4 p-2 text-slate-400 hover:text-blue-900 transition bg-slate-50 hover:bg-blue-50 rounded-lg"
              >
                <Edit3 className="h-4 w-4" />
              </button>
            )}

            {isEditing ? (
              <form onSubmit={handleEditSubmit} className="space-y-4">
                <div className="flex items-center justify-between mb-2">
                  <h3 className="font-bold text-slate-900">Edit Profile</h3>
                  <button type="button" onClick={() => setIsEditing(false)} className="text-slate-400 hover:text-red-500">
                    <X className="h-5 w-5" />
                  </button>
                </div>

                <div className="grid grid-cols-2 gap-3">
                  <div>
                    <label className="text-xs font-semibold text-slate-500">First Name</label>
                    <input required type="text" value={editForm.first_name} onChange={e => setEditForm({...editForm, first_name: e.target.value})} className="w-full text-sm border rounded-lg p-2 mt-1" />
                  </div>
                  <div>
                    <label className="text-xs font-semibold text-slate-500">Last Name</label>
                    <input required type="text" value={editForm.last_name} onChange={e => setEditForm({...editForm, last_name: e.target.value})} className="w-full text-sm border rounded-lg p-2 mt-1" />
                  </div>
                </div>

                <div>
                  <label className="text-xs font-semibold text-slate-500">Position</label>
                  <input required type="text" value={editForm.position} onChange={e => setEditForm({...editForm, position: e.target.value})} className="w-full text-sm border rounded-lg p-2 mt-1" />
                </div>

                <div className="grid grid-cols-2 gap-3">
                  <div>
                    <label className="text-xs font-semibold text-slate-500">Email</label>
                    <input type="email" value={editForm.email || ''} onChange={e => setEditForm({...editForm, email: e.target.value})} className="w-full text-sm border rounded-lg p-2 mt-1" />
                  </div>
                  <div>
                    <label className="text-xs font-semibold text-slate-500">Phone</label>
                    <input type="text" value={editForm.phone || ''} onChange={e => setEditForm({...editForm, phone: e.target.value})} className="w-full text-sm border rounded-lg p-2 mt-1" />
                  </div>
                </div>

                <div>
                  <label className="text-xs font-semibold text-slate-500">Department</label>
                  <input type="text" value={editForm.department || ''} onChange={e => setEditForm({...editForm, department: e.target.value})} className="w-full text-sm border rounded-lg p-2 mt-1" />
                </div>

                <div className="bg-red-50 p-3 rounded-lg border border-red-100">
                  <label className="text-xs font-bold text-red-900">Reason for Change (Audit Trail) *</label>
                  <input required type="text" value={auditReason} onChange={e => setAuditReason(e.target.value)} placeholder="e.g. Corrected spelling of last name" className="w-full text-sm border-red-200 rounded p-2 mt-1 focus:ring-red-500" />
                </div>

                <div className="bg-blue-50 p-3 rounded-lg border border-blue-100">
                  <label className="text-xs font-bold text-blue-900 mb-1 block">Staff Photo (For ID Card)</label>
                  <div className="flex items-center gap-3">
                     {member.photo_url && (
                        <img src={`${process.env.NEXT_PUBLIC_API_BASE_URL || "http://localhost:8700"}${member.photo_url}`} alt="Current" className="h-10 w-10 rounded-full object-cover border-2 border-white shadow-sm" />
                     )}
                     <div className="flex-1">
                       <input
                         type="file"
                         accept="image/jpeg, image/png, image/webp"
                         onChange={handlePhotoUpload}
                         disabled={uploadingPhoto}
                         className="w-full text-xs text-slate-500 file:mr-2 file:py-1 file:px-2 file:rounded-md file:border-0 file:text-xs file:font-semibold file:bg-white file:text-blue-700 hover:file:bg-slate-100"
                       />
                       {uploadingPhoto && <p className="text-[10px] text-blue-700 mt-1 flex items-center gap-1"><Loader2 className="h-3 w-3 animate-spin" /> Uploading...</p>}
                     </div>
                  </div>
                </div>

                <button disabled={savingEdit} type="submit" className="w-full bg-blue-900 text-white rounded-lg py-2 font-semibold flex items-center justify-center gap-2">
                  {savingEdit ? <Loader2 className="h-4 w-4 animate-spin" /> : <Save className="h-4 w-4" />} Save Changes
                </button>
              </form>
            ) : (
              <>
                <div className="flex flex-col items-center text-center">
                  <div className="relative group">
                    <div className="flex h-28 w-28 overflow-hidden items-center justify-center rounded-2xl bg-slate-100 text-3xl font-bold text-slate-400 ring-4 ring-slate-50 shadow-sm transition">
                      {member.photo_url ? (
                         <img src={`${process.env.NEXT_PUBLIC_API_BASE_URL || "http://localhost:8700"}${member.photo_url}`} alt="" className="h-full w-full object-cover" />
                      ) : (
                         <span>{member.first_name[0]}{member.last_name[0]}</span>
                      )}
                    </div>

                    {adminRole === "super_admin" && (
                      <label className="absolute inset-0 flex flex-col items-center justify-center bg-black/60 text-white rounded-2xl opacity-0 group-hover:opacity-100 cursor-pointer transition-opacity">
                        {uploadingPhoto ? <Loader2 className="h-6 w-6 animate-spin" /> : <UploadCloud className="h-6 w-6" />}
                        <span className="text-[10px] font-semibold mt-1">Upload Photo</span>
                        <input type="file" accept="image/jpeg, image/png, image/webp" className="hidden" onChange={handlePhotoUpload} disabled={uploadingPhoto} />
                      </label>
                    )}
                  </div>

                  <h2 className="mt-4 text-xl font-bold text-slate-900">{member.first_name} {member.last_name}</h2>
                  <p className="text-sm font-medium text-slate-500">{member.position}</p>

                  <div className="mt-4">
                    {member.status === "active" && (
                      <span className="inline-flex items-center gap-1 rounded-full bg-emerald-50 px-3 py-1 text-sm font-semibold text-emerald-700 ring-1 ring-inset ring-emerald-600/20">
                        <CheckCircle2 className="h-4 w-4" /> Active Staff
                      </span>
                    )}
                    {member.status === "pending_approval" && (
                      <div className="space-y-3">
                        <span className="inline-flex items-center gap-1 rounded-full bg-amber-50 px-3 py-1 text-sm font-semibold text-amber-700 ring-1 ring-inset ring-amber-600/20">
                          Pending Approval
                        </span>
                        {adminRole === "super_admin" && (
                          <button
                            onClick={handleApprove}
                            disabled={approving}
                            className="w-full rounded-xl bg-blue-900 py-2.5 text-sm font-semibold text-white shadow-sm hover:bg-blue-800 disabled:opacity-50"
                          >
                            {approving ? "Approving..." : "Approve Staff Member"}
                          </button>
                        )}
                      </div>
                    )}
                  </div>
                </div>

                <div className="mt-8 space-y-4 text-sm">
                  <div className="flex justify-between border-b border-slate-100 pb-3">
                    <span className="text-slate-500">Staff ID</span>
                    <span className="font-semibold text-slate-900">{member.staff_id}</span>
                  </div>
                  <div className="flex justify-between border-b border-slate-100 pb-3">
                    <span className="text-slate-500">Email</span>
                    <span className="font-semibold text-slate-900">{member.email || "-"}</span>
                  </div>
                  <div className="flex justify-between border-b border-slate-100 pb-3">
                    <span className="text-slate-500">Phone</span>
                    <span className="font-semibold text-slate-900">{member.phone || "-"}</span>
                  </div>
                  <div className="flex justify-between border-b border-slate-100 pb-3">
                    <span className="text-slate-500">Department</span>
                    <span className="font-semibold text-slate-900">{member.department || "-"}</span>
                  </div>
                </div>
              </>
            )}
          </div>
        </div>

        {/* ID Card Generation Area */}
        <div className="col-span-1 lg:col-span-2 space-y-6">
          <div className="rounded-2xl border border-slate-200 bg-white p-6 shadow-sm">
            <div className="flex items-center justify-between border-b border-slate-100 pb-4">
              <h3 className="text-lg font-bold text-slate-900 flex items-center gap-2">
                <CreditCard className="h-5 w-5 text-blue-900" />
                ID Card Management
              </h3>

              {member.status === "active" && (
                <button
                  onClick={handleIssueCard}
                  disabled={issuing}
                  className="rounded-lg bg-emerald-600 px-4 py-2 text-sm font-semibold text-white transition hover:bg-emerald-700 disabled:opacity-50"
                >
                  {issuing ? "Issuing..." : activeCard ? "Re-issue Card" : "Issue First Card"}
                </button>
              )}
            </div>

            {activeCard ? (
              <div className="mt-6">
                <div className="rounded-xl border border-blue-100 bg-blue-50/50 p-6 flex flex-col md:flex-row gap-8 items-center justify-between">
                  <div className="space-y-2">
                    <p className="text-sm font-semibold text-blue-900">Active Credential Version: {activeCard.version}</p>
                    <p className="text-sm text-slate-600">Card ID: {activeCard.card_id}</p>
                    <p className="text-xs text-slate-500">Issued: {new Date(activeCard.issued_at).toLocaleDateString()}</p>

                    <div className="pt-4 flex gap-3">
                      <Link
                        href={`/admin/staff/${id}/card-render`}
                        className="inline-flex items-center gap-2 rounded-lg bg-blue-900 px-4 py-2 text-sm font-semibold text-white shadow-sm hover:bg-blue-800"
                      >
                        <Printer className="h-4 w-4" />
                        Print / Download Card
                      </Link>
                    </div>
                  </div>

                  <div className="rounded-xl bg-white p-3 shadow-sm border border-slate-200">
                    <QRCodeSVG
                      value={`${process.env.NEXT_PUBLIC_FRONTEND_URL || "https://gahto.org"}/verify/staff/${activeCard.verification_token}`}
                      size={120}
                    />
                    <p className="mt-2 text-center text-[10px] font-semibold text-slate-500">PUBLIC VERIFICATION</p>
                  </div>
                </div>
              </div>
            ) : (
               <div className="mt-6 flex flex-col items-center justify-center rounded-xl border border-dashed border-slate-300 bg-slate-50 py-12 text-center">
                 <ShieldAlert className="h-10 w-10 text-slate-400 mb-3" />
                 <p className="font-medium text-slate-900">No active card issued.</p>
                 <p className="text-sm text-slate-500 mt-1">
                   {member.status === "active"
                     ? "Click 'Issue First Card' above to generate a verified credential."
                     : "Staff member must be approved before a card can be issued."}
                 </p>
               </div>
            )}
          </div>
        </div>
      </div>
    </div>
  );
}