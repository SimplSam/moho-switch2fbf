# moho-switch2fbf
A simple Moho tool script to convert/translate a set of layers in a Switch group, into a series of Frame-by-Frame frames.

### Version ###

*	version: MH12/13 001.0B #501124.01      -- by Sam Cogheil (SimplSam)
*	release: n/a

### How do I get set up ? ###

* To install:
  
  - Save the 'ss_switch2fbf.lua' and 'ss_switch2fbf.png' file/s to your computer into your custom scripts/tools folder
  - Reload Moho/AnimeStudio scripts (or Restart Moho) 

* To use:

  - Ensure the target layers are grouped into a Switch layer as uniquely named sub-layers.
  - Select the Switch layer, and run the tool.
  
* options:  
  - You can optionally (in code) set:
    * **fbf_interval** - The Frame by Frame interval. (default: 1)
    * **sort_by_toptobot** - The translation sort order: true for Top to Bottom (top => 1st frame), false for Bottom to Top (bot => 1st frame). (default: true)
