Introduction
------------

The core principal to the Scratch on Flash design was to mirror the Squeak design as much as possible. In general, there are a lot of similarities, especially in the core objects like the Blocks, the ScratchProcess, and the ScriptableScratch subclasses.

But a few things were changed along the way. A summary of the kinds of changes:

   * When deserializing the scratch project object file, non-executable UI elements (and things like floating blocks) are thrown away. This is just a player, so it does not need edit-only information
   * Blocks and the like are not graphical, so they end with 'Block' and not 'Morph'
   * The graphical element of a Sprite is in SFSprite (ScratchFlashSprite) and not in the 'Morph'. 'Morph' within the Flash program means 'Graphically-aware, Scriptable, Scratch Object'. So 'Morph's are controllers of graphics but are not within the Flash display hierarchy itself.
   * I stripped the 'Scratch' prefix off some classes. Flash has package-based namespace capabilities, so the extra Scratch just made a class name longer. For example, 'ScratchSpriteMorph' becomes just 'SpriteMorph'.
   * I tend to avoid having classes that also function as libraries (pure static capabilities), so a couple classes had their static functionality split out into a 'Lib' class
   * Creating Smalltalk equivalent classes was avoided although I needed some image-processing classes (StForm) to deal with conversion beyond what ObjStream itself does
