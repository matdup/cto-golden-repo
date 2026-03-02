import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  reactStrictMode: true,
  poweredByHeader: false,
  productionBrowserSourceMaps: false,
  compress: true,
  images: {
    // Keep empty by default; add domains when you actually need remote images.
    remotePatterns: [],
  },
};

export default nextConfig;