 *******************************************************
 **      VESA256: VESA Graph unit for 256 colors      **
 *******************************************************

   This is the Readme.txt of version 1.1 (11-29-'96)

 *******************************************************
 **    Source by Peter de Jong.                       **
 **              Niek Engelschmanlaan 121,            **
 **              6532 CR, Nijmegen,                   **
 **              The Netherlands.                     **
 **              Phone  : +31-24-3554399              **
 **              E-Mail : WPDEJONG@WORLDONLINE.NL     **
 *******************************************************

 What is it?
 -----------
 This is a unit with which you can produce fast 256 color
 graphics using the VESA BIOS in your video card or a VESA
 driver. The source code was written for TP7/BP7 real-mode,
 and it is free-ware. It is a spin-off of a complex library
 of units I made to support a windowing environment under
 DOS. You can see a program created in this environment at:

 [http://www.geocities.com/CapeCanaveral/3093]


 Why should you use it?
 ----------------------
 It's resonably fast, supports multiple resolutions, pcx
 image files, and it does include very neat mouse support.
 It is however not completely compatible with the BP Graph
 unit, but it has been debugged reasonable.

 These VESA modes that are supported: 640x480 pixels
                                      800x600 pixels
                                      1024x768 pixels
                                      1154x864 pixels
                                      1280x1024 pixels
                                      1600x1200 pixels

 Remarks:
 --------
 - Take a look at the two demonstrations.
 - High resolutions can damage certain monitors.
 - You must specify the {$G+} and {$F+} compiler directives.
 - When you overlay this unit you must move the mouse
   interrupt routine to a non-overlayed unit.
 - You should clear a new page before using it.
 - The unit is big, maybe you should split it in multiple units.
 - There is a 'SpritePut' operator, which operates the same
   as the 'CopyPut' operator but does not draw color 0.
 - You can assemble a bitmap before putting it on the screen.
 - You can copy screen sections bigger than 64 Kb, even
   from one page to another.
 - big, multi-colored mouse pointers are supported.
 - Only PCX files with 256 colors (version 5) can be read.
 - 61 different bitmap fonts are supported.
 - You should improve file handling!
 - You will need to 'move' the mouse pointer from within
   your program, just as in the examples. The reason for
   this is that some of the graphical routines are not
   re-entrant, calling them from within the interrupt
   routine could produce artifacts.