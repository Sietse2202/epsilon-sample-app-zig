<!-- README taken and modified from https://github.com/numworks/epsilon-sample-app-rust/blob/master/README.md?plain=1 -->

# Sample Zig app for Epsilon

This is a sample [Zig](https://ziglang.org/) app to use on a [NumWorks calculator](https://www.numworks.com).
Yes, you can now use Zig to write code for a graphing calculator!

```zig
pub export fn main() void {
    Rect.FULL_SCREEN.pushColor(Color.WHITE);

    Point.CENTER.drawString("Hello from Zig!", .{
        .fg = Color.BLACK,
        .bg = Color.WHITE,
        .centered = true
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
```

## Build the app

To build this sample app, you will need to install an embedded ARM zig compiler as well as
[Node.js](https://nodejs.org/en/). The SDK for Epsilon apps is shipped as an npm module called
[nwlink](https://www.npmjs.com/package/nwlink) that will automatically be installed at compile time.

```shell
brew install zigup node # Or equivalent on your OS
zigup fetch "0.14.1"
zig build
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

NumWorks and Zig are a registered trademarks.