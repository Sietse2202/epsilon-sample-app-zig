const eadk = @import("eadk");

const Point = eadk.display.Point;
const Rect = eadk.display.Rect;
const Color = eadk.display.Color;

const embed = @embedFile("icon.nwi");
const AppMetadata = eadk.setMetadata(embed.len, "Zig App", 0, embed.*);

// If you don't include this, the data gets optimized away, and your app won't link
comptime {
    _ = AppMetadata.EADK_APP_NAME;
    _ = AppMetadata.EADK_APP_API_LEVEL;
    _ = AppMetadata.EADK_APP_ICON;
}

pub export fn main() void {
    Rect.FULL_SCREEN.pushColor(Color.WHITE);

    Point.CENTER.drawString("Hello from Zig!", .{
        .fg = Color.BLACK,
        .bg = Color.WHITE,
        .centered = true,
        .large = true,
    });

    while (true) {
        var scan = eadk.keyboard.scan();
        if (scan.isKeyDown(eadk.keyboard.Key.home)) {
            scan = eadk.keyboard.scan();
            while (scan.isKeyDown(eadk.keyboard.Key.home)) {
                scan = eadk.keyboard.scan();
            }

            eadk.timing.sleepMillis(80);
            return;
        }
    }
}
