# InstantSyntax

509.1.1 SwiftSyntax binary frameworks (This package is in beta!)

This is a Swift Package containg precompiled binary frameworks of the main 
modules of the [swift-syntax](https://github.com/apple/swift-syntax) project.
It is hoped this can be packaged up and used in place of the swit-syntax
source repo by Swift Macro projects.

These are a bit involved to build. First, you need to use an old Xcode 13 
version of "swift package generate-xcodeproj" to generate a .xcodeproj
for the swift-syntax project. Then, you can generate and package 
the binary frameworks using xcodebuild in the normal way.

To use, build your project (and view any previews you would like 
to view), then clone this repo, renaming the InstantSyntax directory 
and gunzip the compressed swift-syntax/509.1.1/libSwiftSyntax.a.gz.

% git clone https://github.com/johnno1962/InstantSyntax swift-syntax
% gunzip swift-syntax/509.1.1/libSwiftSyntax.a.gz

Now, drag this `swift-syntax` clone onto the top level of your project 
that uses macros. This binary distribution should then take the place 
of the swift-syntax source repo in the side bar in all macro packages. 
At the moment, if you perform a "Clean Build Folder" you'll need to 
un-add the swift-syntax override, rebuild then re-add it alas.
