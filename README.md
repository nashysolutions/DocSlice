# DocSlice

![](https://img.shields.io/badge/platform-macOS%2BiOS%2Blinux-blue)
![](https://img.shields.io/badge/swift-5.3-blue)

A command line tool for separating the pages of a PDF file into multiple smaller files. The underlying API is also available, should you want to include it in your development projects.

## Usage
```
$ docslice ~/Desktop/Filename.pdf -s 2
```
### Man Page

```
USAGE: docslice [--output <output>] [--slices <slices>] <file>

ARGUMENTS:
  <file>                  A local PDF file. 

OPTIONS:
  -o, --output <output>   The destination folder for output. (default: current dir))
  -s, --slices <slices>   The number of parts the document should be evenly split into. (default: 1)
  -h, --help              Show help information.
```
### Slice API
```swift
import Files // github.com:JohnSundell/Files

let output = Folder.home
let file = File(path: "~/myfile.pdf")
let slice = Slice(file: file, slices: 2, output: output)
try slice.run()
```
## Installation
Install [Swift](https://swift.org/getting-started/) (at least version 5.3) then run the following commands.
```
$ git clone https://github.com/Nash-Engineering/DocSlice.git
$ cd DocSlice
$ swift build -c release
$ cd .build/release
$ cp -f docslice /usr/local/bin/docslice
```
If you have any issues with unix directories [this article](https://superuser.com/questions/717663/permission-denied-when-trying-to-cd-usr-local-bin-from-terminal) might be helpful.

## Adding underlying `Slice` API as a Dependency

```swift
let package = Package(
    platforms: [
        .iOS(.v13), 
        .macOS(.v10_13)
    ]
    dependencies: [
        .package(name: "DocSlice", url: "https://github.com/Nash-Engineering/DocSlice.git", .upToNextMinor(from: "1.0.0"))
    ],
    targets: [
        .target(
            name: "MyTool", 
            dependencies: [
                .product(name: "Slice", package: "DocSlice")
            ])
    ]
)
```
