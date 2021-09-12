// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "Config",
    platforms: [.iOS(.v10), .macOS(.v10_10)],
    products: [.library(name: "Config", targets: ["Config"])],
    dependencies: [],
    targets: [.target(name: "Config")]
)
