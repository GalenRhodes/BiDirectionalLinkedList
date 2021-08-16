// swift-tools-version:5.4
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

//@f:0
let package = Package(
    name: "BiDirectionalLinkedList",
    platforms: [ .macOS(.v10_15), .tvOS(.v13), .iOS(.v13), .watchOS(.v6), ],
    products: [ .library(name: "BiDirectionalLinkedList", targets: [ "BiDirectionalLinkedList", ]), ],
    dependencies: [],
    targets: [
        .target(name: "BiDirectionalLinkedList", dependencies: [], exclude: [ "Info.plist", ]),
        .testTarget(name: "BiDirectionalLinkedListTests", dependencies: [ "BiDirectionalLinkedList", ], exclude: [ "Info.plist", ]),
    ]
)
//@f:1
