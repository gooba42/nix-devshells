# Java Development Template

Nix flake template for Java development with OpenJDK and build tools.

## Quick Start

```bash
nix develop
# or with direnv:
direnv allow
```

### Automatic Environment Setup

When you enter the devShell (via `direnv allow` or `nix develop`), the following happens automatically:

✓ **Git Repository**: Initializes `.git` if not present
✓ **Lombok Integration**: Configures Project Lombok for compilation (via JAVA_TOOL_OPTIONS)
✓ **Java Environment**: OpenJDK, Maven, and Gradle are configured and ready

No manual setup needed! Just start coding.

## Building

```bash
# With Maven:
mvn clean package
java -jar target/myapp.jar

# With Gradle:
gradle build
java -jar build/libs/myapp.jar

# Quick compile (Maven):
mvn compile

# Run tests (Maven):
mvn test

# Run tests (Gradle):
gradle test
```

## Included Tools

| Tool | Purpose |
|------|---------|
| **OpenJDK** | Java compiler and runtime |
| **Maven** | Build automation and package management |
| **Gradle** | Alternative build system |
| **google-java-format** | Java code formatter (Google's style) |
| **Lombok** | Java library for reducing boilerplate (auto-configured) |

## Testing & Development Features

The environment includes testing and development tools:

- **maven-surefire** - Maven test runner (included with Maven)
- **junit** - Unit testing framework
- **google-java-format** - Consistent code formatting

**Example usage:**

```bash
# Run tests
mvn test
# or
gradle test

# Format code with google-java-format
google-java-format -i src/main/java/com/example/*.java

# Run specific test class
mvn test -Dtest=MyTestClass

# Run with debug output
mvn -X test
```

## Project Layout

```
src/
  ├── main/
  │   ├── java/
  │   │   └── com/example/
  │   │       └── Main.java
  │   └── resources/
  └── test/
      ├── java/
      │   └── com/example/
      │       └── MainTest.java
      └── resources/
pom.xml (or build.gradle for Gradle)
.envrc
flake.nix
```

## Maven vs Gradle

- **Maven** (pom.xml) - XML-based, declarative, wider plugin ecosystem
- **Gradle** (build.gradle) - DSL-based, more flexible, faster incremental builds

Both are fully configured in this devShell.

## Lombok Configuration

Project Lombok is automatically configured via `JAVA_TOOL_OPTIONS` environment variable. You can use Lombok annotations like:

```java
@Data
@AllArgsConstructor
@NoArgsConstructor
public class User {
    private String name;
    private int age;
}
```

## Packaging for nixpkgs

This template is structured for easy packaging in nixpkgs:

- All sources in `src/`
- `flake.nix` provides a devShell and template
- Add a `default.nix` or package expression as needed for nixpkgs

See [nixpkgs Java packaging docs](https://nixos.org/manual/nixpkgs/stable/#java) for more details.

## Customization

Edit `flake.nix` to:

- Change Java version (OpenJDK 11, 17, 21, etc.)
- Add Maven plugins or Gradle dependencies
- Include additional development tools (e.g., jvm-debugger, jprofiler)
