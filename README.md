# moho-switch2fbf
A simple Moho tool script to convert/translate a set of layers into a series of Frame-by-Frame Switched frames.

### Version ###

*	version: MH12/13 001.2 #510130.01      -- by Sam Cogheil (SimplSam)
*	release: n/a

* What's New:

  - Convert any set of selected groups/layers into a Switched FBF group
  - Convert any single Group containing sublayers into a Switched FBF group

### How do I get set up ? ###

* To install:

  - Save the 'ss_switch2fbf.lua' and 'ss_switch2fbf.png' file/s to your computer into your custom scripts/tools folder
  - Reload Moho/AnimeStudio scripts (or Restart Moho)

* To use:

  - Ensure the target layers are grouped into a Switch layer as uniquely named sub-layers.
  - Select the Switch layer, and run the tool.

* options:
  - You can optionally (in dialog) set:
    * **FBF Interval:** - The Frame by Frame interval. (default: 1)
    * **Start with:** - The translation sort order: _Top Layer_ for Top to Bottom (top => 1st frame), _Bottom Layer_ for Bottom to Top (bot => 1st frame). (default: Top Layer)
