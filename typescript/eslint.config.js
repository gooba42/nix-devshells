// ESLint configuration for TypeScript project
export default [
  {
    files: ["src/**/*.{ts,tsx,js,jsx}"],
    ignores: ["dist/", "node_modules/", "**/*.d.ts"],
    languageOptions: {
      ecmaVersion: 2020,
      sourceType: "module",
      parser: "@typescript-eslint/parser",
      parserOptions: {
        ecmaVersion: 2020,
        sourceType: "module",
      },
    },
    rules: {
      "no-console": "warn",
      "no-unused-vars": "off",
      "@typescript-eslint/no-unused-vars": [
        "warn",
        { argsIgnorePattern: "^_" },
      ],
      "no-var": "error",
      "prefer-const": "error",
      "prefer-arrow-callback": "warn",
      "object-shorthand": "warn",
    },
  },
];
