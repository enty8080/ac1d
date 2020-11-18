# ac1d (`iOS implant`)

`ac1d` is an **iOS** implant that gives an ability to manipulate device **functions**, **data** and **hardware** locally or remotely.

* **Supported iOS versions:** `iOS 10/11/12/13/14`
* **Suported CPUs:** `arm64`, `armv7`

## Building it

**Requirements:** `macOS` with installed `XCode` >= 7.3, `Theos`, `jailbroken iOS device` >= 10.0.

**handler (compile on macOS):**

```
cd ac1d; make
cp .theos/obj/debug/ac1d ./ac1d
```

**extension (compile on iOS):**

```
cd ac1d/extension; make
cp .theos/obj/debug/ac1d.dylib ./ac1d.dylib
```

## Global usage

```
Usage: ac1d <option> [arguments]

  -h, --help                                Show available options.
  -v, --version                             Show ac1d version.
  -l, --local <option> [arguments]          Execute ac1d command locally.
  -r, --remote <remote_host> <remote_port>  Execute ac1d commands over TCP.
```

## Features

* **`dial`** - Make a call from device.
* **`openurl`** - Open URL on device.
* **`openapp`** - Open device application.
* **`battery`** - Show device battery level.
* **`say`** - Say message on device.
* **`getvol`** - Show device volume level.
* **`setvol`** - Set device volume level.
* **`alert`** - Show alert on device.
* **`dhome`** - Double home button tap.
* **`home`** - Home button tap.
* **`location`** - Control device location services.
* **`state`** - Check device state.
* **`player`** - Control device media player.

## Acknowledgments

* https://iphonedevwiki.net
    * https://iphonedevwiki.net/index.php/Logos
* https://developer.apple.com/documentation
    * https://developer.apple.com/documentation/technologies?language=objc
