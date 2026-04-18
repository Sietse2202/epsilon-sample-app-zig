const eadk = @import("eadk");
const random = eadk.random;
const display = eadk.display;
const screen_width = display.screen_width;
const screen_height = display.screen_height;
const Point = display.Point;
const Rect = display.Rect;
const Color = display.Color;

const embed = @embedFile("icon.nwi");
const metadata: eadk.MetaData = .{ .name = "Zig App", .icon = embed };
const meta = metadata.set();

// If you don't include this, the data gets optimized away, and your app won't link
comptime {
    _ = .{ meta.name, meta.icon, meta.api_level };
}

pub fn randomBelow(max: u16) u16 {
    return random.randomInRange(u16, 0, max);
}

pub export fn main() void {
    display.clearScreen(.white);

    for (0..100) |_| {
        const color: Color = @bitCast(random.randomInt(u16));

        const x = randomBelow(screen_width);
        const y = randomBelow(screen_height);

        const rect: Rect = .{
            .x = x,
            .y = y,
            .width = randomBelow(screen_width - x),
            .height = randomBelow(screen_height - y),
        };
        rect.pushColor(color);
    }

    while (true) {}
}
