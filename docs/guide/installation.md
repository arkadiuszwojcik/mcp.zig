---
title: "Installation"
description: "Install MCP.zig in your Zig project using zig fetch for Zig 0.17.x compatibility."
keywords: [installation, install, zig fetch, package manager, dependency, build.zig]
---

# Installation

This guide covers different ways to install and use mcp.zig in your project.

## Requirements

- **Zig 0.17.0** or later (use mcp.zig 0.0.9)
- **Zig 0.16.x** (use mcp.zig 0.0.6)
- **Zig 0.15.x** (use mcp.zig 0.0.3)
- A Zig project with `build.zig` and `build.zig.zon`

## Using Zig Package Manager

The recommended way to use mcp.zig is through Zig's built-in package manager.

### Step 1: Add Dependency

#### Option A: Stable Release (v0.0.9 for Zig 0.17.0+)

```bash
zig fetch --save https://github.com/muhammad-fiaz/mcp.zig/archive/refs/tags/0.0.9.tar.gz
```

#### Option B: Nightly / Development (`main` branch)

```bash
zig fetch --save git+https://github.com/muhammad-fiaz/mcp.zig.git
```

#### Legacy Zig Versions

```bash
# Zig 0.16.x
zig fetch --save https://github.com/muhammad-fiaz/mcp.zig/archive/refs/tags/0.0.6.tar.gz

# Zig 0.15.x
zig fetch --save https://github.com/muhammad-fiaz/mcp.zig/archive/refs/tags/0.0.3.tar.gz
```

Running `zig fetch --save` automatically writes the dependency and computed hash into your `build.zig.zon`:

```zig
.{
    .name = .my_project,
    .version = "0.1.0",
    .fingerprint = 0x1234567890abcdef,
    .dependencies = .{
        // Stable release:
        .mcp = .{
            .url = "https://github.com/muhammad-fiaz/mcp.zig/archive/refs/tags/0.0.9.tar.gz",
            .hash = "...", // populated automatically by zig fetch --save
        },
        // Or nightly (development):
        // .mcp = .{
        //     .url = "git+https://github.com/muhammad-fiaz/mcp.zig.git",
        //     .hash = "...",
        // },
    },
    .paths = .{ "" },
}
```

### Step 2: Configure Build

Update your `build.zig` to use the dependency:

```zig
const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // Get the mcp dependency
    const mcp_dep = b.dependency("mcp", .{
        .target = target,
        .optimize = optimize,
    });

    // Create your executable
    const exe = b.addExecutable(.{
        .name = "my-mcp-server",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/main.zig"),
            .target = target,
            .optimize = optimize,
        }),
    });

    // Add the mcp module
    exe.root_module.addImport("mcp", mcp_dep.module("mcp"));

    b.installArtifact(exe);
}
```

### Step 3: Build

Run zig build to fetch and build:

```bash
zig build
```

## Using Git Submodule

Alternatively, you can use a Git submodule:

```bash
git submodule add https://github.com/muhammad-fiaz/mcp.zig.git deps/mcp.zig
```

Then in your `build.zig`:

```zig
const mcp_module = b.addModule("mcp", .{
    .root_source_file = .{ .cwd_relative = "deps/mcp.zig/src/mcp.zig" },
});

exe.root_module.addImport("mcp", mcp_module);
```

## Verifying Installation

Create a simple test file to verify the installation:

```zig
// src/main.zig
const std = @import("std");
const mcp = @import("mcp");

pub fn main(init: std.process.Init) void {
    _ = init;
    std.debug.print("mcp.zig version: {s}\n", .{mcp.protocol.VERSION});
    std.debug.print("Installation successful!\n", .{});
}
```

Build and run:

```bash
zig build
# Linux/macOS
./zig-out/bin/my-mcp-server
# Windows PowerShell
.\\zig-out\\bin\\my-mcp-server.exe
```

You should see:

```
mcp.zig version: 2026-07-28
Installation successful!
```

## Next Steps

- [Getting Started](/guide/getting-started) - Create your first MCP server
- [Server Guide](/guide/server) - Learn about server capabilities
- [Examples](/examples/) - Explore example projects
