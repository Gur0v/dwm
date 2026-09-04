Gur0v's dwm
============

This is my build of dwm 6.8. It started from upstream dwm and contains a few
patches which I changed quite a bit to fit my setup. It is not an official
suckless release.

Upstream: https://dwm.suckless.org/
Source:   https://github.com/Gur0v/dwm


Changes
-------

I use sxhkd for program shortcuts, so the dmenu and terminal commands, their
key bindings and dwm's spawn code are gone. dwm still handles its own window
management keys. The same keys should not be grabbed by sxhkd.

Each tag keeps its own layout, master size, master count and alternate layout.
The bar position is shared. This started from pertag_without_bar, but the code
has been updated and changed for this tree.

New clients are attached after the selected tiled client instead of replacing
the master. The fallback placement follows matching tags. This is based on
attachasideandbelow and has been changed for this tree.

Mod+Shift+j and Mod+Shift+k move the selected tiled client through the stack.
Floating and hidden clients are skipped. The empty-tag case is also handled.
This is based on movestack and has been changed for this tree.

New floating windows are centered on their monitor. Rules, dialogs, transient
windows and fixed-size windows are handled after their final floating state is
known. Oversized windows are kept at the monitor origin instead of being moved
past its top or left edge. This is based on alwayscenter and has been changed
for this tree.

Fullscreen clients keep focus when lockfullscreen is enabled. They cannot be
moved, resized or reconfigured while fullscreen. Their old geometry is saved
separately and restored on exit. Fullscreen clients also follow monitor size
changes correctly.

Mouse move and resize events are limited to the configured refresh rate. The
default is 180 Hz. There are also checks for empty selections, monitor removal,
failed Xinerama queries, modifier map failures and X11 errors. Monitor removal
keeps the clients and moves them onto the remaining monitor.

The default font is JetBrains Mono NL at size 10. The upstream example rules
are removed. Mod is Super instead of Alt. Mod+o lowers the master count, Mod+q
closes a client and Mod+Shift+q quits dwm.


Code and build
--------------

I also went through the core code so it builds cleanly with pedantic and extra
warnings enabled. Unused callback arguments are marked, signed and unsigned
values are handled more carefully, bit masks use unsigned constants,
allocation sizes use size_t, layout symbols use bounded formatting and Xlib
return values are checked where needed.

The X11 error handlers no longer shadow the global display pointer. Num Lock
lookup handles a failed modifier map, and fullscreen configure requests are
rejected before they can change saved geometry. Event dispatch also checks the
X event type before indexing the handler table. SIGCHLD handling stays in place
to clean up any child processes inherited from the X session.

config.mk uses clang and lld. The warning flags are:

	-std=c99 -pedantic -Wall -Wextra -Wshadow -Wformat=2 -Wundef

Deprecated XKeycodeToKeysym use was replaced with XkbKeycodeToKeysym rather
than hiding the compiler warning.

The optimized and hardened build uses:

	-O2 -flto=full -fno-plt
	-fPIE -pie
	-D_FORTIFY_SOURCE=3
	-fstack-protector-strong -fstack-clash-protection
	-ftrivial-auto-var-init=zero
	-ffunction-sections -fdata-sections -Wl,--gc-sections
	-Wl,--icf=safe -Wl,--as-needed
	-Wl,-z,relro -Wl,-z,now -Wl,-z,noexecstack -Wl,-z,separate-code

The result is a PIE binary with full RELRO and a non-executable stack.


Patches
-------

These are the patches used as starting points. They are not applied unchanged.

attachasideandbelow 6.4
https://dwm.suckless.org/patches/attachasideandbelow/dwm-attachasideandbelow-6.4.diff

pertag_without_bar 6.1
https://dwm.suckless.org/patches/pertag/dwm-6.1-pertag_without_bar.diff

movestack 20211115
https://dwm.suckless.org/patches/movestack/dwm-movestack-20211115-a786211.diff

alwayscenter 20200625
https://dwm.suckless.org/patches/alwayscenter/dwm-alwayscenter-20200625-f04cac6.diff

Patch authors and contributors are listed on the corresponding suckless patch
pages. See those pages for the original descriptions and attribution.


Requirements
------------

Xlib, Xinerama, Fontconfig and Xft development files are required. The default
build also expects clang, lld and make. Install JetBrains Mono NL or change the
font in config.def.h.


Build
-----

Edit config.mk if the include paths, compiler or installation prefix differ on
your system. The default prefix is /usr/local.

	make clean
	make
	sudo make install

Only installation may need root privileges. Do not run dwm as root.

For startx, add this to ~/.xinitrc:

	exec dwm


Configuration
-------------

dwm is configured in C and rebuilt. Edit config.def.h, remove an old config.h
and compile again:

	rm -f config.h
	make clean
	make
	sudo make install


Keys
----

Mod is the Super key by default.

	Mod+j / Mod+k              focus next / previous client
	Mod+Shift+j / Mod+Shift+k  move selected client down / up
	Mod+i / Mod+o              increase / decrease master count
	Mod+h / Mod+l              shrink / grow master area
	Mod+Return                 move selected client to master
	Mod+q                      close selected client
	Mod+Space                  switch layout
	Mod+Shift+Space            toggle floating
	Mod+Shift+q                quit dwm

The normal dwm tag, monitor, mouse and layout bindings are still present.
