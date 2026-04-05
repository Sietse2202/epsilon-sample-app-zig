const eadk = @import("eadk");

const random = eadk.random;
const display = eadk.display;
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

pub fn randomX() u16 {
    return random.randomInRange(u16, 0, display.screen_width);
}

pub fn randomY() u16 {
    return random.randomInRange(u16, 0, display.screen_height);
}

pub export fn main() void {
    display.clearScreen(.white);

    for (0..100) |_| {
        const color: Color = @bitCast(random.randomInt(u16));
        const rect: Rect = .{ .x = randomX(), .y = randomY(), .width = randomX(), .height = randomY() };
        rect.pushColor(color);
    }

    while (true) {}
}
