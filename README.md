# Qtractor

This is a graphical settings app for tractor which is a package uses Python stem library to provide a connection through the onion proxy and sets up proxy in user session, so you don't have to mess up with TOR on your system anymore.

![traqtorPoster](/uploads/b06f001c6bf186f15da12fdd62c2749e/traqtorPoster.png)

## Installation


In Debian-based distros, make sure that you have `software-properties-common` package installed an then do as following:

```
sudo add-apt-repository ppa:tractor-team/tractor
sudo apt update
sudo apt install traqtor
```

## Compile from source

### Requirements

pkg-config

libglib2.0-dev

Qt -> minimal version 5.11.2

### Compilation

**On qt-creator:**

Open project (.pro) on qt-creator.

use Qt5.11.2 or higher version for build

then click run.

**On command line:**

qmake Qtractor.pro

make
