// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AppTools",
    platforms: [
        .macOS(.v12),
        .iOS(.v14),
    ],
    products: [
        .library(
            name: "AppToolsGraph",
            targets: ["AppToolsGraph"]),
        .library(
            name: "AppToolsText",
            targets: ["AppToolsText"]),
        .library(
            name: "AppToolsData",
            targets: ["AppToolsData"]),
        .library(
            name: "AppToolsCoreData",
            targets: ["AppToolsCoreData"]),
        .library(
            name: "AppToolsCrossPlatform",
            targets: ["AppToolsCrossPlatform"]),
        .library(
            name: "AppToolsUserPreference",
            targets: ["AppToolsUserPreference"]),
        .library(
            name: "AppToolsUbiquitousCoreStorage",
            targets: ["AppToolsUbiquitousCoreStorage"]),
        .library(
            name: "AppToolsSQLite",
            targets: ["AppToolsSQLite"]),
        .library(
            name: "AppToolsPrimitiveUI",
            targets: ["AppToolsPrimitiveUI"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "AppToolsGraph",
            dependencies: ["AppToolsData"]),
        .testTarget(
            name: "GraphTests",
            dependencies: ["AppToolsGraph"]),
        
        .target(
            name: "AppToolsText",
            dependencies: []),
        .testTarget(
            name: "TextTests",
            dependencies: ["AppToolsText"]),
        
        .target(
            name: "AppToolsData",
            dependencies: []),
        .testTarget(
            name: "DataTests",
            dependencies: ["AppToolsData"]),
        
        .target(
            name: "AppToolsUserPreference",
            dependencies: ["AppToolsData"]),
        .testTarget(
            name: "UserPreferenceTests",
            dependencies: ["AppToolsUserPreference"]),
        
        .target(
            name: "AppToolsUbiquitousCoreStorage",
            dependencies: ["AppToolsData", "AppToolsCoreData"]),
        .testTarget(
            name: "UbiquitousCoreStorageTests",
            dependencies: ["AppToolsUbiquitousCoreStorage"]),
        
        .target(
            name: "AppToolsSQLite",
            dependencies: []),
        .testTarget(
            name: "SQLiteTests",
            dependencies: ["AppToolsSQLite"]),
        
        .target(
            name: "AppToolsCoreData",
            dependencies: ["AppToolsData"]),
        
        .target(
            name: "AppToolsCrossPlatform",
            dependencies: []),
        
        .target(
            name: "AppToolsPrimitiveUI",
            dependencies: ["AppToolsData"]),
        .testTarget(
            name: "PrimitiveUITests",
            dependencies: [
                "AppToolsPrimitiveUI",
                "AppToolsData",
            ]),
    ]
)
