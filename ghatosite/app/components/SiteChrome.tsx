"use client";

import { usePathname } from "next/navigation";
import Navbar from "./Navbar";
import GlobalNewsTicker from "./GlobalNewsTicker";
import IntroVideoModal from "./IntroVideoModal";

export default function SiteChrome() {
  const pathname = usePathname();
  const isAdminRoute = pathname.startsWith("/admin");

  if (isAdminRoute) return null;

  return (
    <>
      <Navbar />
      <GlobalNewsTicker />
      <IntroVideoModal />
    </>
  );
}