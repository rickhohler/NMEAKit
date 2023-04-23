# Welcome to NMEAKit

## NMEA 0183

NMEA 0183 is a combined electrical and data specification for communication between marine electronics such as echo sounder, sonars, anemometer, gyrocompass, autopilot, GPS receivers and many other types of instruments. It has been defined and is controlled by the National Marine Electronics Association (NMEA).

https://en.wikipedia.org/wiki/NMEA_0183

## NMEA Sentence Format

NMEAKit supports the GP (GPS) "Talker ID" at this moment.

NMEAKit supports the following "sentences" in the NMEA message:

| Sentence  |  Description                                      |
| --------- |:-------------------------------------------------:|
| GPGGA     |  Global Positioning System Fixed Data             |
| GPGLL     |  Geographic Position-- Latitude and Longitude     |
| GPGSA     |  GNSS DOP and active satellites                   |
| GPGSV     |  GNSS satellites in view                          |
| GPMSS     |  MSK Receiver Signal                              |
| GPRMC     |  Time, date, position, course and speed data      |
| GPVTG     |  Course Over Ground and Ground Speed              |
| GPZDA     |  SiRF Timing Message                              |

One example, the sentence for Global Positioning System Fixed Data for GPS should be "$GPGGA".

### Examples

```
$GPGGA,092750.000,5321.6802,N,00630.3372,W,1,8,1.03,61.7,M,55.2,M,,*76
$GPGSA,A,3,10,07,05,02,29,04,08,13,,,,,1.72,1.03,1.38*0A
```

## Getting Started

NMEAKit uses SwiftPM as its build tool, so we recommend using that as well. If you want to depend on NMEAKit in your own project, it's as simple as adding a dependencies clause to your Package.swift:

```swift
dependencies: [
    .package(url: "https://github.com/rickhohler/NMEAKit.git", from: "0.0.6")
]
```

## Basic Architecture

The basic building blocks of NMEAKit are the following types of objects:

NMEAMessage, a struct, provided by NMEAKit

## Parse Statements

Parse a list of NMEA statements:

```swift
    let sample =
        """
        $GPZDA,164129,06,07,2019,+06,00*67
        $GPGGA,164129,3851.8676,N,09443.1721,W,1,,,,M,,,,*05
        $GPRMC,164129,A,3851.8676,N,09443.1721,W,,,060719,,,A*6D
        $GPGGA,164144,3851.8600,N,09443.1694,W,1,,,,M,,,,*00
        $GPRMC,164144,A,3851.8600,N,09443.1694,W,,,060719,,,A*68
        """
    let lines = sample.components(separatedBy: .newlines)
    let statements = NMEAKit.parseStatements(lines: lines)
    for data in statements.nmeaData {
        print("data: \(data)")
    }
```

## StatementError

```swift
enum StatementError: Error {
    case unsupportedMessageType
}
```
