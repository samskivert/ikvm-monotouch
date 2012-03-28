IKVM MonoTouch
==============

This code is based on release 0.46.0.1 of [IKVM] and is modified to allow operation with
[MonoTouch]. The two big challenges in supporting MonoTouch are:

 * MonoTouch uses AOT compilation to deploy to iOS, and thus cannot support dynamic code
   generation. IKVM uses dynamic code generation extensively to support fast reflection.

 * MonoTouch only provides the Silverlight runtime profile, which lacks a substantial number of the
   features of the desktop profile, on which IKVM relies.

These challenges have largely been overcome:

 * Reflection is supported through standard CLR reflection (which is slower than code generation,
   but at least it works).

 * The Silverlight profile is accommodated by aggressive pruning of the JDK with which IKVM
   operates. This means that the vast majority of the "enterprisey" features of OpenJDK are not
   available via IKVM MonoTouch.

Building
--------

Building ikvm-monotouch is currently somewhat challenging because the stock Nant distribution does
not support MonoTouch's "silverlight" profile out of the box. The NAnt installation that comes with
Mono supports a "moonlight" profile, which I hacked to point to MonoTouch, and got everything to
build. I'll eventually recreate the steps required to do that hackery in this README, but right now
I can't remember them.

mzechner: The following steps will make NAnt use MonoTouch as the toolchain for the moonlight-2.0
profile:

1) Back up  /Library/Framworks/Mono.framework/Home/shared/NAnt/bin/NAnt.exe.config
2) Replace the NAnt.exe.config in the above directory with the one provided here.
3) Create a symlink: ln -s /Developer/MonoTouch/usr/lib/mono/2.1 /Library/Frameworks/Mono.framework/Versions/2.10.8/lib/mono/2.1

In addition to this project, you need to check out the [ikvm-openjdk] repository in the same
directory that contains the `ikvm-monotouch` checkout. The IKVM build will use the Java source in
the `ikvm-openjdk` directory during its build.

Once you have NAnt properly hacked and `ikvm-openjdk` checked out. You can build things like so:

    nant -t:moonlight-2.0

This will generate all of the IKVM dlls and exes in the `ikvm-monotouch/bin` directory. This
version of IKVM can then be used in the normal manner to convert Java bytecode to a dll that can be
included in a MonoTouch project.

It is not necessary to use this custom project to convert C# dlls to Java stub classes (via
`ikvmstub.exe`), but you can use it, and save yourself the trouble of installing a standard IKVM
distribution.

Limitations
-----------

There are numerous limitations, too many to enumerate. However, this project is successfully
enabling the [PlayN] game development library to convert Java game projects into iOS binaries.

One known limitation that can probably be overcome is the lack of `java.net` support. The
aggressive pruning of the OpenJDK to remove all of the enterprise functionality that could not be
supported on Silverlight resulted in `java.net` being cut out due non-trivial internal dependencies
on JNDI and from there into a bunch of enterprise crap.

I strongly suspect that the JNDI and other enterprise crap can be surgically removed, leaving a
functional `java.net` which supports basic DNS and TCP/UDP. However, that will take more time and
effort than I have thus far been able to muster.

Distribution
------------

See [LICENSE] for license information on IKVM.

Contact
-------

Questions, comments, and suchlike can be directed to the
[Three Rings Libraries](http://groups.google.com/group/ooo-libs) Google Group.

[IKVM]: http://www.ikvm.net/
[MonoTouch]: http://xamarin.com/monotouch/
[ikvm-openjdk]: https://github.com/samskivert/ikvm-openjdk
[PlayN]: http://code.google.com/p/playn/
[LICENSE]: https://raw.github.com/samskivert/ikvm-monotouch/master/LICENSE
