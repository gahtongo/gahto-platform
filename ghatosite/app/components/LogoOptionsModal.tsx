"use client";

import { X, Play, Home } from "lucide-react";
import Link from "next/link";

type LogoOptionsModalProps = {
  open: boolean;
  onClose: () => void;
  onWatchVideo: () => void;
};

export default function LogoOptionsModal({
  open,
  onClose,
  onWatchVideo,
}: LogoOptionsModalProps) {
  if (!open) return null;

  return (
    <div className="fixed inset-0 z-[100] flex items-center justify-center p-4">
      <button
        onClick={onClose}
        className="absolute inset-0 bg-slate-950/60 backdrop-blur-sm"
      />

      <div className="relative w-full max-w-sm rounded-[2rem] border border-white/10 bg-white p-6 shadow-2xl">
        <div className="flex items-center justify-between mb-6">
          <h3 className="text-xl font-bold text-slate-900">Where to?</h3>
          <button
            onClick={onClose}
            className="flex h-9 w-9 items-center justify-center rounded-xl border border-slate-200 text-slate-500 hover:bg-slate-50 transition"
          >
            <X className="h-4 w-4" />
          </button>
        </div>

        <div className="grid gap-3">
          <Link
            href="/"
            onClick={onClose}
            className="flex items-center gap-4 rounded-2xl border border-slate-200 bg-white p-4 transition hover:bg-slate-50 group"
          >
            <div className="flex h-12 w-12 items-center justify-center rounded-xl bg-blue-50 text-blue-900 transition group-hover:scale-110">
              <Home className="h-5 w-5" />
            </div>
            <div>
              <p className="font-bold text-slate-900">Go to Home</p>
              <p className="text-sm text-slate-500">Back to main page</p>
            </div>
          </Link>

          <button
            onClick={() => {
              onWatchVideo();
              onClose();
            }}
            className="flex w-full items-center gap-4 rounded-2xl border border-slate-200 bg-white p-4 text-left transition hover:bg-slate-50 group"
          >
            <div className="flex h-12 w-12 items-center justify-center rounded-xl bg-red-50 text-red-600 transition group-hover:scale-110">
              <Play className="h-5 w-5 fill-current" />
            </div>
            <div>
              <p className="font-bold text-slate-900">Watch Intro Video</p>
              <p className="text-sm text-slate-500">Learn about GAHTO</p>
            </div>
          </button>
        </div>
      </div>
    </div>
  );
}
