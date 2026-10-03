import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: "Sanatorio Médico",
  description: "Sistema administrativo del Sanatorio Médico",
};

export default function RootLayout({ children }: LayoutProps<"/">) {
  return (
    <html lang="es">
      <body>{children}</body>
    </html>
  );
}
