# InstantSyntax

509.1.1 SwiftSyntax binary frameworks (This package is in beta!)

This is a Swift Package containg precompiled binary frameworks of the main 
modules of the [swift-syntax](https://github.com/apple/swift-syntax) project.
It is hoped this can be packaged up and used in place of the swit-syntax
source repo by Swift Macro projects to avoid [this problem people have
 experienced](https://forums.swift.org/t/compilation-extremely-slow-since-macros-adoption/67921/59). 
 It operates by overriding the
swift-syntax source repo pulled in by your macros by dragging it 
onto your project as you would to work on a Swift package as is
[documented here](https://developer.apple.com/documentation/xcode/editing-a-package-dependency-as-a-local-package).

These are a bit involved to build. First, you need to use an old Xcode 13 
version of "swift package generate-xcodeproj" to generate a .xcodeproj
for the swift-syntax project. Then, you can generate and package 
the binary frameworks using xcodebuild in the normal way.

To use, build your project (and view any previews you would like 
to view), then clone this repo, renaming the InstantSyntax directory 
to swift-syntax and unpack the compressed archives using a script.

```
git clone https://github.com/johnno1962/InstantSyntax swift-syntax
./swift-syntax/509.1.1/unpack.sh
```

Now, drag this `swift-syntax` clone onto the top level of your project 
that uses macros. This binary distribution should then take the place 
of the swift-syntax source repo in the side bar in all macro packages. 
At the moment, if you perform a "Clean Build Folder" you'll need to 
un-add the swift-syntax override, rebuild your project then re-add it.

If you change platform, for example, from simulator to device the same 
applies. Xcode Previews also count as another platform. You need to 
have used previewing for a platform before adding the binary clone 
for them to work when the binary override is in place. Switching
Xcode versions will also require you to remove, build and re-add
the override.

While this should be resoved now, if you see an error along the 
lines of `External macro implementation type 'XMacros.XMacro' 
could not be found for macro 'color'` in the source editor (even
when your project builds) this seems to be because some files are 
missing from DerivedData that the binary package override is not 
providing in the right place. You will need to remove the binary
override, build clean then add it again.

If you still experience problems involving "duplicate copy commands
being generated" when you try to build, this is beacuse the repo's
Package.swift seems to tickle some sort of bug in the build system
related to binary frameworks. This has already been fixed and working 
its way through the Xcode release pipeline so in the meantime you 
should better off downloading, installing and switching to one of 
the recent 5.10 (or possibly 5.9) development branch toolchains from
[https://www.swift.org/download/](https://www.swift.org/download/). 
For example: 
[this package](https://download.swift.org/swift-5.10-branch/xcode/swift-5.10-DEVELOPMENT-SNAPSHOT-2024-02-02-a/swift-5.10-DEVELOPMENT-SNAPSHOT-2024-02-02-a-osx.pkg).
After you switch toolchains, close and re-open your Xcode project
workspace window to be sure any in-memory build plans are not cached.
Once you're up and running and the build has been "planned" you 
may be able to switch back to Xcode's default toolchain. If you 
continue using the toolchain you'll notice Previews break with 
an error "'ld' not found". This is because the linker is not 
distributed with the toolchain. You should just need to run 
a variation on the following command to fix this:

```
ln -s /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/ld* ~/Library/Developer/Toolchains/swift-5.10-DEVELOPMENT-SNAPSHOT-2024-02-02-a.xctoolchain/usr/bin
```
