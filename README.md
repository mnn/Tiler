Tiler
=====

A script creating bigger images by tiling one image to fit into given size. It supports a batch mode and fade-out borders.

Usage
-----
```
Usage: ./tiler.sh <width> <height> [--fadeout|-f] -- <files>
e.g. ./tiler.sh 160x160 -f -- file1.png file2.png
```

Example
--------
```
./tiler.sh 128 64 -f -- vetrik_1.png
```

### Original
![original](https://github.com/mnn/Tiler/raw/master/example/vetrik_1.png)

### Tiled
![tiled](https://github.com/mnn/Tiler/raw/master/example/vetrik_1_tiled.png)

### Tiled with border
![tiled_bordered](https://github.com/mnn/Tiler/raw/master/example/vetrik_1_tile_with_border.png)

Dependencies
------------
This script requires ImageMagick, bash and readlink.

Notes
-----
Some viewers don't show properly alpha channel - e.g. XnView. Script is tested with ImageMagick version 6.8.9, other version may have different behaviour (some previous versions did process alpha channel differently).
