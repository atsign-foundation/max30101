## max30101
A Dart package (developed for use on a Raspberry Pi 4) which interfaces via I2C with the
[Max30101](https://www.maximintegrated.com/en/products/interface/signal-integrity/MAX30101.html)
sensor and produces illustrative heart rate and O2 saturation readings.

* Primarily based on Raivis Strogonovs' excellent
[C++ library](https://github.com/xcoder123/MAX30100) which implements heart rate and O2
saturation readings for the Max30100 sensor. (See also his superb accompanying
[tutorial](https://morf.lv/implementing-pulse-oximeter-using-max30100) ). This package is a
pretty faithful port to Dart of that C++ code, and also includes the various adjustments
(registers, settings, etc.) required to make it work with the Max30101 sensor.
* The package's approach to register interaction was inspired by Philip Howard's
[Python library](https://github.com/pimoroni/max30105-python) which implements heart rate
readings for the Max30105 sensor
* The essential ingredient of I2C support is provided by the https://pub.dev/packages/dart_periphery
package

## Important!
This code is for proof-of-concept / demonstration purposes only. It should not be used for
any other purpose, including medical diagnosis, as the basis for a real smoke or fire detector,
or in life-critical situations.

## Features

See https://github.com/atsign-foundation/mwc_demo/README.md

## Getting started

See https://github.com/atsign-foundation/mwc_demo/README.md

## Usage

See https://github.com/atsign-foundation/mwc_demo/README.md

## Additional information

