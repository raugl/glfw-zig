# [glfw-zig](https://github.com/raugl/glfw-zig)

Zig build package and bindings for [GLFW 3.4](https://github.com/glfw/glfw/releases/tag/3.4)

## Features:

* use of appropriate pointer and slice types
* enums that exhaustively implement the GLFW API eliminate all possible `GLFW_INVALID_ENUM` and most `GLFW_INVALID_VALUE` errors
* support for zig allocators
* both traditional C functions API and a methods API
* a default error callback that uses `std.log.err()` to always report GLFW errors
* use of either error sets or optional values everywhere appropriate. A number of errors such as `GLFW_NOT_INITIALIZED` and `GLFW_PLATFORM_ERROR` do not return errors as they would have cluttered the API too much for something that can be assumed to never fail. Instead, they are still reported by the error callback.

## Getting started
Fetch the library
```sh
zig fetch --save git+https://github.com/raugl/glfw-zig
```

then use it in your `build.zig`:
```zig
const glfw_dep = b.dependency("glfw-zig", .{
    .target = target,
    .optimize = optimize,
    .shared = true, // Link as dynamic library
});
exe.root_module.addImport("glfw", glfw_dep.module("root"));
exe.linkLibrary(glfw_dep.artifact("glfw"));
```

## Example

```zig
const std = @import("std");
const glfw = @import("glfw");

pub fn main() !void {
    var major: i32 = 0;
    var minor: i32 = 0;
    var rev: i32 = 0;

    glfw.getVersion(&major, &minor, &rev);
    std.debug.print("GLFW {}.{}.{}\n", .{ major, minor, rev });

    //Example of something that fails with GLFW_NOT_INITIALIZED - but will continue with execution
    const monitor: ?glfw.Monitor = glfw.getPrimaryMonitor();
    _ = monitor;

    glfw.initHint(.platform, .x11);
    glfw.initHint(.joystick_hat_buttons, false);
    glfw.initAllocator(std.heap.page_allocator);

    try glfw.init();
    defer glfw.terminate();
    std.debug.print("GLFW Init Succeeded.\n", .{});

    glfw.windowHint(.context_version_major, 3);
    glfw.windowHint(.context_version_minor, 3);
    glfw.windowHint(.opengl_profile, .core);

    glfw.windowHint(.resizable, false);
    glfw.windowHint(.x11_class_name, "my-application");

    // One can use either the methods API ...
    const window: glfw.Window = try glfw.createWindow(640, 480, "My Title", null, null);
    defer window.destroy();
    window.makeContextCurrent();

    while (!window.shouldClose()) {
        if (window.getKey(.escape) == .press) {
            window.setShouldClose(true);
        }
        window.swapBuffers();
        glfw.pollEvents();
    }

    // ... or the traditional C API
    const window: glfw.Window = try glfw.createWindow(640, 480, "My Title", null, null);
    defer glfw.destroyWindow(window);
    glfw.makeContextCurrent(window);

    while (!glfw.windowShouldClose(window)) {
        if (glfw.getKey(window, .escape) == .press) {
            glfw.setWindowShouldClose(window, true);
        }
        glfw.swapBuffers(window);
        glfw.pollEvents();
    }
}
```

## Documentation

The bindings mimic the official GLFW API very closely, apart from the naming convention. [GLFW's Documentation](https://www.glfw.org/documentation.html) should cover most things that you want to know. Failing that, reading `root.zig` should be easy enough and answer all your remaining questions.
