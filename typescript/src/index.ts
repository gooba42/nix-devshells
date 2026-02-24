/**
 * TypeScript Application Entry Point
 *
 * This is a simple starter template for your TypeScript project.
 * Modify and extend this as needed for your use case.
 */

interface GreetingOptions {
    name: string;
    excited?: boolean;
}

/**
 * Greet a person with optional excitement
 */
function greet(options: GreetingOptions): string {
    const punctuation = options.excited ? "!" : ".";
    return `Hello, ${options.name}${punctuation}`;
}

/**
 * Main application entry point
 */
async function main(): Promise<void> {
    console.log("🚀 TypeScript Development Environment");
    console.log("=====================================\n");

    const message = greet({
        name: "TypeScript Developer",
        excited: true,
    });

    console.log(message);
    console.log("\n✓ Project is set up and ready to go!");
    console.log("  • Edit src/index.ts to get started");
    console.log("  • Run 'npm run build' to compile");
    console.log("  • Run 'npm run dev' for watch mode");
    console.log("  • Run 'npm test' to run tests");
}

// Run main and handle errors
main().catch((error: Error) => {
    console.error("Fatal error:", error.message);
    process.exit(1);
});
