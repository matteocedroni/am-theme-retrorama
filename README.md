# Description

Reshaped Retrorama theme for Attract-Mode with 4:3 format.

<p align="center">
  <img src="https://github.com/matteocedroni/am-theme-retrorama/blob/master/example/layout-full-01.jpg">
  <img src="https://github.com/matteocedroni/am-theme-retrorama/blob/master/example/layout-system-area.jpg">
</p>

#### Currently supported game systems
* Arcade
* Nintendo  NES, SNES, N64, GameCube
* Sega Master System, Megadrive, 32X, Saturn
* Sony Playstation 1
* NEC TurboGrafx 16

I'll add more converted game system background asap 

### Prerequisites
* [Shuffle Plugin](https://github.com/keilmillerjr/shuffle-module) installed;

## Features
* 4:3 reshaped/rearranged layout, no image stretching;
* Game list area with flayers support;
* System image/video area and simple specs recap;
* Game snap area;
* Game description area;
* Splash screen on cycle through systems;

## Usage
Just copy theme folder into Attract-Mode layouts folder.

## Configuration
Work in progress...

#### System background
Current system background is determined by matching emulator system identifier. Default behaviour can be overridden by `system` parameter.

#### System image/video area
Dedicated area for system specific image or video (es. original advertise).
`system.png` (provided with layout) or `system.mp4` can be used, based on  `systemArtMode` parameter. Default `image`.

#### System specs recap
Very simple recap of tech specs are provided for each system. The informations are stored in the `system-specs.txt` file, easily editable.