# ac1d (`iOS implant`)

`ac1d` is an **iOS** implant that gives an ability to manipulate device **functions**, **data** and **hardware**.

* **Supported iOS versions:** `iOS 9/10/11/12/13/14`
* **Suported CPUs:** `arm64`, `armv7`

## Global usage

> ./ac1d \<option\>

## Features

### No installation needed

* **`openurl`** - Open URL on device.
* **`openapp`** - Open device application.

### Installation needed

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

## Installation

```shell
cp extension/ac1d.dylib /Library/MobileSubstrate/DynamicLibraries
cp extension/ac1d.plist /Library/MobileSubstrate/DynamicLibraries
killall SpringBoard
```

## Tests

* Tested on **iOS 13.3.3** (`jailbroken`, `Checkra1n`)
* Tested on **iOS 10.3.3** (`jailbroken`, `H3lix`)
