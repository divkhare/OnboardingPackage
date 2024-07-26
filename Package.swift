// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "OnboardingPackage",
    platforms: [
        .iOS(.v16),
    ],
    products: [
        .library(
            name: "OnboardingPackage",
            targets: ["OnboardingPackage"]),
    ],
    targets: [
        .target(
            name: "OnboardingPackage",
            resources: [
                .process("Resources")
            ]
        )
    ]
)
