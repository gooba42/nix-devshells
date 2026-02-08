#!/usr/bin/env bash
# Helper script to install popular .NET templates from NuGet

set -e

echo "🔧 .NET Template Installer"
echo "=========================="
echo ""

# Function to install a template
install_template() {
    local name="$1"
    local package="$2"
    echo "📦 Installing $name..."
    dotnet new install "$package" || echo "⚠️  Failed to install $name"
    echo ""
}

# Parse arguments
if [ "$#" -eq 0 ]; then
    echo "Usage: $0 [all|web|cloud|testing|mobile|list]"
    echo ""
    echo "Categories:"
    echo "  all       - Install all popular templates"
    echo "  web       - Web development templates"
    echo "  cloud     - Cloud & AWS templates"
    echo "  testing   - Testing frameworks"
    echo "  mobile    - Mobile development"
    echo "  list      - Show available categories"
    echo ""
    echo "Individual templates:"
    echo "  aws       - AWS Lambda templates"
    echo "  blazor    - Blazor templates"
    echo "  nunit     - NUnit 3 test templates"
    echo "  xunit     - xUnit test templates"
    echo "  specflow  - SpecFlow BDD templates"
    echo "  avalonia  - Avalonia UI (cross-platform)"
    echo "  boxed     - ASP.NET Core Boxed templates"
    echo "  clean     - Clean Architecture templates"
    echo "  giraffe   - Giraffe F# web framework"
    echo "  safe      - SAFE Stack (F#)"
    exit 0
fi

case "$1" in
    all)
        echo "Installing all popular templates..."
        install_template "AWS Lambda" "Amazon.Lambda.Templates"
        install_template "NUnit 3" "NUnit3.DotNetNew.Template"
        install_template "SpecFlow" "SpecFlow.Templates.DotNet"
        install_template ".NET Boxed" "Boxed.Templates"
        install_template "Avalonia UI" "Avalonia.Templates"
        install_template "Clean Architecture (Manga)" "Paulovich.Manga"
        ;;

    web)
        echo "Installing web development templates..."
        install_template ".NET Boxed" "Boxed.Templates"
        install_template "Carter" "CarterTemplate"
        install_template "Giraffe (F#)" "giraffe-template"
        ;;

    cloud)
        echo "Installing cloud templates..."
        install_template "AWS Lambda" "Amazon.Lambda.Templates"
        install_template "Azure Functions" "Microsoft.Azure.Functions.Templates"
        ;;

    testing)
        echo "Installing testing templates..."
        install_template "NUnit 3" "NUnit3.DotNetNew.Template"
        install_template "SpecFlow" "SpecFlow.Templates.DotNet"
        install_template "NSpec" "dotnet-new-nspec"
        install_template "Expecto (F#)" "Expecto.Template"
        ;;

    mobile)
        echo "Installing mobile development templates..."
        install_template "Avalonia UI" "Avalonia.Templates"
        install_template "Fabulous Xamarin.Forms" "Fabulous.XamarinForms.Templates"
        ;;

    aws)
        install_template "AWS Lambda" "Amazon.Lambda.Templates"
        ;;

    blazor)
        install_template "Blazor" "Microsoft.AspNetCore.Blazor.Templates::3.0.0-*"
        ;;

    nunit)
        install_template "NUnit 3" "NUnit3.DotNetNew.Template"
        ;;

    xunit)
        install_template "xUnit Test File" "GatewayProgrammingSchool.xUnit.CSharp"
        ;;

    specflow)
        install_template "SpecFlow" "SpecFlow.Templates.DotNet"
        ;;

    avalonia)
        install_template "Avalonia UI" "Avalonia.Templates"
        ;;

    boxed)
        install_template ".NET Boxed" "Boxed.Templates"
        ;;

    clean)
        install_template "Clean Architecture (Manga)" "Paulovich.Manga"
        install_template "Clean Architecture (Caju)" "Paulovich.Caju"
        ;;

    giraffe)
        install_template "Giraffe (F#)" "giraffe-template"
        ;;

    safe)
        install_template "SAFE Stack (F#)" "SAFE.Template"
        ;;

    list)
        echo "Available categories and templates:"
        echo ""
        echo "Categories:"
        echo "  all       - Install all popular templates"
        echo "  web       - Web development (Boxed, Carter, Giraffe)"
        echo "  cloud     - Cloud platforms (AWS Lambda, Azure Functions)"
        echo "  testing   - Testing frameworks (NUnit, SpecFlow, NSpec)"
        echo "  mobile    - Mobile development (Avalonia, Fabulous)"
        echo ""
        echo "Individual templates:"
        echo "  aws       - AWS Lambda templates"
        echo "  blazor    - Blazor templates"
        echo "  nunit     - NUnit 3 test templates"
        echo "  xunit     - xUnit test templates"
        echo "  specflow  - SpecFlow BDD templates"
        echo "  avalonia  - Avalonia UI (cross-platform)"
        echo "  boxed     - ASP.NET Core Boxed templates"
        echo "  clean     - Clean Architecture templates"
        echo "  giraffe   - Giraffe F# web framework"
        echo "  safe      - SAFE Stack (F#)"
        ;;

    *)
        echo "❌ Unknown option: $1"
        echo "Run '$0' without arguments to see usage."
        exit 1
        ;;
esac

echo ""
echo "✅ Done! List installed templates with: dotnet new list"
