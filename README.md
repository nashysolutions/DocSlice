# DocSlice

![](https://img.shields.io/badge/platform-macOS%2BiOS%2Blinux-blue)
![](https://img.shields.io/badge/swift-5.3-blue)
[![Build Status](https://app.bitrise.io/app/56aab2adf6b1bc79/status.svg?token=1mBREr1_-AwQJkJhfN-5Fw)](https://app.bitrise.io/app/56aab2adf6b1bc79)

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
let file = try File(path: "~/myfile.pdf")
let slice = Slice(file: file, slices: 2, output: output)
try slice.run()
```
## Installation

Install [Swift](https://swift.org/getting-started/).

### DocSlice Command Line Tool

```
$ git clone https://github.com/nashysolutions/DocSlice.git
$ cd DocSlice
$ swift build -c release
$ cd .build/release
$ cp -f docslice /usr/local/bin/docslice
```
If you have any issues with unix directories [this article](https://superuser.com/questions/717663/permission-denied-when-trying-to-cd-usr-local-bin-from-terminal) might be helpful.

## Slice Library

```swift
let package = Package(
    name: "MyTool",
    products: [
        .executable(name: "tool", targets: ["MyTool"]),
    ],
    dependencies: [
        .package(name: "DocSlice", url: "https://github.com/nashysolutions/DocSlice.git", .upToNextMinor(from: "1.0.0"))
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
[Swift 5.3](https://swift.org/blog/swift-5-3-released/) only knows how to skip dependencies not used by *any* product, which in this package is none. This is a limitation at the moment with the Swift package manager.

As a result, if you mark your target as depending on the `Slice` product, Swift will download all the source for all the dependencies in this package. 

Further, the entire `DocSlice` package will be downloaded so that files such as the README and other such documentation is available.

That being said, only the source required for `Slice` will be compiled.