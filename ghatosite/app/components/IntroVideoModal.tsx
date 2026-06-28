"use client";

import { useEffect, useState, useRef } from "react";
import { X, Volume2, VolumeX, Loader2 } from "lucide-react";

type IntroVideoModalProps = {
  videoUrl?: string;
  forceShow?: boolean;
  onClose?: () => void;
};

export default function IntroVideoModal({
  videoUrl = "/vid/intro_vid.mp4",
  forceShow = false,
  onClose,
}: IntroVideoModalProps) {
  const [isOpen, setIsOpen] = useState(false);
  const [isMuted, setIsMuted] = useState(true);
  const [canClose, setCanClose] = useState(false);
  const [isLoading, setIsLoading] = useState(true);
  const videoRef = useRef<HTMLVideoElement>(null);

  useEffect(() => {
    const hasSeenIntro = localStorage.getItem("gahto_intro_seen");
    if (!hasSeenIntro || forceShow) {
      setIsOpen(true);
      document.body.style.overflow = "hidden";
    }
  }, [forceShow]);

  useEffect(() => {
    if (!isOpen) return;

    const timer = setTimeout(() => {
      setCanClose(true);
    }, 15000);

    return () => clearTimeout(timer);
  }, [isOpen]);

  const handleClose = () => {
    setIsOpen(false);
    document.body.style.overflow = "";
    localStorage.setItem("gahto_intro_seen", "true");
    if (onClose) onClose();
  };

  const toggleMute = () => {
    if (videoRef.current) {
      videoRef.current.muted = !videoRef.current.muted;
      setIsMuted(videoRef.current.muted);
    }
  };

  if (!isOpen) return null;

  return (
    <div className="fixed inset-0 z-[200] flex items-center justify-center bg-black">
      <div className="relative h-full w-full max-w-7xl mx-auto flex items-center justify-center">
        {isLoading && (
          <div className="absolute inset-0 flex items-center justify-center z-10">
            <Loader2 className="h-10 w-10 text-white animate-spin" />
          </div>
        )}

        <video
          ref={videoRef}
          src={videoUrl}
          autoPlay
          muted={isMuted}
          onCanPlay={() => setIsLoading(false)}
          onEnded={handleClose}
          className="w-full h-full object-contain"
        />

        <div className="absolute bottom-10 left-1/2 -translate-x-1/2 flex items-center gap-6 z-20">
          <button
            onClick={toggleMute}
            className="flex h-14 w-14 items-center justify-center rounded-full bg-white/10 text-white backdrop-blur-md transition hover:bg-white/20"
            title={isMuted ? "Unmute" : "Mute"}
          >
            {isMuted ? <VolumeX className="h-6 w-6" /> : <Volume2 className="h-6 w-6" />}
          </button>

          {canClose && (
            <button
              onClick={handleClose}
              className="flex items-center gap-2 rounded-full bg-red-600 px-8 py-4 font-bold text-white shadow-xl transition hover:bg-red-700 hover:scale-105 active:scale-95"
            >
              <X className="h-5 w-5" />
              <span>Close Intro</span>
            </button>
          )}
        </div>

        {!canClose && (
            <div className="absolute top-10 right-10 z-20">
                <p className="text-white/60 text-sm font-medium bg-black/40 px-4 py-2 rounded-full backdrop-blur-sm">
                    Intro playing...
                </p>
            </div>
        )}
      </div>
    </div>
  );
}
