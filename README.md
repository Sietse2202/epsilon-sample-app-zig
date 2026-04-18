<!-- README taken and modified from https://github.com/numworks/epsilon-sample-app-rust/blob/master/README.md?plain=1 -->

# Sample Zig app for Epsilon

This is a sample [Zig](https://ziglang.org/) app to use on a [NumWorks calculator](https://www.numworks.com).
Yes, you can now use Zig to write code for a graphing calculator!

```zig
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
```

## Build the app

To build this sample app, you will need to install an embedded ARM zig compiler as well as
[bun](https://bun.sh/). The SDK for Epsilon apps is shipped as an npm module called
[nwlink](https://www.npmjs.com/package/nwlink) that will automatically be installed at compile time.

```shell
brew install zigup bun # Or equivalent on your OS
zigup fetch "0.16.0"
zig build nwa
```

## Run the app

The app is sent over to the calculator using the DFU protocol over USB.

```shell
# Now connect your NumWorks calculator to your computer using the USB cable
zig build install-nwa
```

## Notes

The NumWorks calculator runs [Epsilon](http://github.com/numworks/epsilon), a tailor-made calculator operating system.
Starting from version 16, Epsilon allows installing custom binary apps.
To run this sample app, make sure your calculator is up-to-date by visiting https://my.numworks.com.

The interface that an app can use to interact with the OS is essentially a short list of system calls.
Feel free to browse the [code of Epsilon](http://github.com/numworks/epsilon) itself if you want to get an in-depth look.

Please note that any custom app is removed when resetting the calculator.

## License

This sample app is distributed under the terms of the UNLICENSE. See [LICENSE](LICENSE) for details.

## Trademarks

NumWorks is a registered trademark.
