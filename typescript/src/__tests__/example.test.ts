/**
 * Example test suite for TypeScript project
 * 
 * This demonstrates Jest testing patterns for TypeScript.
 * Add your own tests here.
 */

describe("Example Test Suite", () => {
  it("should verify 2 + 2 equals 4", () => {
    expect(2 + 2).toBe(4);
  });

  it("should verify string concatenation", () => {
    const greeting = "Hello";
    const name = "World";
    expect(`${greeting}, ${name}!`).toBe("Hello, World!");
  });

  it("should verify array operations", () => {
    const numbers = [1, 2, 3, 4, 5];
    const doubled = numbers.map((n) => n * 2);
    expect(doubled).toEqual([2, 4, 6, 8, 10]);
  });

  it("should verify object properties", () => {
    interface User {
      id: number;
      name: string;
      email: string;
    }

    const user: User = {
      id: 1,
      name: "Test User",
      email: "test@example.com",
    };

    expect(user.name).toBe("Test User");
    expect(user.email).toContain("example.com");
  });
});

describe("Type Safety Examples", () => {
  it("should demonstrate type guards", () => {
    function processValue(value: string | number): string {
      if (typeof value === "string") {
        return value.toUpperCase();
      }
      return value.toFixed(2);
    }

    expect(processValue("hello")).toBe("HELLO");
    expect(processValue(3.14159)).toBe("3.14");
  });

  it("should demonstrate generics", () => {
    function getFirstElement<T>(array: T[]): T | undefined {
      return array[0];
    }

    expect(getFirstElement([1, 2, 3])).toBe(1);
    expect(getFirstElement(["a", "b", "c"])).toBe("a");
    expect(getFirstElement([])).toBeUndefined();
  });
});
