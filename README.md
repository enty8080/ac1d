# ac1d (`iOS implant`)

`ac1d` is an **iOS** implant that gives an ability to manipulate device **functions**, **data** and **hardware**.

* **Supported iOS versions:** `iOS 10/11/12/13/14`
* **Suported CPUs:** `arm64`, `armv7`

## Building it

**Requirements:** `macOS` with installed `XCode` >= 7.3, `Theos`, `jailbroken iOS device` >= 9.0.

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

> ./ac1d \<option\> \[arguments\]

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
