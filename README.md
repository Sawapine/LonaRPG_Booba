# LonaRPG Booba Mod

![preview2](https://github.com/Sawapine/LonaRPG_Booba/assets/106891482/5b020f92-2d0d-4f4e-8fd2-5fca3bf00343)

A mod for the game LonaRPG, adding the ability to increase the size of the breasts with the help of genetic modification in the store at Elise.

Latest version: R2.5

## Requirements

Minimum required game version: `0.8.7.x` (R2.4) / `0.8.9.x` (R2.5)<br/>
[UltraModManager](https://mega.nz/folder/FzdxST7a#SRSft4Jj27Tu_jL5O_3RXQ) (since R2.4)

## Changelog

<details>
<summary>Changelog</summary>

- R1.5: Added support (partial) for Dancer outfit.
  
- R1.8:

Fixed some color issues and adjusted the wound sprites.

Added support for dark nipple areolas and made other minor changes.
- R2: corrected the sprites of `AdvMid` to ensure proper display when the color palette is modified.
- R2.2: minor cosmetic changes+fixes to the default clothing and body.
- added `PaletteMover.rb` script that copies the necessary .json files with palette parameter settings to PaletteChanger folder, enabling color changes to affect the displayed belly as shown above.
It also generates corresponding .bat file, which can be used to quickly delete these .json files if needed.
- R2.3: Added support for `WarBoss Rapeloop` sprites.
- R2.3.1-pre1: Quick Fix sprite coordinates after 0.8.7.0 update.
- R2.3.1: Added support (partial) for `pose` outfits.

- R2.4:
  
  Added support (partial) for `Footman outfit`.
  
  Provided deeper compatibility for UltraModManager (UMM).
  
  Made some tweaks to the code related to PaletteChanger.

  Added experimental items to Gynecologist.

- R2.5

Redesigned the 'image delivery' method to be more immersive. Lona's breasts can now be enlarged after certain conditions are met.

Expanded the functionality of Elise's experimental items.

Starting with this version the mod requires `UltraModManager` (UMM) for the scripts to work correctly.

`PaletteChanger` function is still unstable, but changes to the skin color of races and the sea witch are already working. Potential bugs are expected.

!!! Other mods that change clothing colors, skin, etc., now require additional patches for compatibility.
Use 100_DESU_Clothes_BOOBA.json as an example in the Lona_Booba_Graphics\PaletteChanger\unactive_jsons\DESU folder. The mod considers as active only those Json files that are in Lona_Booba_Graphics\PaletteChanger folder.
(I currently do not know how to solve this problem in another way). :confused: –––> Suggestions are welcome.

---- To remove the mod in the middle of the game you need to get rid of the "Expanded Booba" effect and, if available, the items "AddModExpandedBooba" and "AidModExpandedBooba" (items should be removed only through the cheat menu; in no case, do not throw out of the inventory).

</details>

<hr/>

<details>
<summary>Big thanks to:</summary>

- `@HY` from arca.live for Base body sprites set and `Hunter outfit`.
- `@카나리아` for Pose_Replacer script.
- `UltraRev` for bringing huge chunk of immersion to the mod by reimagining the code responsible for 'image delivery' and providing full support for UMM.
- `Ricordi` for for continuing @HY's work on sprite redrawing and other visual stuff.

</details>

