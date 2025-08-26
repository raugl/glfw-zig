const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const mod = b.addModule("glfw", .{
        .target = target,
        .optimize = optimize,
        .root_source_file = b.path("src/root.zig"),
    });
    switch (target.result.os.tag) {
        .emscripten => {},
        .windows => mod.linkSystemLibrary("glfw3", .{}),
        else => mod.linkSystemLibrary("glfw", .{}),
    }

    const unit_tests = b.addTest(.{
        .root_module = mod,
    });
    const run_tests = b.addRunArtifact(unit_tests);
    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_tests.step);
}
