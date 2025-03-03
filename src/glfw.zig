// MIT License
//
// Copyright (c) 2025 raugl
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

// TODO: Improve the platform detecton for native features

const std = @import("std");
const glfw = @This();
const Allocator = std.mem.Allocator;

const os = @import("builtin").target.os.tag;
const options = @import("options");

const native_win32 = os == .windows;
const native_wgl = os == .windows;
const native_cocoa = os == .macos;
const native_nsgl = os.isDarwin();
const native_x11 = os == .linux and options.enable_x11;
const native_glx = os == .linux and options.enable_x11;
const native_wayland = os == .linux and options.enable_wayland;
const native_egl = os == .linux and options.enable_wayland;
const native_osmesa = os == .linux;

test {
    _ = std.testing.refAllDeclsRecursive(@This());
}

pub const version_major = 3;
pub const version_minor = 4;
pub const version_revision = 0;

pub const dont_care: c_int = -1;
pub const any_position: c_int = -0x80000000;

pub const Bool = enum(c_int) {
    false = 0,
    true = 1,
};

pub const Platform = enum(c_int) {
    any = 0x60000,
    win32 = 0x60001,
    cocoa = 0x60002,
    wayland = 0x60003,
    x11 = 0x60004,
    null = 0x60005,
    emscripten = 0x00060006,
};

pub const AnglePlatform = enum(c_int) {
    none = 0x37001,
    opengl = 0x37002,
    opengles = 0x37003,
    d3d9 = 0x37004,
    d3d11 = 0x37005,
    vulkan = 0x37007,
    metal = 0x37008,
};

pub const WaylandLibdecor = enum(c_int) {
    prefer = 0x38001,
    disable = 0x38002,
};

pub const ClientAPI = enum(c_int) {
    no_api = 0,
    opengl_api = 0x30001,
    opengles_api = 0x30002,
};

pub const OpenGLProfile = enum(c_int) {
    any = 0,
    core = 0x32001,
    compat = 0x32002,
};

pub const ContextReleaseBehavior = enum(c_int) {
    any = 0,
    flush = 0x35001,
    none = 0x35002,
};

pub const ContextCreationAPI = enum(c_int) {
    native = 0x36001,
    egl = 0x36002,
    osmesa = 0x36003,
};

pub const ContextRobustness = enum(c_int) {
    no_robustness = 0,
    no_reset_notification = 0x31001,
    lose_context_on_reset = 0x31002,
};

pub const CursorKind = enum(c_int) {
    normal = 0x34001,
    hidden = 0x34002,
    disabled = 0x34003,
    captured = 0x34004,
};

pub const CursorShape = enum(c_int) {
    arrow = 0x36001,
    ibeam = 0x36002,
    crosshair = 0x36003,
    pointing_hand = 0x36004,
    resize_ew = 0x36005,
    resize_ns = 0x36006,
    resize_nwse = 0x36007,
    resize_nesw = 0x36008,
    resize_all = 0x36009,
    not_allowed = 0x3600a,

    pub const hand = .pointing_hand;
    pub const hresize = .resize_ew;
    pub const vresize = .resize_ns;
};

pub const Event = enum(c_int) {
    connected = 0x40001,
    disconnected = 0x40002,
};

pub const KeyState = enum(c_int) {
    release = 0,
    press = 1,
    repeat = 2,
};

pub const ButtonState = enum(u8) {
    release = 0,
    press = 1,
};

pub const HatState = packed struct(u8) {
    up: bool = false,
    right: bool = false,
    down: bool = false,
    left: bool = false,
    _padding: u4 = 0,

    pub fn centered(self: HatState) bool {
        return @as(u8, @bitCast(self)) == 0;
    }
    pub fn right_up(self: HatState) bool {
        return self.right and self.up;
    }
    pub fn right_down(self: HatState) bool {
        return self.right and self.down;
    }
    pub fn left_up(self: HatState) bool {
        return self.left and self.up;
    }
    pub fn left_down(self: HatState) bool {
        return self.left and self.down;
    }
};

pub const Modifiers = packed struct(c_int) {
    shift: bool = false,
    control: bool = false,
    alt: bool = false,
    super: bool = false,
    caps_lock: bool = false,
    num_lock: bool = false,
    _padding: u26 = 0,
};

pub const JoystickID = enum(c_int) {
    j1 = 0,
    j2 = 1,
    j3 = 2,
    j4 = 3,
    j5 = 4,
    j6 = 5,
    j7 = 6,
    j8 = 7,
    j9 = 8,
    j10 = 9,
    j11 = 10,
    j12 = 11,
    j13 = 12,
    j14 = 13,
    j15 = 14,
    j16 = 15,

    pub const last = @intFromEnum(JoystickID.j16);
};

pub const GamepadButton = enum(c_int) {
    a = 0,
    b = 1,
    x = 2,
    y = 3,
    left_bumper = 4,
    right_bumper = 5,
    back = 6,
    start = 7,
    guide = 8,
    left_thumb = 9,
    right_thumb = 10,
    dpad_up = 11,
    dpad_right = 12,
    dpad_down = 13,
    dpad_left = 14,

    pub const cross = .a;
    pub const circle = .b;
    pub const square = .x;
    pub const triangle = .y;
    pub const last = @intFromEnum(GamepadButton.dpad_left);
};

pub const GamepadAxis = enum(c_int) {
    left_x = 0,
    left_y = 1,
    right_x = 2,
    right_y = 3,
    left_trigger = 4,
    right_trigger = 5,

    pub const last = @intFromEnum(GamepadAxis.right_trigger);
};

pub const MouseButton = enum(c_int) {
    b1 = 0,
    b2 = 1,
    b3 = 2,
    b4 = 3,
    b5 = 4,
    b6 = 5,
    b7 = 6,
    b8 = 7,

    pub const left = .b1;
    pub const right = .b2;
    pub const middle = .b3;
    pub const last = @intFromEnum(MouseButton.b8);
};

pub const Key = enum(c_int) {
    unknown = -1,

    space = 32,
    apostrophe = 39,
    comma = 44,
    minus = 45,
    period = 46,
    slash = 47,
    n0 = 48,
    n1 = 49,
    n2 = 50,
    n3 = 51,
    n4 = 52,
    n5 = 53,
    n6 = 54,
    n7 = 55,
    n8 = 56,
    n9 = 57,
    semicolon = 59,
    equal = 61,
    a = 65,
    b = 66,
    c = 67,
    d = 68,
    e = 69,
    f = 70,
    g = 71,
    h = 72,
    i = 73,
    j = 74,
    k = 75,
    l = 76,
    m = 77,
    n = 78,
    o = 79,
    p = 80,
    q = 81,
    r = 82,
    s = 83,
    t = 84,
    u = 85,
    v = 86,
    w = 87,
    x = 88,
    y = 89,
    z = 90,
    left_bracket = 91,
    backslash = 92,
    right_bracket = 93,
    grave_accent = 96,
    world_1 = 161,
    world_2 = 162,

    escape = 256,
    enter = 257,
    tab = 258,
    backspace = 259,
    insert = 260,
    delete = 261,
    right = 262,
    left = 263,
    down = 264,
    up = 265,
    page_up = 266,
    page_down = 267,
    home = 268,
    end = 269,
    caps_lock = 280,
    scroll_lock = 281,
    num_lock = 282,
    print_screen = 283,
    pause = 284,
    f1 = 290,
    f2 = 291,
    f3 = 292,
    f4 = 293,
    f5 = 294,
    f6 = 295,
    f7 = 296,
    f8 = 297,
    f9 = 298,
    f10 = 299,
    f11 = 300,
    f12 = 301,
    f13 = 302,
    f14 = 303,
    f15 = 304,
    f16 = 305,
    f17 = 306,
    f18 = 307,
    f19 = 308,
    f20 = 309,
    f21 = 310,
    f22 = 311,
    f23 = 312,
    f24 = 313,
    f25 = 314,
    kp0 = 320,
    kp1 = 321,
    kp2 = 322,
    kp3 = 323,
    kp4 = 324,
    kp5 = 325,
    kp6 = 326,
    kp7 = 327,
    kp8 = 328,
    kp9 = 329,
    kp_decimal = 330,
    kp_divide = 331,
    kp_multiply = 332,
    kp_subtract = 333,
    kp_add = 334,
    kp_enter = 335,
    kp_equal = 336,
    left_shift = 340,
    left_control = 341,
    left_alt = 342,
    left_super = 343,
    right_shift = 344,
    right_control = 345,
    right_alt = 346,
    right_super = 347,
    menu = 348,

    pub const last = @intFromEnum(Key.menu);
};

pub const InitHint = enum(c_int) {
    joystick_hat_buttons = 0x50001,
    angle_platform = 0x50002,
    platform = 0x50003,
    cocoa_chdir_resources = 0x51001,
    cocoa_menubar = 0x51002,
    x11_xcb_vulkan_surface = 0x52001,
    wayland_libdecor = 0x53001,

    pub fn ValueType(comptime hint: InitHint) type {
        return switch (hint) {
            .cocoa_chdir_resources,
            .cocoa_menubar,
            .joystick_hat_buttons,
            .x11_xcb_vulkan_surface,
            => bool,
            .platform => Platform,
            .angle_platform => AnglePlatform,
            .wayland_libdecor => WaylandLibdecor,
        };
    }
};

pub const WindowHint = enum(c_int) {
    focused = 0x20001,
    resizable = 0x20003,
    visible = 0x20004,
    decorated = 0x20005,
    auto_iconify = 0x20006,
    floating = 0x20007,
    maximized = 0x20008,
    center_cursor = 0x20009,
    transparent_framebuffer = 0x2000a,
    focus_on_show = 0x2000c,
    mouse_passthrough = 0x2000d,
    position_x = 0x2000e,
    position_y = 0x2000f,
    scale_to_monitor = 0x2200c,
    scale_framebuffer = 0x2200d,
    red_bits = 0x21001,
    green_bits = 0x21002,
    blue_bits = 0x21003,
    alpha_bits = 0x21004,
    depth_bits = 0x21005,
    stencil_bits = 0x21006,
    accum_red_bits = 0x21007,
    accum_green_bits = 0x21008,
    accum_blue_bits = 0x21009,
    accum_alpha_bits = 0x2100a,
    aux_buffers = 0x2100b,
    stereo = 0x2100c,
    samples = 0x2100d,
    srgb_capable = 0x2100e,
    refresh_rate = 0x2100f,
    double_buffer = 0x21010,
    client_api = 0x22001,
    context_version_major = 0x22002,
    context_version_minor = 0x22003,
    context_revision = 0x22004,
    context_robustness = 0x22005,
    opengl_forward_compat = 0x22006,
    context_debug = 0x22007,
    context_creation_api = 0x2200b,
    context_release_behavior = 0x22009,
    opengl_profile = 0x22008,
    cocoa_frame_name = 0x23002,
    cocoa_graphics_switching = 0x23003,
    x11_class_name = 0x24001,
    x11_instance_name = 0x24002,
    win32_keyboard_menu = 0x25001,
    win32_show_default = 0x25002,
    wayland_app_id = 0x26001,

    pub fn ValueType(comptime hint: WindowHint) type {
        return switch (hint) {
            .resizable,
            .visible,
            .decorated,
            .focused,
            .auto_iconify,
            .floating,
            .maximized,
            .center_cursor,
            .transparent_framebuffer,
            .focus_on_show,
            .scale_to_monitor,
            .scale_framebuffer,
            .mouse_passthrough,
            .stereo,
            .srgb_capable,
            .double_buffer,
            .opengl_forward_compat,
            .context_debug,
            .win32_keyboard_menu,
            .win32_show_default,
            .cocoa_graphics_switching,
            => bool,
            .red_bits, // 0 to INT_MAX or GLFW_DONT_CARE
            .green_bits, // 0 to INT_MAX or GLFW_DONT_CARE
            .blue_bits, // 0 to INT_MAX or GLFW_DONT_CARE
            .alpha_bits, // 0 to INT_MAX or GLFW_DONT_CARE
            .depth_bits, // 0 to INT_MAX or GLFW_DONT_CARE
            .stencil_bits, // 0 to INT_MAX or GLFW_DONT_CARE
            .accum_red_bits, // 0 to INT_MAX or GLFW_DONT_CARE
            .accum_green_bits, // 0 to INT_MAX or GLFW_DONT_CARE
            .accum_blue_bits, // 0 to INT_MAX or GLFW_DONT_CARE
            .accum_alpha_bits, // 0 to INT_MAX or GLFW_DONT_CARE
            .aux_buffers, // 0 to INT_MAX or GLFW_DONT_CARE
            .samples, // 0 to INT_MAX or GLFW_DONT_CARE
            .refresh_rate, // 0 to INT_MAX or GLFW_DONT_CARE
            .position_x, // Any valid screen x-coordinate or GLFW_ANY_POSITION
            .position_y, // Any valid screen x-coordinate or GLFW_ANY_POSITION
            .context_version_major,
            .context_version_minor,
            .context_revision,
            => c_int,
            .cocoa_frame_name,
            .wayland_app_id,
            .x11_class_name,
            .x11_instance_name,
            => [*:0]const u8,
            .client_api => ClientAPI,
            .context_creation_api => ContextCreationAPI,
            .context_robustness => ContextRobustness,
            .context_release_behavior => ContextReleaseBehavior,
            .opengl_profile => OpenGLProfile,
        };
    }
};

pub const WindowGetAttribute = enum(c_int) {
    focused = 0x20001,
    iconified = 0x20002,
    resizable = 0x20003,
    visible = 0x20004,
    decorated = 0x20005,
    auto_iconify = 0x20006,
    floating = 0x20007,
    maximized = 0x20008,
    transparent_framebuffer = 0x2000a,
    hovered = 0x2000b,
    focus_on_show = 0x2000c,
    mouse_passthrough = 0x2000d,
    double_buffer = 0x21010,
    client_api = 0x22001,
    context_version_major = 0x22002,
    context_version_minor = 0x22003,
    context_revision = 0x22004,
    context_robustness = 0x22005,
    opengl_forward_compat = 0x22006,
    context_debug = 0x22007,
    opengl_profile = 0x22008,
    context_release_behavior = 0x22009,
    context_no_error = 0x2200a,
    context_creation_api = 0x2200b,

    pub const opengl_debug_context = .context_debug;

    pub fn ValueType(comptime attrib: WindowGetAttribute) type {
        return switch (attrib) {
            .focused,
            .iconified,
            .resizable,
            .visible,
            .decorated,
            .auto_iconify,
            .floating,
            .maximized,
            .transparent_framebuffer,
            .hovered,
            .focus_on_show,
            .mouse_passthrough,
            .double_buffer,
            .opengl_forward_compat,
            .context_debug,
            .context_no_error,
            => bool,
            .context_version_major,
            .context_version_minor,
            .context_revision,
            => c_int,
            .client_api => ClientAPI,
            .context_creation_api => ContextCreationAPI,
            .opengl_profile => OpenGLProfile,
            .context_release_behavior => ContextReleaseBehavior,
            .context_robustness => ContextRobustness,
        };
    }
};

pub const WindowSetAttribute = enum(c_int) {
    resizable = 0x20003,
    decorated = 0x20005,
    auto_iconify = 0x20006,
    floating = 0x20007,
    focus_on_show = 0x2000c,
    mouse_passthrough = 0x2000d,
};

pub const InputMode = enum(c_int) {
    cursor,
    sticky_keys,
    sticky_mouse_buttons,
    lock_key_mods,
    raw_mouse_motion,

    pub fn ValueType(comptime mode: InputMode) type {
        return switch (mode) {
            .sticky_keys,
            .sticky_mouse_buttons,
            .lock_key_mods,
            .raw_mouse_motion,
            => bool,
            .cursor => CursorKind,
        };
    }
};

pub const ErrorCode = enum(c_int) {
    no_error = 0,
    not_initialized = 0x10001,
    no_current_context = 0x10002,
    invalid_enum = 0x10003,
    invalid_value = 0x10004,
    out_of_memory = 0x10005,
    api_unavailable = 0x10006,
    version_unavailable = 0x10007,
    platform_error = 0x10008,
    format_unavailable = 0x10009,
    no_window_context = 0x1000a,
    cursor_unavailable = 0x1000b,
    feature_unavailable = 0x1000c,
    feature_unimplemented = 0x1000d,
    platform_unavailable = 0x1000e,
};

pub const Error = error{
    Unknown,
    NotInitialized,
    NoCurrentContext,
    InvalidEnum,
    InvalidValue,
    OutOfMemory,
    ApiUnavailable,
    VersionUnavailable,
    PlatformError,
    FormatUnavailable,
    NoWindowContext,
    CursorUnavailable,
    FeatureUnavailable,
    FeatureUnimplemented,
    PlatformUnavailable,
};

fn checkError() Error!void {
    return switch (cdef.glfwGetError(null)) {
        .no_error => return,
        .not_initialized => Error.NotInitialized,
        .no_current_context => Error.NoCurrentContext,
        .invalid_enum => Error.InvalidEnum,
        .invalid_value => Error.InvalidValue,
        .out_of_memory => Error.OutOfMemory,
        .api_unavailable => Error.ApiUnavailable,
        .version_unavailable => Error.VersionUnavailable,
        .platform_error => Error.PlatformError,
        .format_unavailable => Error.FormatUnavailable,
        .no_window_context => Error.NoWindowContext,
        .cursor_unavailable => Error.CursorUnavailable,
        .feature_unavailable => Error.FeatureUnavailable,
        .feature_unimplemented => Error.FeatureUnimplemented,
        .platform_unavailable => Error.PlatformUnavailable,
    };
}

fn castToCint(value: anytype) c_int {
    const T = @TypeOf(value);
    return switch (@typeInfo(T)) {
        .Int => @intCast(value),
        .Enum, .EnumLiteral => @intFromEnum(value),
        .Bool => @intFromBool(value),
        else => @compileError("Cannot cast " ++ @typeName(T) ++ "to c_int."),
    };
}

fn castFromCint(comptime T: type, value: c_int) T {
    return switch (@typeInfo(T)) {
        .Int => value,
        .Enum, .EnumLiteral => @enumFromInt(value),
        .Bool => @as(bool, value),
        else => @compileError("Cannot cast c_int to type " ++ @typeName(T)),
    };
}

pub const VkInstance = *anyopaque;
pub const VkPhysicalDevice = *anyopaque;
pub const VkSurfaceKHR = *anyopaque;
pub const VkAllocationCallbacks = anyopaque;
pub const VkResult = c_int;
pub const PFN_vkGetInstanceProcAddr = *const fn (instance: ?VkInstance, pName: [*:0]const u8) callconv(.C) ?VkProc;
pub const VkProc = *const fn () callconv(.C) void;
pub const GLProc = *const fn () callconv(.C) void;

pub const AllocateFn = *const fn (size: usize, user: ?*anyopaque) callconv(.C) ?[*]u8;
pub const ReallocateFn = *const fn (block: [*]u8, size: usize, user: ?*anyopaque) callconv(.C) ?[*]u8;
pub const DeallocateFn = *const fn (block: [*]u8, user: ?*anyopaque) callconv(.C) void;

pub const ErrorFn = *const fn (error_code: ErrorCode, description: [*:0]const u8) callconv(.C) void;
pub const WindowPosFn = *const fn (window: Window, xpos: c_int, ypos: c_int) callconv(.C) void;
pub const WindowSizeFn = *const fn (window: Window, width: c_int, height: c_int) callconv(.C) void;
pub const WindowCloseFn = *const fn (window: Window) callconv(.C) void;
pub const WindowRefreshFn = *const fn (window: Window) callconv(.C) void;
pub const WindowFocusFn = *const fn (window: Window, focused: Bool) callconv(.C) void;
pub const WindowIconifyFn = *const fn (window: Window, iconified: Bool) callconv(.C) void;
pub const WindowMaximizeFn = *const fn (window: Window, maximized: Bool) callconv(.C) void;
pub const FrameBufferSizeFn = *const fn (window: Window, width: c_int, height: c_int) callconv(.C) void;
pub const WindowContentScaleFn = *const fn (window: Window, xscale: f32, yscale: f32) callconv(.C) void;
pub const MouseButtonFn = *const fn (window: Window, button: MouseButton, action: ButtonState, mods: Modifiers) callconv(.C) void;
pub const CursorPosFn = *const fn (window: Window, xpos: f64, ypos: f64) callconv(.C) void;
pub const CursorEnterFn = *const fn (window: Window, entered: Bool) callconv(.C) void;
pub const ScrollFn = *const fn (window: Window, xoffset: f64, yoffset: f64) callconv(.C) void;
pub const KeyFn = *const fn (window: Window, key: Key, scan_code: c_int, action: KeyState, mods: Modifiers) callconv(.C) void;
pub const CharFn = *const fn (window: Window, code_point: c_uint) callconv(.C) void;
pub const CharModsFn = *const fn (window: Window, code_point: c_uint, mods: Modifiers) callconv(.C) void;
pub const DropFn = *const fn (window: Window, path_count: c_int, paths: [*][*:0]const u8) callconv(.C) void;
pub const MonitorFn = *const fn (monitor: Monitor, event: Event) callconv(.C) void;
pub const JoystickFn = *const fn (id: JoystickID, event: Event) callconv(.C) void;

pub const Vec2i = struct {
    x: i32 = 0,
    y: i32 = 0,
};

pub const Vec2f = struct {
    x: f32 = 0,
    y: f32 = 0,
};

pub const Rect = struct {
    x: i32 = 0,
    y: i32 = 0,
    width: i32 = 0,
    height: i32 = 0,
};

pub const FrameSize = struct {
    left: c_int,
    top: c_int,
    right: c_int,
    bottom: c_int,
};

pub const VideoMode = extern struct {
    width: c_int = 0,
    height: c_int = 0,
    redBits: c_int = 0,
    greenBits: c_int = 0,
    blueBits: c_int = 0,
    refreshRate: c_int = 0,
};

pub const GammaRamp = extern struct {
    red: [*]c_ushort,
    green: [*]c_ushort,
    blue: [*]c_ushort,
    size: c_uint = 0,
};

pub const Image = extern struct {
    width: c_int = 0,
    height: c_int = 0,
    pixels: [*]u8,
};

pub const GamepadState = extern struct {
    buttons: [15]ButtonState,
    axes: [6]f32,
};

pub const GlfwAllocator = extern struct {
    allocate: AllocateFn,
    reallocate: ReallocateFn,
    deallocate: DeallocateFn,
    user: ?*anyopaque = null,
};

pub const cdef = struct {
    pub extern fn glfwInit() Bool;
    pub extern fn glfwTerminate() void;
    pub extern fn glfwInitHint(hint: InitHint, value: c_int) void;
    pub extern fn glfwInitAllocator(allocator: ?*const GlfwAllocator) void;
    pub extern fn glfwGetVersion(major: ?*c_int, minor: ?*c_int, rev: ?*c_int) void;
    pub extern fn glfwGetVersionString() [*:0]const u8;
    pub extern fn glfwGetError(description: ?*[*:0]const u8) ErrorCode;
    pub extern fn glfwSetErrorCallback(callback: ErrorFn) ?ErrorFn;
    pub extern fn glfwGetPlatform() Platform;
    pub extern fn glfwPlatformSupported(platform: Platform) Bool;
    pub extern fn glfwGetMonitors(count: *c_int) ?[*]Monitor;
    pub extern fn glfwGetPrimaryMonitor() ?Monitor;
    pub extern fn glfwGetMonitorPos(monitor: Monitor, xpos: ?*c_int, ypos: ?*c_int) void;
    pub extern fn glfwGetMonitorWorkarea(monitor: Monitor, xpos: ?*c_int, ypos: ?*c_int, width: ?*c_int, height: ?*c_int) void;
    pub extern fn glfwGetMonitorPhysicalSize(monitor: Monitor, widthMM: ?*c_int, heightMM: ?*c_int) void;
    pub extern fn glfwGetMonitorContentScale(monitor: Monitor, xscale: ?*f32, yscale: ?*f32) void;
    pub extern fn glfwGetMonitorName(monitor: Monitor) ?[*:0]const u8;
    pub extern fn glfwSetMonitorUserPointer(monitor: Monitor, pointer: ?*anyopaque) void;
    pub extern fn glfwGetMonitorUserPointer(monitor: Monitor) ?*anyopaque;
    pub extern fn glfwSetMonitorCallback(callback: ?MonitorFn) ?MonitorFn;
    pub extern fn glfwGetVideoModes(monitor: Monitor, count: *c_int) ?[*]const VideoMode;
    pub extern fn glfwGetVideoMode(monitor: Monitor) ?*const VideoMode;
    pub extern fn glfwSetGamma(monitor: Monitor, gamma: f32) void;
    pub extern fn glfwGetGammaRamp(monitor: Monitor) ?*const GammaRamp;
    pub extern fn glfwSetGammaRamp(monitor: Monitor, ramp: *const GammaRamp) void;
    pub extern fn glfwDefaultWindowHints() void;
    pub extern fn glfwWindowHint(hint: WindowHint, value: c_int) void;
    pub extern fn glfwWindowHintString(hint: WindowHint, value: [*:0]const u8) void;
    pub extern fn glfwCreateWindow(width: c_int, height: c_int, title: [*:0]const u8, monitor: ?Monitor, share: ?Window) ?Window;
    pub extern fn glfwDestroyWindow(window: Window) void;
    pub extern fn glfwWindowShouldClose(window: Window) Bool;
    pub extern fn glfwSetWindowShouldClose(window: Window, value: Bool) void;
    pub extern fn glfwGetWindowTitle(window: Window) ?[*:0]const u8;
    pub extern fn glfwSetWindowTitle(window: Window, title: [*:0]const u8) void;
    pub extern fn glfwSetWindowIcon(window: Window, count: c_int, images: [*]const Image) void;
    pub extern fn glfwGetWindowPos(window: Window, xpos: ?*c_int, ypos: ?*c_int) void;
    pub extern fn glfwSetWindowPos(window: Window, xpos: c_int, ypos: c_int) void;
    pub extern fn glfwGetWindowSize(window: Window, width: ?*c_int, height: ?*c_int) void;
    pub extern fn glfwSetWindowSizeLimits(window: Window, minwidth: c_int, minheight: c_int, maxwidth: c_int, maxheight: c_int) void;
    pub extern fn glfwSetWindowAspectRatio(window: Window, numer: c_int, denom: c_int) void;
    pub extern fn glfwSetWindowSize(window: Window, width: c_int, height: c_int) void;
    pub extern fn glfwGetFramebufferSize(window: Window, width: ?*c_int, height: ?*c_int) void;
    pub extern fn glfwGetWindowFrameSize(window: Window, left: ?*c_int, top: ?*c_int, right: ?*c_int, bottom: ?*c_int) void;
    pub extern fn glfwGetWindowContentScale(window: Window, xscale: ?*f32, yscale: ?*f32) void;
    pub extern fn glfwGetWindowOpacity(window: Window) f32;
    pub extern fn glfwSetWindowOpacity(window: Window, opacity: f32) void;
    pub extern fn glfwIconifyWindow(window: Window) void;
    pub extern fn glfwRestoreWindow(window: Window) void;
    pub extern fn glfwMaximizeWindow(window: Window) void;
    pub extern fn glfwShowWindow(window: Window) void;
    pub extern fn glfwHideWindow(window: Window) void;
    pub extern fn glfwFocusWindow(window: Window) void;
    pub extern fn glfwRequestWindowAttention(window: Window) void;
    pub extern fn glfwGetWindowMonitor(window: Window) ?Monitor;
    pub extern fn glfwSetWindowMonitor(window: Window, monitor: ?Monitor, xpos: c_int, ypos: c_int, width: c_int, height: c_int, refreshRate: c_int) void;
    pub extern fn glfwGetWindowAttrib(window: Window, attrib: WindowGetAttribute) c_int;
    pub extern fn glfwSetWindowAttrib(window: Window, attrib: WindowSetAttribute, value: Bool) void;
    pub extern fn glfwSetWindowUserPointer(window: Window, pointer: ?*anyopaque) void;
    pub extern fn glfwGetWindowUserPointer(window: Window) ?*anyopaque;
    pub extern fn glfwSetWindowPosCallback(window: Window, callback: ?WindowPosFn) ?WindowPosFn;
    pub extern fn glfwSetWindowSizeCallback(window: Window, callback: ?WindowSizeFn) ?WindowSizeFn;
    pub extern fn glfwSetWindowCloseCallback(window: Window, callback: ?WindowCloseFn) ?WindowCloseFn;
    pub extern fn glfwSetWindowRefreshCallback(window: Window, callback: ?WindowRefreshFn) ?WindowRefreshFn;
    pub extern fn glfwSetWindowFocusCallback(window: Window, callback: ?WindowFocusFn) ?WindowFocusFn;
    pub extern fn glfwSetWindowIconifyCallback(window: Window, callback: ?WindowIconifyFn) ?WindowIconifyFn;
    pub extern fn glfwSetWindowMaximizeCallback(window: Window, callback: ?WindowMaximizeFn) ?WindowMaximizeFn;
    pub extern fn glfwSetFramebufferSizeCallback(window: Window, callback: ?FrameBufferSizeFn) ?FrameBufferSizeFn;
    pub extern fn glfwSetWindowContentScaleCallback(window: Window, callback: ?WindowContentScaleFn) ?WindowContentScaleFn;
    pub extern fn glfwPollEvents() void;
    pub extern fn glfwWaitEvents() void;
    pub extern fn glfwWaitEventsTimeout(timeout: f64) void;
    pub extern fn glfwPostEmptyEvent() void;
    pub extern fn glfwGetInputMode(window: Window, mode: InputMode) c_int;
    pub extern fn glfwSetInputMode(window: Window, mode: InputMode, value: c_int) void;
    pub extern fn glfwRawMouseMotionSupported() Bool;
    pub extern fn glfwGetKeyName(key: Key, scancode: c_int) ?[*:0]const u8;
    pub extern fn glfwGetKeyScancode(key: Key) c_int;
    pub extern fn glfwGetKey(window: Window, key: Key) ButtonState;
    pub extern fn glfwGetMouseButton(window: Window, button: MouseButton) ButtonState;
    pub extern fn glfwGetCursorPos(window: Window, xpos: ?*f64, ypos: ?*f64) void;
    pub extern fn glfwSetCursorPos(window: Window, xpos: f64, ypos: f64) void;
    pub extern fn glfwCreateCursor(image: *const Image, xhot: c_int, yhot: c_int) ?Cursor;
    pub extern fn glfwCreateStandardCursor(shape: CursorShape) ?Cursor;
    pub extern fn glfwDestroyCursor(cursor: Cursor) void;
    pub extern fn glfwSetCursor(window: Window, cursor: ?Cursor) void;
    pub extern fn glfwSetKeyCallback(window: Window, callback: ?KeyFn) ?KeyFn;
    pub extern fn glfwSetCharCallback(window: Window, callback: ?CharFn) ?CharFn;
    pub extern fn glfwSetCharModsCallback(window: Window, callback: ?CharModsFn) ?CharModsFn;
    pub extern fn glfwSetMouseButtonCallback(window: Window, callback: ?MouseButtonFn) ?MouseButtonFn;
    pub extern fn glfwSetCursorPosCallback(window: Window, callback: ?CursorPosFn) ?CursorPosFn;
    pub extern fn glfwSetCursorEnterCallback(window: Window, callback: ?CursorEnterFn) ?CursorEnterFn;
    pub extern fn glfwSetScrollCallback(window: Window, callback: ?ScrollFn) ?ScrollFn;
    pub extern fn glfwSetDropCallback(window: Window, callback: ?DropFn) ?DropFn;
    pub extern fn glfwJoystickPresent(jid: JoystickID) Bool;
    pub extern fn glfwGetJoystickAxes(jid: JoystickID, count: *c_int) ?[*]const f32;
    pub extern fn glfwGetJoystickButtons(jid: JoystickID, count: *c_int) ?[*]const ButtonState;
    pub extern fn glfwGetJoystickHats(jid: JoystickID, count: *c_int) ?[*]const HatState;
    pub extern fn glfwGetJoystickName(jid: JoystickID) ?[*:0]const u8;
    pub extern fn glfwGetJoystickGUID(jid: JoystickID) ?[*:0]const u8;
    pub extern fn glfwSetJoystickUserPointer(jid: JoystickID, pointer: ?*anyopaque) void;
    pub extern fn glfwGetJoystickUserPointer(jid: JoystickID) ?*anyopaque;
    pub extern fn glfwJoystickIsGamepad(jid: JoystickID) Bool;
    pub extern fn glfwSetJoystickCallback(callback: ?JoystickFn) ?JoystickFn;
    pub extern fn glfwUpdateGamepadMappings(string: [*:0]const u8) Bool;
    pub extern fn glfwGetGamepadName(jid: JoystickID) ?[*:0]const u8;
    pub extern fn glfwGetGamepadState(jid: JoystickID, state: *GamepadState) Bool;
    pub extern fn glfwSetClipboardString(window: ?Window, string: [*:0]const u8) void;
    pub extern fn glfwGetClipboardString(window: ?Window) ?[*:0]const u8;
    pub extern fn glfwGetTime() f64;
    pub extern fn glfwSetTime(time: f64) void;
    pub extern fn glfwGetTimerValue() u64;
    pub extern fn glfwGetTimerFrequency() u64;
    pub extern fn glfwMakeContextCurrent(window: ?Window) void;
    pub extern fn glfwGetCurrentContext() ?Window;
    pub extern fn glfwSwapBuffers(window: Window) void;
    pub extern fn glfwSwapInterval(interval: c_int) void;
    pub extern fn glfwExtensionSupported(extension: [*:0]const u8) Bool;
    pub extern fn glfwGetProcAddress(procname: [*:0]const u8) ?GLProc;
    pub extern fn glfwVulkanSupported() Bool;
    pub extern fn glfwGetRequiredInstanceExtensions(count: *u32) ?[*][*:0]const u8;
    pub extern fn glfwInitVulkanLoader(loader: ?PFN_vkGetInstanceProcAddr) void;
    pub extern fn glfwGetInstanceProcAddress(instance: ?VkInstance, procname: [*:0]const u8) ?VkProc;
    pub extern fn glfwGetPhysicalDevicePresentationSupport(instance: VkInstance, device: VkPhysicalDevice, queuefamily: u32) Bool;
    pub extern fn glfwCreateWindowSurface(instance: VkInstance, window: Window, allocator: ?*const VkAllocationCallbacks, surface: *VkSurfaceKHR) VkResult;

    pub extern fn glfwGetWin32Adapter(monitor: Monitor) ?[*:0]const u8;
    pub extern fn glfwGetWin32Monitor(monitor: Monitor) ?[*:0]const u8;
    pub extern fn glfwGetWin32Window(window: Window) ?*anyopaque;
    pub extern fn glfwGetWGLContext(window: Window) ?*anyopaque;
    pub extern fn glfwGetCocoaMonitor(monitor: Monitor) c_uint;
    pub extern fn glfwGetCocoaWindow(window: Window) ?*anyopaque;
    pub extern fn glfwGetCocoaView(window: Window) ?*anyopaque;
    pub extern fn glfwGetNSGLContext(window: Window) ?*anyopaque;
    pub extern fn glfwGetX11Display() ?*anyopaque;
    pub extern fn glfwGetX11Adapter(monitor: Monitor) c_ulong;
    pub extern fn glfwGetX11Monitor(monitor: Monitor) c_ulong;
    pub extern fn glfwGetX11Window(window: Window) c_ulong;
    pub extern fn glfwSetX11SelectionString(string: [*:0]const u8) void;
    pub extern fn glfwGetX11SelectionString() ?[*:0]const u8;
    pub extern fn glfwGetGLXContext(window: Window) ?*anyopaque;
    pub extern fn glfwGetGLXWindow(window: Window) c_ulong;
    pub extern fn glfwGetWaylandDisplay() ?*anyopaque;
    pub extern fn glfwGetWaylandMonitor(monitor: Monitor) ?*anyopaque;
    pub extern fn glfwGetWaylandWindow(window: Window) ?*anyopaque;
    pub extern fn glfwGetEGLDisplay() ?*anyopaque;
    pub extern fn glfwGetEGLContext(window: Window) ?*anyopaque;
    pub extern fn glfwGetEGLSurface(window: Window) ?*anyopaque;

    // OSMesa
    pub extern fn glfwGetOSMesaColorBuffer(window: Window, width: ?*c_int, height: ?*c_int, format: ?*c_int, buffer: ?[*][*]u8) Bool;
    pub extern fn glfwGetOSMesaDepthBuffer(window: Window, width: ?*c_int, height: ?*c_int, bytesPerValue: ?*c_int, buffer: ?[*][*]u8) Bool;
    pub extern fn glfwGetOSMesaContext(window: Window) ?*anyopaque;
};

pub fn init() Error!void {
    _ = setErrorCallback(&defaultErrorCallbac);
    if (cdef.glfwInit() == .false) try checkError();
}

fn defaultErrorCallbac(error_code: ErrorCode, description: [*:0]const u8) callconv(.C) void {
    std.log.err("GLFW {s}: {s}", .{ @tagName(error_code), description });
}

pub fn initAllocator(allocator: ?Allocator) void {
    const Fn = struct {
        // NOTE: Glfw only allows calling this function from the main thread, and it only has effect
        // while glfw is initilazied. As a result, allocations are guaranteed to not leak from an
        // allocator to another, so it's safe to have a single global one.
        var alloc: Allocator = undefined;
        const prefix_len = @sizeOf(usize);

        // TODO: I don't know what alignment implications has packing the length
        // TODO: Make sure to align the allocations as close to what GLFW expects

        fn allocate(size: usize, _: ?*anyopaque) callconv(.C) ?[*]u8 {
            const slice = alloc.alloc(u8, size + prefix_len) catch return null;
            std.mem.bytesAsValue(usize, slice[0..prefix_len]).* = slice.len;
            return slice[prefix_len..].ptr;
        }

        fn reallocate(block: [*]u8, size: usize, _: ?*anyopaque) callconv(.C) ?[*]u8 {
            const base_ptr: [*]u8 = @ptrFromInt(@intFromPtr(block) - prefix_len);
            const slice_len = std.mem.bytesToValue(usize, base_ptr[0..prefix_len]);

            const slice = alloc.realloc(base_ptr[0..slice_len], size + prefix_len) catch return null;
            std.mem.bytesAsValue(usize, slice[0..prefix_len]).* = slice.len;
            return slice[prefix_len..].ptr;
        }

        fn deallocate(block: [*]u8, _: ?*anyopaque) callconv(.C) void {
            const base_ptr: [*]u8 = @ptrFromInt(@intFromPtr(block) - prefix_len);
            const slice_len = std.mem.bytesToValue(usize, base_ptr[0..prefix_len]);
            alloc.free(base_ptr[0..slice_len]);
        }
    };

    if (allocator) |alloc| {
        Fn.alloc = alloc;
        cdef.glfwInitAllocator(&.{
            .allocate = Fn.allocate,
            .reallocate = Fn.reallocate,
            .deallocate = Fn.deallocate,
        });
    }
}

pub fn setWindowIcon(window: Window, images: []const Image) Error!void {
    cdef.glfwSetWindowIcon(window, @intCast(images.len), images.ptr);
    try checkError();
}

pub fn getWindowPos(window: Window) Error!Vec2i {
    var pos: Vec2i = undefined;
    cdef.glfwGetWindowPos(window, &pos.x, &pos.y);
    try checkError();
    return pos;
}

pub fn setWindowPos(self: Window, xpos: i32, ypos: i32) Error!void {
    cdef.glfwSetWindowPos(self, @intCast(xpos), @intCast(ypos));
    try checkError();
}

pub fn getWindowSize(window: Window) Vec2i {
    var pos: Vec2i = undefined;
    cdef.glfwGetWindowPos(window, &pos.x, &pos.y);
    return pos;
}

pub fn setGamma(self: Monitor, gamma: f32) Error!void {
    cdef.glfwSetGamma(self, gamma);
    try checkError();
}

pub fn getGammaRamp(self: Monitor) Error!GammaRamp {
    if (cdef.glfwGetGammaRamp(self)) |ramp| return ramp.*;
    try checkError();
    unreachable;
}

pub fn setGammaRamp(self: Monitor, ramp: GammaRamp) Error!void {
    cdef.glfwSetGammaRamp(self, &ramp);
    try checkError();
}

pub fn createWindow(width: c_int, height: c_int, title: [*:0]const u8, monitor: ?Monitor, share: ?Window) Error!Window {
    if (cdef.glfwCreateWindow(width, height, title, monitor, share)) |window| {
        return window;
    }
    try checkError();
    unreachable;
}

pub fn setWindowOpacity(self: Window, opacity: f32) Error!void {
    cdef.glfwSetWindowOpacity(self, opacity);
    try checkError();
}

pub fn setWindowAttrib(self: Window, comptime attrib: WindowSetAttribute, value: bool) Error!void {
    cdef.glfwSetWindowAttrib(self, attrib, if (value) .true else .false);
    try checkError();
}

pub fn setInputMode(window: Window, comptime mode: InputMode, value: InputMode.ValueType(mode)) Error!void {
    cdef.glfwSetInputMode(window, mode, if (value) .true else .false);
    try checkError();
}

pub fn setCursorPos(window: Window, xpos: f64, ypos: f64) Error!void {
    cdef.glfwSetCursorPos(window, xpos, ypos);
    try checkError();
}

pub fn createCursor(image: Image, xhot: c_int, yhot: c_int) Error!Cursor {
    if (cdef.glfwCreateCursor(&image, xhot, yhot)) |cursor| return cursor;
    try checkError();
    unreachable;
}

pub fn createStandardCursor(shape: CursorShape) Error!Cursor {
    if (cdef.glfwCreateStandardCursor(shape)) |cursor| return cursor;
    try checkError();
    unreachable;
}

pub fn updateGamepadMappings(string: [*:0]const u8) Error!void {
    if (cdef.glfwUpdateGamepadMappings(string) == .true) return;
    try checkError();
    unreachable;
}

pub fn getClipboardString(window: ?Window) Error![*:0]const u8 {
    if (cdef.glfwGetClipboardString(window)) |str| return str;
    try checkError();
    unreachable;
}

pub fn getRequiredInstanceExtensions() Error![]const [*:0]const u8 {
    var count: u32 = undefined;
    if (cdef.glfwGetRequiredInstanceExtensions(&count)) |exts| {
        return exts[0..count];
    }
    try checkError();
    unreachable;
}

pub fn getMonitors() []const Monitor {
    var count: c_int = undefined;
    if (cdef.glfwGetMonitors(&count)) |monitors| {
        return monitors[0..@intCast(count)];
    }
    return &.{};
}

pub fn getVideoModes(monitor: Monitor) []const VideoMode {
    var count: c_int = undefined;
    if (cdef.glfwGetVideoModes(monitor, &count)) |modes| {
        return modes[0..@intCast(count)];
    }
    return &.{};
}

pub fn getJoystickAxes(jid: JoystickID) []const f32 {
    var count: c_int = undefined;
    if (cdef.glfwGetJoystickAxes(jid, &count)) |axes| {
        return axes[0..@intCast(count)];
    }
    return &.{};
}

pub fn getJoystickButtons(jid: JoystickID) []const ButtonState {
    var count: c_int = undefined;
    if (cdef.glfwGetJoystickButtons(jid, &count)) |buttons| {
        return buttons[0..@intCast(count)];
    }
    return &.{};
}

pub fn getJoystickHats(jid: JoystickID) []const HatState {
    var count: c_int = undefined;
    if (cdef.glfwGetJoystickHats(jid, &count)) |hats| {
        return hats[0..@intCast(count)];
    }
    return &.{};
}

pub fn initHint(comptime hint: InitHint, value: InitHint.ValueType(hint)) void {
    cdef.glfwInitHint(hint, castToCint(value));
}

pub fn windowHint(comptime hint: WindowHint, value: WindowHint.ValueType(hint)) void {
    if (@TypeOf(value) == [*:0]const u8) {
        cdef.glfwWindowHintString(hint, value);
    } else {
        cdef.glfwWindowHint(hint, castToCint(value));
    }
}

pub fn getWindowAttrib(window: Window, comptime attrib: WindowGetAttribute) WindowGetAttribute.ValueType(attrib) {
    const value = cdef.glfwGetWindowAttrib(window, attrib);
    return castFromCint(WindowGetAttribute.ValueType(attrib), value);
}

pub fn getInputMode(window: Window, comptime mode: InputMode) InputMode.ValueType(mode) {
    const value = cdef.glfwGetInputMode(window, mode);
    return castFromCint(InputMode.ValueType(mode), value);
}

pub fn platformSupported(platform: Platform) bool {
    return cdef.glfwPlatformSupported(platform) == .true;
}

pub fn windowShouldClose(window: Window) bool {
    return cdef.glfwWindowShouldClose(window) == .true;
}

pub fn setWindowShouldClose(window: Window, value: bool) void {
    cdef.glfwSetWindowShouldClose(window, if (value) .true else .false);
}

pub fn rawMouseMotionSupported() bool {
    return cdef.glfwRawMouseMotionSupported() == .true;
}

pub fn joystickPresent(jid: JoystickID) bool {
    return cdef.glfwJoystickPresent(jid) == .true;
}

pub fn joystickIsGamepad(jid: JoystickID) bool {
    return cdef.glfwJoystickIsGamepad(jid) == .true;
}

pub fn getGamepadState(jid: JoystickID, state: *GamepadState) bool {
    return cdef.glfwGetGamepadState(jid, state) == .true;
}

pub fn extensionSupported(extension: [*:0]const u8) bool {
    return cdef.glfwExtensionSupported(extension) == .true;
}

pub fn vulkanSupported() bool {
    return cdef.glfwVulkanSupported() == .true;
}

pub fn getPhysicalDevicePresentationSupport(instance: VkInstance, device: VkPhysicalDevice, queuefamily: u32) bool {
    return cdef.glfwGetPhysicalDevicePresentationSupport(instance, device, queuefamily) == .true;
}

pub fn getOSMesaColorBuffer(window: Window, width: ?*c_int, height: ?*c_int, format: ?*c_int, buffer: ?[*][*]u8) bool {
    if (!native_osmesa) @panic("Native osmesa features not exposed");
    return cdef.glfwGetOSMesaColorBuffer(window, width, height, format, buffer) == .true;
}

pub fn getOSMesaDepthBuffer(window: Window, width: ?*c_int, height: ?*c_int, bytesPerValue: ?*c_int, buffer: ?[*][*]u8) bool {
    if (!native_osmesa) @panic("Native osmesa features not exposed");
    return cdef.glfwGetOSMesaDepthBuffer(window, width, height, bytesPerValue, buffer) == .true;
}

const stub = struct {
    pub fn glfwGetWin32Adapter(_: Monitor) callconv(.C) ?[*:0]const u8 {
        @panic("Native win32 features not exposed");
    }
    pub fn glfwGetWin32Monitor(_: Monitor) callconv(.C) ?[*:0]const u8 {
        @panic("Native win32 features not exposed");
    }
    pub fn glfwGetWin32Window(_: Window) callconv(.C) ?*anyopaque {
        @panic("Native win32 features not exposed");
    }
    pub fn glfwGetWGLContext(_: Window) callconv(.C) ?*anyopaque {
        @panic("Native wgl features not exposed");
    }
    pub fn glfwGetCocoaMonitor(_: Monitor) callconv(.C) c_uint {
        @panic("Native cocoa features not exposed");
    }
    pub fn glfwGetCocoaWindow(_: Window) callconv(.C) ?*anyopaque {
        @panic("Native cocoa features not exposed");
    }
    pub fn glfwGetCocoaView(_: Window) callconv(.C) ?*anyopaque {
        @panic("Native cocoa features not exposed");
    }
    pub fn glfwGetNSGLContext(_: Window) callconv(.C) ?*anyopaque {
        @panic("Native nsgl features not exposed");
    }
    pub fn glfwGetX11Display() callconv(.C) ?*anyopaque {
        @panic("Native x11 features not exposed");
    }
    pub fn glfwGetX11Adapter(_: Monitor) callconv(.C) c_ulong {
        @panic("Native x11 features not exposed");
    }
    pub fn glfwGetX11Monitor(_: Monitor) callconv(.C) c_ulong {
        @panic("Native x11 features not exposed");
    }
    pub fn glfwGetX11Window(_: Window) callconv(.C) c_ulong {
        @panic("Native x11 features not exposed");
    }
    pub fn glfwSetX11SelectionString(_: [*:0]const u8) callconv(.C) void {
        @panic("Native x11 features not exposed");
    }
    pub fn glfwGetX11SelectionString() callconv(.C) ?[*:0]const u8 {
        @panic("Native x11 features not exposed");
    }
    pub fn glfwGetGLXContext(_: Window) callconv(.C) ?*anyopaque {
        @panic("Native glx features not exposed");
    }
    pub fn glfwGetGLXWindow(_: Window) callconv(.C) c_ulong {
        @panic("Native glx features not exposed");
    }
    pub fn glfwGetWaylandDisplay() callconv(.C) ?*anyopaque {
        @panic("Native wayland features not exposed");
    }
    pub fn glfwGetWaylandMonitor(_: Monitor) callconv(.C) ?*anyopaque {
        @panic("Native wayland features not exposed");
    }
    pub fn glfwGetWaylandWindow(_: Window) callconv(.C) ?*anyopaque {
        @panic("Native wayland features not exposed");
    }
    pub fn glfwGetEGLDisplay() callconv(.C) ?*anyopaque {
        @panic("Native egl features not exposed");
    }
    pub fn glfwGetEGLContext(_: Window) callconv(.C) ?*anyopaque {
        @panic("Native egl features not exposed");
    }
    pub fn glfwGetEGLSurface(_: Window) callconv(.C) ?*anyopaque {
        @panic("Native egl features not exposed");
    }
    pub fn glfwGetOSMesaContext(_: Window) callconv(.C) ?*anyopaque {
        @panic("Native osmesa features not exposed");
    }
};

pub const terminate = cdef.glfwTerminate;
pub const getVersion = cdef.glfwGetVersion;
pub const getVersionString = cdef.glfwGetVersionString;
pub const getError = cdef.glfwGetError;
pub const setErrorCallback = cdef.glfwSetErrorCallback;
pub const getPlatform = cdef.glfwGetPlatform;
pub const getPrimaryMonitor = cdef.glfwGetPrimaryMonitor;
pub const getMonitorPos = cdef.glfwGetMonitorPos;
pub const getMonitorWorkarea = cdef.glfwGetMonitorWorkarea;
pub const getMonitorPhysicalSize = cdef.glfwGetMonitorPhysicalSize;
pub const getMonitorContentScale = cdef.glfwGetMonitorContentScale;
pub const getMonitorName = cdef.glfwGetMonitorName;
pub const setMonitorUserPointer = cdef.glfwSetMonitorUserPointer;
pub const getMonitorUserPointer = cdef.glfwGetMonitorUserPointer;
pub const setMonitorCallback = cdef.glfwSetMonitorCallback;
pub const getVideoMode = cdef.glfwGetVideoMode;
pub const defaultWindowHints = cdef.glfwDefaultWindowHints;
pub const destroyWindow = cdef.glfwDestroyWindow;
pub const getWindowTitle = cdef.glfwGetWindowTitle;
pub const setWindowTitle = cdef.glfwSetWindowTitle;
pub const setWindowSizeLimits = cdef.glfwSetWindowSizeLimits;
pub const setWindowAspectRatio = cdef.glfwSetWindowAspectRatio;
pub const setWindowSize = cdef.glfwSetWindowSize;
pub const getFramebufferSize = cdef.glfwGetFramebufferSize;
pub const getWindowFrameSize = cdef.glfwGetWindowFrameSize;
pub const getWindowContentScale = cdef.glfwGetWindowContentScale;
pub const getWindowOpacity = cdef.glfwGetWindowOpacity;
pub const iconifyWindow = cdef.glfwIconifyWindow;
pub const restoreWindow = cdef.glfwRestoreWindow;
pub const maximizeWindow = cdef.glfwMaximizeWindow;
pub const showWindow = cdef.glfwShowWindow;
pub const hideWindow = cdef.glfwHideWindow;
pub const focusWindow = cdef.glfwFocusWindow;
pub const requestWindowAttention = cdef.glfwRequestWindowAttention;
pub const getWindowMonitor = cdef.glfwGetWindowMonitor;
pub const setWindowMonitor = cdef.glfwSetWindowMonitor;
pub const setWindowUserPointer = cdef.glfwSetWindowUserPointer;
pub const getWindowUserPointer = cdef.glfwGetWindowUserPointer;
pub const setWindowPosCallback = cdef.glfwSetWindowPosCallback;
pub const setWindowSizeCallback = cdef.glfwSetWindowSizeCallback;
pub const setWindowCloseCallback = cdef.glfwSetWindowCloseCallback;
pub const setWindowRefreshCallback = cdef.glfwSetWindowRefreshCallback;
pub const setWindowFocusCallback = cdef.glfwSetWindowFocusCallback;
pub const setWindowIconifyCallback = cdef.glfwSetWindowIconifyCallback;
pub const setWindowMaximizeCallback = cdef.glfwSetWindowMaximizeCallback;
pub const setFramebufferSizeCallback = cdef.glfwSetFramebufferSizeCallback;
pub const setWindowContentScaleCallback = cdef.glfwSetWindowContentScaleCallback;
pub const pollEvents = cdef.glfwPollEvents;
pub const waitEvents = cdef.glfwWaitEvents;
pub const waitEventsTimeout = cdef.glfwWaitEventsTimeout;
pub const postEmptyEvent = cdef.glfwPostEmptyEvent;
pub const getKeyName = cdef.glfwGetKeyName;
pub const getKeyScancode = cdef.glfwGetKeyScancode;
pub const getKey = cdef.glfwGetKey;
pub const getMouseButton = cdef.glfwGetMouseButton;
pub const getCursorPos = cdef.glfwGetCursorPos;
pub const destroyCursor = cdef.glfwDestroyCursor;
pub const setCursor = cdef.glfwSetCursor;
pub const setKeyCallback = cdef.glfwSetKeyCallback;
pub const setCharCallback = cdef.glfwSetCharCallback;
pub const setCharModsCallback = cdef.glfwSetCharModsCallback;
pub const setMouseButtonCallback = cdef.glfwSetMouseButtonCallback;
pub const setCursorPosCallback = cdef.glfwSetCursorPosCallback;
pub const setCursorEnterCallback = cdef.glfwSetCursorEnterCallback;
pub const setScrollCallback = cdef.glfwSetScrollCallback;
pub const setDropCallback = cdef.glfwSetDropCallback;
pub const getJoystickName = cdef.glfwGetJoystickName;
pub const getJoystickGUID = cdef.glfwGetJoystickGUID;
pub const setJoystickUserPointer = cdef.glfwSetJoystickUserPointer;
pub const getJoystickUserPointer = cdef.glfwGetJoystickUserPointer;
pub const setJoystickCallback = cdef.glfwSetJoystickCallback;
pub const getGamepadName = cdef.glfwGetGamepadName;
pub const setClipboardString = cdef.glfwSetClipboardString;
pub const getTime = cdef.glfwGetTime;
pub const setTime = cdef.glfwSetTime;
pub const getTimerValue = cdef.glfwGetTimerValue;
pub const getTimerFrequency = cdef.glfwGetTimerFrequency;
pub const makeContextCurrent = cdef.glfwMakeContextCurrent;
pub const getCurrentContext = cdef.glfwGetCurrentContext;
pub const swapBuffers = cdef.glfwSwapBuffers;
pub const swapInterval = cdef.glfwSwapInterval;
pub const getProcAddress = cdef.glfwGetProcAddress;
pub const initVulkanLoader = cdef.glfwInitVulkanLoader;
pub const getInstanceProcAddress = cdef.glfwGetInstanceProcAddress;
pub const createWindowSurface = cdef.glfwCreateWindowSurface;

pub const getWin32Adapter: @TypeOf(cdef.glfwGetWin32Adapter) = if (native_win32) cdef.glfwGetWin32Adapter else stub.glfwGetWin32Adapter;
pub const getWin32Monitor: @TypeOf(cdef.glfwGetWin32Monitor) = if (native_win32) cdef.glfwGetWin32Monitor else stub.glfwGetWin32Monitor;
pub const getWin32Window: @TypeOf(cdef.glfwGetWin32Window) = if (native_win32) cdef.glfwGetWin32Window else stub.glfwGetWin32Window;
pub const getWGLContext: @TypeOf(cdef.glfwGetWGLContext) = if (native_wgl) cdef.glfwGetWGLContext else stub.glfwGetWGLContext;
pub const getCocoaMonitor: @TypeOf(cdef.glfwGetCocoaMonitor) = if (native_cocoa) cdef.glfwGetCocoaMonitor else stub.glfwGetCocoaMonitor;
pub const getCocoaWindow: @TypeOf(cdef.glfwGetCocoaWindow) = if (native_cocoa) cdef.glfwGetCocoaWindow else stub.glfwGetCocoaWindow;
pub const getCocoaView: @TypeOf(cdef.glfwGetCocoaView) = if (native_cocoa) cdef.glfwGetCocoaView else stub.glfwGetCocoaView;
pub const getNSGLContext: @TypeOf(cdef.glfwGetNSGLContext) = if (native_nsgl) cdef.glfwGetNSGLContext else stub.glfwGetNSGLContext;
pub const getX11Display: @TypeOf(cdef.glfwGetX11Display) = if (native_x11) cdef.glfwGetX11Display else stub.glfwGetX11Display;
pub const getX11Adapter: @TypeOf(cdef.glfwGetX11Adapter) = if (native_x11) cdef.glfwGetX11Adapter else stub.glfwGetX11Adapter;
pub const getX11Monitor: @TypeOf(cdef.glfwGetX11Monitor) = if (native_x11) cdef.glfwGetX11Monitor else stub.glfwGetX11Monitor;
pub const getX11Window: @TypeOf(cdef.glfwGetX11Window) = if (native_x11) cdef.glfwGetX11Window else stub.glfwGetX11Window;
pub const setX11SelectionString: @TypeOf(cdef.glfwSetX11SelectionString) = if (native_x11) cdef.glfwSetX11SelectionString else stub.glfwSetX11SelectionString;
pub const getX11SelectionString: @TypeOf(cdef.glfwGetX11SelectionString) = if (native_x11) cdef.glfwGetX11SelectionString else stub.glfwGetX11SelectionString;
pub const getGLXContext: @TypeOf(cdef.glfwGetGLXContext) = if (native_glx) cdef.glfwGetGLXContext else stub.glfwGetGLXContext;
pub const getGLXWindow: @TypeOf(cdef.glfwGetGLXWindow) = if (native_glx) cdef.glfwGetGLXWindow else stub.glfwGetGLXWindow;
pub const getWaylandDisplay: @TypeOf(cdef.glfwGetWaylandDisplay) = if (native_wayland) cdef.glfwGetWaylandDisplay else stub.glfwGetWaylandDisplay;
pub const getWaylandMonitor: @TypeOf(cdef.glfwGetWaylandMonitor) = if (native_wayland) cdef.glfwGetWaylandMonitor else stub.glfwGetWaylandMonitor;
pub const getWaylandWindow: @TypeOf(cdef.glfwGetWaylandWindow) = if (native_wayland) cdef.glfwGetWaylandWindow else stub.glfwGetWaylandWindow;
pub const getEGLDisplay: @TypeOf(cdef.glfwGetEGLDisplay) = if (native_egl) cdef.glfwGetEGLDisplay else stub.glfwGetEGLDisplay;
pub const getEGLContext: @TypeOf(cdef.glfwGetEGLContext) = if (native_egl) cdef.glfwGetEGLContext else stub.glfwGetEGLContext;
pub const getEGLSurface: @TypeOf(cdef.glfwGetEGLSurface) = if (native_egl) cdef.glfwGetEGLSurface else stub.glfwGetEGLSurface;
pub const getOSMesaContext: @TypeOf(cdef.glfwGetOSMesaContext) = if (native_osmesa) cdef.glfwGetOSMesaContext else stub.glfwGetOSMesaContext;

pub const Monitor = *opaque {
    pub const getPos = glfw.getMonitorPos;
    pub const getWorkarea = glfw.getMonitorWorkarea;
    pub const getPhysicalSize = glfw.getMonitorPhysicalSize;
    pub const getContentScale = glfw.getMonitorContentScale;
    pub const getName = glfw.getMonitorName;
    pub const setUserPointer = glfw.setMonitorUserPointer;
    pub const getUserPointer = glfw.getMonitorUserPointer;
    pub const getVideoModes = glfw.getVideoModes;
    pub const getVideoMode = glfw.getVideoMode;
    pub const setGamma = glfw.setGamma;
    pub const getGammaRamp = glfw.getGammaRamp;
    pub const setGammaRamp = glfw.setGammaRamp;
};

pub const Window = *opaque {
    pub const destroy = glfw.destroyWindow;
    pub const shouldClose = glfw.windowShouldClose;
    pub const setShouldClose = glfw.setWindowShouldClose;
    pub const getTitle = glfw.getWindowTitle;
    pub const setTitle = glfw.setWindowTitle;
    pub const setIcon = glfw.setWindowIcon;
    pub const getPos = glfw.getWindowPos;
    pub const setPos = glfw.setWindowPos;
    pub const getSize = glfw.getWindowSize;
    pub const setSizeLimits = glfw.setWindowSizeLimits;
    pub const setAspectRatio = glfw.setWindowAspectRatio;
    pub const setSize = glfw.setWindowSize;
    pub const getFramebufferSize = glfw.getFramebufferSize;
    pub const getFrameSize = glfw.getWindowFrameSize;
    pub const getContentScale = glfw.getWindowContentScale;
    pub const getOpacity = glfw.getWindowOpacity;
    pub const setOpacity = glfw.setWindowOpacity;
    pub const iconify = glfw.iconifyWindow;
    pub const restore = glfw.restoreWindow;
    pub const maximize = glfw.maximizeWindow;
    pub const show = glfw.showWindow;
    pub const hide = glfw.hideWindow;
    pub const focus = glfw.focusWindow;
    pub const requestAttention = glfw.requestWindowAttention;
    pub const getMonitor = glfw.getWindowMonitor;
    pub const setMonitor = glfw.setWindowMonitor;
    pub const getAttrib = glfw.getWindowAttrib;
    pub const setAttrib = glfw.setWindowAttrib;
    pub const setUserPointer = glfw.setWindowUserPointer;
    pub const getUserPointer = glfw.getWindowUserPointer;
    pub const setPosCallback = glfw.setWindowPosCallback;
    pub const setSizeCallback = glfw.setWindowSizeCallback;
    pub const setCloseCallback = glfw.setWindowCloseCallback;
    pub const setRefreshCallback = glfw.setWindowRefreshCallback;
    pub const setFocusCallback = glfw.setWindowFocusCallback;
    pub const setIconifyCallback = glfw.setWindowIconifyCallback;
    pub const setMaximizeCallback = glfw.setWindowMaximizeCallback;
    pub const setFramebufferSizeCallback = glfw.setFramebufferSizeCallback;
    pub const setContentScaleCallback = glfw.setWindowContentScaleCallback;
    pub const getInputMode = glfw.getInputMode;
    pub const setInputMode = glfw.setInputMode;
    pub const getKey = glfw.getKey;
    pub const getMouseButton = glfw.getMouseButton;
    pub const getCursorPos = glfw.getCursorPos;
    pub const setCursorPos = glfw.setCursorPos;
    pub const setCursor = glfw.setCursor;
    pub const setKeyCallback = glfw.setKeyCallback;
    pub const setCharCallback = glfw.setCharCallback;
    pub const setCharModsCallback = glfw.setCharModsCallback;
    pub const setMouseButtonCallback = glfw.setMouseButtonCallback;
    pub const setCursorPosCallback = glfw.setCursorPosCallback;
    pub const setCursorEnterCallback = glfw.setCursorEnterCallback;
    pub const setScrollCallback = glfw.setScrollCallback;
    pub const setDropCallback = glfw.setDropCallback;
    pub const swapBuffers = glfw.swapBuffers;

    pub fn setClipboardString(self: Window, string: [*:0]const u8) void {
        return glfw.setClipboardString(self, string);
    }
    pub fn getClipboardString(self: Window) Error![*:0]const u8 {
        return glfw.getClipboardString(self);
    }
    pub fn makeContextCurrent(self: Window) void {
        return glfw.makeContextCurrent(self);
    }
};

pub const Cursor = *opaque {
    pub const destroy = glfw.destroyCursor;
};
