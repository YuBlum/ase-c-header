# Ase C Header
This extension add two buttons:
```
Save as C Header
Open from C Header
```

## How to install
1. Download the ase-c-header.aseprite-extension file
2. Open Aseprite and go to Edit > Preferences > Extensions
3. Click on Add Extension and select the downloaded file


## How to use
### Save as C Header
It'll create a c header with the following macros and variables

```C
#define <NAME>_WIDTH 
#define <NAME>_HEIGHT
#define <NAME>_FRAMES
static unsigned int <name>_data[SPRITE_FRAMES][SPRITE_WIDTH*SPRITE_HEIGHT];
```

<name> is the name of the file, so if you save it as sprite.h it'll be sprite

<NAME> is the same as <name> but all caps

Also it'll save the current sprite as <name>.aseprite in the same directory

### Open from C Header
To open the C Header it haves to have a <name>.aseprite in the same directory as the header
