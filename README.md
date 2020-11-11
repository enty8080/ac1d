# ac1d (`iOS implant`)

`ac1d` is an **iOS** implant that gives an ability to manipulate device **functions**, **data** and **hardware**.

<table><tr><th>
⚠️ Do not use it on your iPhone becuase it can brick your device! ⚠️
</th></tr></table>

## Global usage

> ./ac1d \<option\>

## Features

### No installation needed

* **`battery`** - Show device battery level.
* **`locate`** - Show device location.
* **`getvol`** - Show device volume level.
* **`openurl`** - Open URL on device.
* **`openapp`** - Open device application.
* **`sysinfo`** - Should return string of device.
* **`player`** - Control device media player.

### Installation needed

* **`dhome`** - Double home button tap.
* **`home`** - Home button tap.
* **`locoff`** - Turn location services off.
* **`locon`** - Turn location services on.
* **`state`** - Check device state.

## Installation

```shell
cp extension/ac1d.dylib /Library/MobileSubstrate/DynamicLibraries
cp extension/ac1d.plist /Library/MobileSubstrate/DynamicLibraries
killall SpringBoard
```

## Tests

* Tested on **iOS 13.3.3** (`jailbroken`, `Checkra1n`)
* Tested on **iOS 10.3.3** (`jailbroken`, `H3lix`)
