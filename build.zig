const std = @import("std");

pub fn build(b: *std.Build) void {
    const name = "example";

    const target = b.resolveTargetQuery(.{
        .cpu_arch = .thumb,
        .os_tag = .freestanding,
        .abi = .eabihf,
        .cpu_model = .{ .explicit = &std.Target.arm.cpu.cortex_m7 },
        .cpu_features_add = std.Target.arm.featureSet(&[_]std.Target.arm.Feature{
            .thumb2,
            .noarm,
        }),
    });

    const icon_convert_cmd = b.addSystemCommand(&.{
        "nwlink", "png-nwi", "src/icon.png", "src/icon.nwi"
    });
    icon_convert_cmd.addFileInput(b.path("src/icon.png"));

    const obj = b.addObject(.{
        .name = name,
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = .ReleaseFast,
        .link_libc = false,
    });

    obj.linker_allow_shlib_undefined = true;
    obj.link_emit_relocs = true;
    obj.link_gc_sections = false;

    obj.entry = .{
        .symbol_name = "main",
    };

    obj.root_module.stack_protector = false;
    obj.bundle_compiler_rt = true;

    const eadk = b.dependency("zigworks", .{});
    obj.root_module.addImport("eadk", eadk.module("eadk"));

    obj.step.dependOn(&icon_convert_cmd.step);

    // ---

    const nwlink_cmd = b.addSystemCommand(&.{
        "npx", "--yes", "--", "nwlink@0.0.19", "install-nwa",
    });
    nwlink_cmd.addArtifactArg(obj);

    const install_step = b.step("install-nwa", "Install NWA using nwlink");
    install_step.dependOn(&nwlink_cmd.step);

    // ---

    const create_folders = b.addSystemCommand(&.{
        "mkdir", "-p", "./zig-out/bin/"
    });
    const make_nwa_file = b.addSystemCommand(&.{
        "cp"
    });
    make_nwa_file.addArtifactArg(obj);
    make_nwa_file.addArg("./zig-out/bin/" ++ name ++ ".nwa");

    const build_nwa_step = b.step("nwa", "Build an NWA file for later use or publication");
    build_nwa_step.dependOn(&obj.step);
    build_nwa_step.dependOn(&create_folders.step);
    build_nwa_step.dependOn(&make_nwa_file.step);
}
