+++
date = '2026-01-16T15:57:56-05:00'
draft = true
title = 'Zig Core - Foundations'
tags = ['zig','core','concepts']
+++

> This article covers the foundational concepts of Zig: memory management, types, control flow, functions, and pointers. These are the building blocks you'll use in every Zig program. All examples can be run with `zig run filename.zig`.

---

## Memory Management

Zig gives you direct control over memory. There's no garbage collector, no automatic reference counting. You allocate memory, you free it, and you're responsible for getting it right.

### Allocators

Unlike C, where `malloc` is a global function, Zig uses allocators. An allocator is an interface that provides memory. This design has several benefits:

- **Testability**: Pass a testing allocator to detect memory leaks
- **Flexibility**: Use different allocation strategies for different situations
- **Explicitness**: Memory allocation is always visible in function signatures

```zig
const std = @import("std");

pub fn main() !void {
    // General purpose allocator - good for most situations
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    // Allocate a slice of 10 bytes
    const buffer = try allocator.alloc(u8, 10);
    defer allocator.free(buffer);

    // Use the buffer...
}
```

The `defer` keyword ensures memory is freed when the scope exits, even if an error occurs. This pattern replaces the error-prone `goto cleanup` pattern from C.

### Common Allocators

| Allocator | Use Case |
|:----------|:---------|
| `GeneralPurposeAllocator` | General use, includes safety checks |
| `page_allocator` | Large allocations, allocates full pages |
| `FixedBufferAllocator` | When you have a pre-allocated buffer |
| `ArenaAllocator` | Batch allocations freed together |
| `c_allocator` | Wraps C's malloc/free for interop |

### Stack vs Heap

Like C, Zig distinguishes between stack and heap allocation:

```zig
// Stack allocated - automatic lifetime
var stack_array: [100]u8 = undefined;

// Heap allocated - manual lifetime
const heap_slice = try allocator.alloc(u8, 100);
defer allocator.free(heap_slice);
```

Stack allocation is faster but limited in size. Heap allocation is flexible but requires manual management.

---

## Types

Zig has a rich type system that catches errors at compile time while remaining simple to understand.

### Primitive Types

```zig
// Integers - specify exact size
const a: i8 = -128;      // 8-bit signed
const b: u32 = 1000;     // 32-bit unsigned
const c: i64 = 0;        // 64-bit signed
const d: usize = 0;      // pointer-sized unsigned

// Floats
const e: f32 = 3.14;     // 32-bit float
const f: f64 = 2.718;    // 64-bit float

// Boolean
const g: bool = true;

// Optional - can be null
const h: ?i32 = null;
const i: ?i32 = 42;
```

### Structs

Structs group related data together. Unlike C, Zig structs can have methods.

```zig
const Point = struct {
    x: f32,
    y: f32,

    // Method - self is passed implicitly
    pub fn distance(self: Point, other: Point) f32 {
        const dx = self.x - other.x;
        const dy = self.y - other.y;
        return @sqrt(dx * dx + dy * dy);
    }

    // Static method - no self parameter
    pub fn origin() Point {
        return Point{ .x = 0, .y = 0 };
    }
};

// Usage
const p1 = Point{ .x = 3, .y = 4 };
const p2 = Point.origin();
const d = p1.distance(p2);  // 5.0
```

### Enums

Enums define a type with a fixed set of values.

```zig
const Direction = enum {
    north,
    south,
    east,
    west,

    pub fn opposite(self: Direction) Direction {
        return switch (self) {
            .north => .south,
            .south => .north,
            .east => .west,
            .west => .east,
        };
    }
};

const dir = Direction.north;
const opp = dir.opposite();  // .south
```

### Tagged Unions

Tagged unions combine an enum with associated data. This is Zig's answer to discriminated unions.

```zig
const Value = union(enum) {
    integer: i64,
    float: f64,
    string: []const u8,
    none,

    pub fn format(self: Value) []const u8 {
        return switch (self) {
            .integer => "integer",
            .float => "float",
            .string => "string",
            .none => "none",
        };
    }
};

const v1 = Value{ .integer = 42 };
const v2 = Value{ .string = "hello" };
const v3 = Value.none;
```

### Arrays and Slices

Arrays have a fixed size known at compile time. Slices are views into arrays with runtime length.

```zig
// Array - fixed size, stored inline
const array: [5]i32 = .{ 1, 2, 3, 4, 5 };

// Slice - pointer + length, can refer to any contiguous memory
const slice: []const i32 = array[1..4];  // {2, 3, 4}

// Mutable slice
var mutable: [3]i32 = .{ 1, 2, 3 };
const mutable_slice: []i32 = &mutable;
mutable_slice[0] = 10;
```

Key differences:

| | Array | Slice |
|:--|:------|:------|
| Size | Compile-time constant | Runtime value |
| Memory | Contains the data | Points to data |
| Type | `[N]T` | `[]T` or `[]const T` |

---

## Control Flow

Zig's control flow is explicit and consistent. There are no hidden surprises.

### If/Else

```zig
const value: i32 = 42;

if (value > 0) {
    // positive
} else if (value < 0) {
    // negative
} else {
    // zero
}

// If expressions return values
const abs = if (value >= 0) value else -value;
```

### Optional Handling

Optionals require explicit handling. You can't accidentally use a null value.

```zig
const maybe: ?i32 = getSomeValue();

// Option 1: if with capture
if (maybe) |value| {
    // value is i32, guaranteed non-null
    std.debug.print("Got: {}\n", .{value});
} else {
    std.debug.print("Got null\n", .{});
}

// Option 2: orelse - provide default
const definitely = maybe orelse 0;

// Option 3: orelse unreachable - assert non-null
const must_exist = maybe orelse unreachable;
```

### While Loops

```zig
var i: usize = 0;
while (i < 10) : (i += 1) {
    // body
}

// With optional capture
var iter = getIterator();
while (iter.next()) |item| {
    // process item
}
```

### For Loops

For loops iterate over slices and ranges.

```zig
const items = [_]i32{ 1, 2, 3, 4, 5 };

// Iterate with value
for (items) |item| {
    std.debug.print("{}\n", .{item});
}

// Iterate with index
for (items, 0..) |item, index| {
    std.debug.print("[{}] = {}\n", .{ index, item });
}

// Iterate over range
for (0..10) |i| {
    std.debug.print("{}\n", .{i});
}
```

### Switch

Switch must be exhaustive. Every possible value must be handled.

```zig
const value: u8 = 42;

const result = switch (value) {
    0 => "zero",
    1...9 => "single digit",
    10...99 => "double digit",
    else => "large",
};
```

Switch can also handle complex patterns:

```zig
const Tagged = union(enum) { a: i32, b: bool, c };

fn process(t: Tagged) void {
    switch (t) {
        .a => |val| std.debug.print("a: {}\n", .{val}),
        .b => |val| std.debug.print("b: {}\n", .{val}),
        .c => std.debug.print("c\n", .{}),
    }
}
```

---

## Functions

Functions in Zig are straightforward. No overloading, no default arguments, no hidden behavior.

### Basic Functions

```zig
fn add(a: i32, b: i32) i32 {
    return a + b;
}

// Public function - exported from module
pub fn multiply(a: i32, b: i32) i32 {
    return a * b;
}
```

### Error Handling

Functions that can fail return an error union type.

```zig
const FileError = error{
    NotFound,
    PermissionDenied,
    OutOfMemory,
};

fn readFile(path: []const u8) FileError![]u8 {
    if (!fileExists(path)) {
        return FileError.NotFound;
    }
    // ... read file
}

// Calling code must handle the error
pub fn main() !void {
    const contents = try readFile("config.txt");
    // or
    const contents2 = readFile("config.txt") catch |err| {
        std.debug.print("Error: {}\n", .{err});
        return;
    };
}
```

The `!` in the return type indicates an error union. The `try` keyword propagates errors up the call stack.

### Function Pointers

Functions are first-class values.

```zig
fn add(a: i32, b: i32) i32 {
    return a + b;
}

fn apply(f: *const fn (i32, i32) i32, x: i32, y: i32) i32 {
    return f(x, y);
}

const result = apply(&add, 2, 3);  // 5
```

---

## Pointers

Zig has two kinds of pointers: single-item pointers and many-item pointers.

### Single-Item Pointers

```zig
var value: i32 = 42;
const ptr: *i32 = &value;  // pointer to value

ptr.* = 100;  // dereference and assign
std.debug.print("{}\n", .{value});  // 100
```

### Many-Item Pointers

```zig
var array = [_]i32{ 1, 2, 3, 4, 5 };
const ptr: [*]i32 = &array;  // pointer to first element

// Access elements
const first = ptr[0];
const third = ptr[2];

// Pointer arithmetic
const second_ptr = ptr + 1;
```

### Const Correctness

Zig enforces const correctness strictly.

```zig
const x: i32 = 42;
// var ptr: *i32 = &x;  // ERROR: cannot get mutable pointer to const

const ptr: *const i32 = &x;  // OK: const pointer to const
```

### Optional Pointers

Pointers can be optional, representing nullable pointers.

```zig
const Node = struct {
    value: i32,
    next: ?*Node,  // optional pointer to next node
};

fn findLast(node: *Node) *Node {
    var current = node;
    while (current.next) |next| {
        current = next;
    }
    return current;
}
```

### Sentinel-Terminated Pointers

For C interop, Zig supports sentinel-terminated pointers (like null-terminated strings).

```zig
// Null-terminated string
const c_string: [*:0]const u8 = "hello";

// Can be passed directly to C functions
const len = std.c.strlen(c_string);
```

---

## Putting It Together

Here's a complete example that uses these concepts:

```zig
const std = @import("std");

const Node = struct {
    value: i32,
    next: ?*Node,
};

const LinkedList = struct {
    head: ?*Node,
    allocator: std.mem.Allocator,

    pub fn init(allocator: std.mem.Allocator) LinkedList {
        return .{
            .head = null,
            .allocator = allocator,
        };
    }

    pub fn prepend(self: *LinkedList, value: i32) !void {
        const node = try self.allocator.create(Node);
        node.* = .{
            .value = value,
            .next = self.head,
        };
        self.head = node;
    }

    pub fn deinit(self: *LinkedList) void {
        var current = self.head;
        while (current) |node| {
            const next = node.next;
            self.allocator.destroy(node);
            current = next;
        }
    }
};

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var list = LinkedList.init(allocator);
    defer list.deinit();

    try list.prepend(3);
    try list.prepend(2);
    try list.prepend(1);

    var current = list.head;
    while (current) |node| {
        std.debug.print("{} -> ", .{node.value});
        current = node.next;
    }
    std.debug.print("null\n", .{});
}
```

---

## Summary

This article covered the foundational building blocks of Zig:

| Concept | Key Points |
|:--------|:-----------|
| **Memory** | Explicit allocators, `defer` for cleanup, stack vs heap |
| **Types** | Primitives, structs with methods, enums, tagged unions, arrays, slices |
| **Control Flow** | `if`/`else`, `while`, `for`, exhaustive `switch` |
| **Functions** | No overloading, error unions with `!`, `try`/`catch` |
| **Pointers** | Single-item `*T`, many-item `[*]T`, optional `?*T` |

All examples in this article can be saved to a `.zig` file and run with:

```bash
zig run yourfile.zig
```

---

## References

- [Zig Language Reference (0.15.2)](https://ziglang.org/documentation/0.15.2/)
- [Ziglearn](https://ziglearn.org/)
- [Zig by Example](https://zig-by-example.github.io/)