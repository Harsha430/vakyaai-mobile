/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {
      colors: {
        primary: {
          DEFAULT: '#0F172A', // Deep Charcoal / Dark Indigo
          light: '#1E293B',
        },
        accent: {
          DEFAULT: '#F59E0B', // Saffron Gold
          glow: '#D97706',
        },
        parchment: {
          DEFAULT: '#F5F5DC', // Muted Parchment Beige
          dark: '#E2E2C8',
        },
        ai: {
          glow: '#2DD4BF', // Soft Teal Glow
        }
      },
      fontFamily: {
        heading: ['Cinzel', 'serif'],
        body: ['"Google Sans"', 'sans-serif'],
      },
      backgroundImage: {
        'manuscript-texture': "url('https://www.transparenttextures.com/patterns/aged-paper.png')", // Fallback or local asset
      },
    },
  },
  plugins: [],
}
