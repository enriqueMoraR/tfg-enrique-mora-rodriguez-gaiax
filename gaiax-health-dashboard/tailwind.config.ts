import type { Config } from 'tailwindcss'

export default {
  content: [
    "./index.html",
    "./src/**/*.{js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {
      colors: {
        'clinical-blue': '#1e40af',
        'clinical-green': '#059669',
        'clinical-red': '#dc2626',
      },
    },
  },
  plugins: [],
} satisfies Config
