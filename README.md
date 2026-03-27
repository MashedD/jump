# Quake II Jump Mod

# Changes in this fork

- Linux: fixed compilation for gcc
- Linux: added cross compilation for win32/win64

# Notes/commands

- use `store` command to save player position
- use `recall` command to restore player position
- use `replay global` to watch world's best replay of the map
- this mod requires commander head model from paid version, but it can be replaced to something
  different in `jump_mod.cfg`s `model_store`
- full list of files this mod requires to work properly:

```
.
├── jump_mod.cfg
├── models
│   ├── billboard
│   │   ├── skin.pcx
│   │   └── tris.md2
│   ├── digits
│   │   ├── skin0.pcx
│   │   ├── skin1.pcx
│   │   ├── skin2.pcx
│   │   ├── skin3.pcx
│   │   ├── skin4.pcx
│   │   ├── skin5.pcx
│   │   ├── skin6.pcx
│   │   ├── skin7.pcx
│   │   ├── skin8.pcx
│   │   ├── skin9.pcx
│   │   └── tris.md2
│   ├── dot2
│   │   ├── skin2.pcx
│   │   ├── skin.pcx
│   │   └── tris.md2
│   ├── grapple
│   │   ├── hook
│   │   │   ├── skin.pcx
│   │   │   └── tris.md2
│   │   ├── skin.pcx
│   │   └── tris.md2
│   ├── jump
│   │   ├── ball1
│   │   │   ├── skin0.pcx
│   │   │   ├── skin1.pcx
│   │   │   ├── skin2.pcx
│   │   │   └── tris.md2
│   │   ├── emptymodel
│   │   │   └── tris.md2
│   │   ├── largebo2
│   │   │   ├── tris.md2
│   │   │   └── tris.md2.bak
│   │   ├── largebox
│   │   ├── largebox3
│   │   │   └── tris.md2
│   │   ├── mediumbo2
│   │   │   ├── tris.md2
│   │   │   └── tris.md2.bak
│   │   ├── mediumbox
│   │   ├── smallbo2
│   │   │   ├── 1.md2
│   │   │   ├── skin1.pcx
│   │   │   ├── skin2.pcx
│   │   │   ├── skin3.pcx
│   │   │   ├── skin4.pcx
│   │   │   ├── temp.ms3d
│   │   │   ├── tris2.aqm
│   │   │   ├── tris.aqm
│   │   │   ├── tris.md2
│   │   │   └── tris.md2.bak
│   │   ├── smallbox
│   │   ├── smallbox3
│   │   │   ├── skin10.pcx
│   │   │   ├── skin1.pcx
│   │   │   ├── skin2.pcx
│   │   │   ├── skin3.pcx
│   │   │   ├── skin4.pcx
│   │   │   ├── skin5.pcx
│   │   │   ├── skin6.pcx
│   │   │   ├── skin7.pcx
│   │   │   ├── skin8.pcx
│   │   │   └── skin9.pcx
│   │   └── smallmodel
│   │       ├── skin1.pcx
│   │       ├── skin.pcx
│   │       └── tris.md2
│   └── monsters
│       └── commandr
│           ├── head
│           │   ├── skin.pcx
│           │   └── tris.md2
│           ├── skin.pcx
│           └── tris.md2
├── pics
│   ├── attack.pcx
│   ├── back.pcx
│   ├── duck.pcx
│   ├── forward.pcx
│   ├── jump.pcx
│   ├── left.pcx
│   └── right.pcx
├── players
│   ├── ghost
│   │   ├── gumby.md2
│   │   └── gumby.pcx
│   └── insane
│       ├── skin1_i.pcx
│       ├── skin1.pcx
│       ├── skin2_i.pcx
│       ├── skin2.pcx
│       ├── skin3_i.pcx
│       ├── skin3.pcx
│       ├── tris.md2
│       └── weapon.md2
├── server_map.cfg
└── sound
    └── numberone.wav
```

# Building

## Prerequisites

Dependencies might be missing and some are Probably excessive.
I didn't optimize this as it's time/cost not effective for me.
Best might be to use Docker for the job.

```bash
# Tested on CachyOS
sudo pacman -S cmake gcc curl

# For cross compilation
sudo pacman -S \
    mingw-w64-tools \
    mingw-w64-binutils \
    mingw-w64-crt \
    mingw-w64-gcc \
    mingw-w64-headers \
    mingw-w64-winpthreads
paru -S \
    mingw-w64-zlib \
    mingw-w64-zlib-ng \
    mingw-w64-ffmpeg \
    mingw-w64-pkg-config \
    mingw-w64-libpng \
    mingw-w64-libjpeg-turbo \
    mingw-w64-openal \
    mingw-w64-zstd

# Build zstd static version if missing in:
# /usr/x86_64-w64-mingw32/lib/libzstd.a
# /usr/i686-w64-mingw32/lib/libzstd.a
cd /tmp
git clone https://github.com/facebook/zstd.git
cd zstd/build/cmake

# For Win64
cat <<EOF>toolchain-mingw64.cmake
set(CMAKE_SYSTEM_NAME Windows)
set(CMAKE_SYSTEM_PROCESSOR x86_64)
set(CMAKE_C_COMPILER x86_64-w64-mingw32-gcc)
set(CMAKE_RC_COMPILER x86_64-w64-mingw32-windres)
set(CMAKE_FIND_ROOT_PATH /usr/x86_64-w64-mingw32)
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
EOF
rm -rf build-cmake
cmake -S . -B build-cmake -DZSTD_BUILD_SHARED=OFF -DZSTD_BUILD_STATIC=ON -DCMAKE_TOOLCHAIN_FILE=toolchain-mingw64.cmake
cmake --build build-cmake
sudo cp build-cmake/lib/libzstd.a /usr/x86_64-w64-mingw32/lib/

# For Win32
cat <<EOF>toolchain-mingw32.cmake
set(CMAKE_SYSTEM_NAME Windows)
set(CMAKE_SYSTEM_PROCESSOR x86)
set(CMAKE_C_COMPILER i686-w64-mingw32-gcc)
set(CMAKE_RC_COMPILER i686-w64-mingw32-windres)
set(CMAKE_FIND_ROOT_PATH /usr/i686-w64-mingw32)
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
EOF
rm -rf build-cmake
cmake -S . -B build-cmake -DZSTD_BUILD_SHARED=OFF -DZSTD_BUILD_STATIC=ON -DCMAKE_TOOLCHAIN_FILE=toolchain-mingw32.cmake
cmake --build build-cmake
sudo cp build-cmake/lib/libzstd.a /usr/i686-w64-mingw32/lib/
```

## Compilation

Review scripts before executing them.

```bash
./build-lin64.sh
./clean.sh
./build-win32.sh
./clean.sh
./build-win64.sh
```

# TODO

- add/change README.md
- fix compilation warnings
- fix bug: after first use of `store` and `recall` - timer shows wrong value until another `recall`

# Old part of README.md below

## What it is

Jump mod isolates the unique movement from Quake II, like strafe and double jumping, and turns it into a competition. The goal is to get the fastest time from when you spawn, until when you reach the railgun at the end of the map. In between the spawn and the railgun is a number of obstacles that you have to get over as quickly as possible.

## Compiling

The code will only compile for Linux OS (x86_64 and arm64 architectures tested) by using the provided makefile. Send us/me (Grish) a question on the q2jump [discord](https://discord.q2jump.net) if you can't get it to work.

## Global Integration

Global Integration is an enhancement to the standard Quake 2 jump mod. It allows the jump server to gather, merge, sort and display jump mod scores from multiple servers, such as .german, MZC, KEX, AUS, NOR etc.

It also provides the top 15 demo/replays in addition to the regular local top 15 replays.

The global scoreboard looks like this:

![image](https://user-images.githubusercontent.com/87460853/150706584-990d0e1f-6cb5-4fd8-b1b2-71a8aca8f6fa.png)

**Client Commands**

> **score**
  - show/hide toggle between the local and the global scoreboards
> **replay g|global** [1..15]
  - playback the requested remote demo
> **race g|global** [1..15]
  - race against a remote time
> **maptimes global**
  - prints the top 30 global times for current map (Note: known issue in v1.36global: not always accurate due to only using top 15 times per remote server. Fix pending)
> **syncglobaldata** (requires admin lvl 5+)
  - full re-fetch and processing of the files/data from each configured remote server
    **NOTE**: This command can be ran if needed, but best to run very scarcely and not while someone is timing (due to potential frame blocking).
    It can be useful on occasion when the global board appears to be missing a record/name or after enabling the "global_integration_enabled" setting.
> **poppins**
  - try it and see ;) (hint: also try with admin lvl5+)

**Configuring multiple remote servers**

You can update the following variables two different ways

1) update them in-game via the "gset" admin command (requires admin lvl 5+)
2) update them manually in the jump/jump_mod.cfg file (requires server restart)

> **global_integration_enabled** [0/1]
  - set to 0 to disable all global integration features immediately (default: 0, example: 1)
> **global_ents_sync** [0/1]
  - will download "jump/mapsent" and "jump/ent" files for respective map on each map spawn. Note: this will replace any local mapsent/ent files, best left at "0" for established servers! [default: 0, example: 1]
> **global_ents_url** [string/url]
  - base url to the server hosting the "jump/mapsent" and "jump/ent" directories/files (no trailing slash, default: "", example: "http://q2jump.net/~quake2/quake2/jump")
> **global_localhost_name** [string]
  - custom display name for your local server (default: $hostname cvar, example: "kex")
> **global_replay_max** [0..15]
  - limit the amount of global replays to download/provide (default: 3 max: 15)
> **global_threads_max** [2..15]
  - faster downloads with more threads (default: 5 max: 15)
> **global_port_[1..5]** [1024..65535]
  - jump/{portdir} where the remote maptimes.t and users.t files are stored (default: 27910)
> **global_name_[1..5]** [string]
  - label for remote server name (default: "default", example: "mzc") **Note:** leave as "default" for any unconfigured global hosts
> **global_url_[1..5]** [string/url]
  - base url to remote jump dir for jump/{portdir} and jump/jumpdemo access (no trailing slash, default: "", example: "http://q2jump.net/~quake2/quake2/jump")

## Credits

| Name                 | Credit                                                                       |
| :------------------- | :--------------------------------------------------------------------------- |
| Wireplay Programmers | SadButTrue, ManicMiner, wootwoot, LilRedtheJumper                            |
| German Programmers   | ace, draxi, slippery, Mako                                                   |
| Various Additions    | Fish, quadz, maq, SumFuka, Killerbee, Doyoon Kim, Hannibal, DeathJump, Grish |
| Global Integration   | Grish                                                                        |
