module.exports = {
  mode: "jit",
  purge: [
    "../**/*.html.eex",
    "../**/*.html.leex",
    "../**/views/**/*.ex",
    "../**/live/**/*.ex",
  ],
  darkMode: "media", // or 'media' or 'class'
  theme: {
    fontFamily: {
      sans: ["Poppins", "Verdana", "sans-serif"],
    },
    extend: {
      // https://coolors.co/2d3142-bfc0c0-ffffff-ef8354-4f5d75-646f4b-e85f5c
      colors: {
        "space-cadet": "#2d3142",
        silver: "#bfc0c0",
        mandarin: "#ef8354",
        independence: "#4f5d75",
        "dark-olive": "#646f4b",
        "fire-opal": "#e85f5c",
      },
    },
  },
  variants: {
    extend: {},
  },
  plugins: [],
};
