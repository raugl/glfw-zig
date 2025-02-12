const std = @import("std");

// TODO: Get rid of the external dependency `system_sdk`
// TODO: Fix include headers

pub fn build(b: *std.Build) void {
    const optimize = b.standardOptimizeOption(.{});
    const target = b.standardTargetOptions(.{});

    const options = .{
        .shared = b.option(
            bool,
            "shared",
            "Build GLFW as shared lib",
        ) orelse false,
        .enable_x11 = b.option(
            bool,
            "x11",
            "Whether to build with X11 support (default: true)",
        ) orelse true,
        .enable_wayland = b.option(
            bool,
            "wayland",
            "Whether to build with Wayland support (default: true)",
        ) orelse true,
    };

    const module = b.addModule("root", .{ .root_source_file = b.path("src/root.zig") });
    // const install_headers = b.addInstallHeaderFile(b.path("libs/glfw/include"), "");
    // b.getInstallStep().dependOn(&install_headers.step);

    if (target.result.os.tag == .emscripten) return;

    const lib_opts = .{
        .name = "glfw",
        .target = target,
        .optimize = optimize,
    };
    const glfw = if (options.shared) b.addSharedLibrary(lib_opts) else b.addStaticLibrary(lib_opts);
    module.linkLibrary(glfw);

    linkSystemLibs(b, glfw, target, options);
    if (options.shared and target.result.os.tag == .windows) {
        glfw.root_module.addCMacro("_GLFW_BUILD_DLL", "");
    }

    const src_dir = "libs/glfw/src/";
    const common_files = .{
        src_dir ++ "platform.c",
        src_dir ++ "monitor.c",
        src_dir ++ "init.c",
        src_dir ++ "vulkan.c",
        src_dir ++ "input.c",
        src_dir ++ "context.c",
        src_dir ++ "window.c",
        src_dir ++ "osmesa_context.c",
        src_dir ++ "egl_context.c",
        src_dir ++ "null_init.c",
        src_dir ++ "null_monitor.c",
        src_dir ++ "null_window.c",
        src_dir ++ "null_joystick.c",
    };

    switch (target.result.os.tag) {
        .windows => {
            addCSourceFiles(glfw, common_files, .{
                src_dir ++ "wgl_context.c",
                src_dir ++ "win32_thread.c",
                src_dir ++ "win32_init.c",
                src_dir ++ "win32_monitor.c",
                src_dir ++ "win32_time.c",
                src_dir ++ "win32_joystick.c",
                src_dir ++ "win32_window.c",
                src_dir ++ "win32_module.c",
            });
            glfw.root_module.addCMacro("_GLFW_WIN32", "1");
        },
        .macos => {
            addCSourceFiles(glfw, common_files, .{
                src_dir ++ "posix_thread.c",
                src_dir ++ "posix_module.c",
                src_dir ++ "posix_poll.c",
                src_dir ++ "nsgl_context.m",
                src_dir ++ "cocoa_time.c",
                src_dir ++ "cocoa_joystick.m",
                src_dir ++ "cocoa_init.m",
                src_dir ++ "cocoa_window.m",
                src_dir ++ "cocoa_monitor.m",
            });
            glfw.root_module.addCMacro("_GLFW_COCOA", "1");
        },
        .linux => {
            addCSourceFiles(glfw, common_files, .{
                src_dir ++ "posix_time.c",
                src_dir ++ "posix_thread.c",
                src_dir ++ "posix_module.c",
            });

            if (options.enable_x11 or options.enable_wayland) {
                addCSourceFiles(glfw, .{
                    src_dir ++ "xkb_unicode.c",
                    src_dir ++ "linux_joystick.c",
                    src_dir ++ "posix_poll.c",
                }, .{});
            }
            if (options.enable_x11) {
                addCSourceFiles(glfw, .{
                    src_dir ++ "x11_init.c",
                    src_dir ++ "x11_monitor.c",
                    src_dir ++ "x11_window.c",
                    src_dir ++ "glx_context.c",
                }, .{});
                glfw.root_module.addCMacro("_GLFW_X11", "1");
                glfw.linkSystemLibrary("X11");
            }
            if (options.enable_wayland) {
                addCSourceFiles(glfw, .{
                    src_dir ++ "wl_init.c",
                    src_dir ++ "wl_monitor.c",
                    src_dir ++ "wl_window.c",
                }, .{});
                glfw.root_module.addCMacro("_GLFW_WAYLAND", "1");
                glfw.addIncludePath(b.path(src_dir ++ "wayland"));
            }
        },
        else => {},
    }
    { // Test step
        const tests = b.addTest(.{
            .name = "glfw-zig-tests",
            .root_source_file = b.path("src/root.zig"),
            .target = target,
            .optimize = optimize,
        });
        b.installArtifact(tests);
        linkSystemLibs(b, tests, target, options);
        tests.linkLibrary(glfw);

        const test_step = b.step("test", "Run glfw-zig tests");
        test_step.dependOn(&b.addRunArtifact(tests).step);
    }
}

fn linkSystemLibs(b: *std.Build, compile_step: *std.Build.Step.Compile, target: std.Build.ResolvedTarget, options: anytype) void {
    compile_step.linkLibC();
    switch (target.result.os.tag) {
        .windows => {
            compile_step.linkSystemLibrary("gdi32");
            compile_step.linkSystemLibrary("user32");
            compile_step.linkSystemLibrary("shell32");
        },
        .macos => {
            if (b.lazyDependency("system_sdk", .{})) |system_sdk| {
                compile_step.addFrameworkPath(system_sdk.path("macos12/System/Library/Frameworks"));
                compile_step.addSystemIncludePath(system_sdk.path("macos12/usr/include"));
                compile_step.addLibraryPath(system_sdk.path("macos12/usr/lib"));
            }
            compile_step.linkSystemLibrary("objc");
            compile_step.linkFramework("IOKit");
            compile_step.linkFramework("CoreFoundation");
            compile_step.linkFramework("Metal");
            compile_step.linkFramework("AppKit");
            compile_step.linkFramework("CoreServices");
            compile_step.linkFramework("CoreGraphics");
            compile_step.linkFramework("Foundation");
        },
        .linux => {
            if (b.lazyDependency("system_sdk", .{})) |system_sdk| {
                compile_step.addSystemIncludePath(system_sdk.path("linux/include"));
                if (target.result.cpu.arch.isX86()) {
                    compile_step.addLibraryPath(system_sdk.path("linux/lib/x86_64-linux-gnu"));
                } else {
                    compile_step.addLibraryPath(system_sdk.path("linux/lib/aarch64-linux-gnu"));
                }
                compile_step.addSystemIncludePath(system_sdk.path("linux/include"));
                compile_step.addSystemIncludePath(system_sdk.path("linux/include/wayland"));
            }
            if (options.enable_x11) {
                compile_step.linkSystemLibrary("X11");
            }
        },
        else => {},
    }
}

fn addCSourceFiles(
    compile_step: *std.Build.Step.Compile,
    comptime common_files: anytype,
    comptime files: anytype,
) void {
    compile_step.addCSourceFiles(.{ .files = &(common_files ++ files) });
}
