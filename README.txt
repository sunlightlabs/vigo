Shows an image of Vigo the Carpathian, whose eyes remain closed until "he" (the Kinect) spots a moving target, at which point they snap open, and then follow the target until that target moves off frame.

This uses no skeleton tracking, just passive user identification and tracking. It is not perfect; Vigo is known to become fixated on walls and pillars, though he seems to lose interest in them easily when a person walks in front.


== Getting it running ==

1) Install Simple OpenNI:

http://code.google.com/p/simple-openni/wiki/Installation

If you have Windows, you'll need to install the 32-bit version of everything - Simple Open NI doesn't support 64-bit Windows at the time of this writing (October 29, 2011), even though the rest of the stack beneath it (Kinect drivers, OpenNI) does.

2) Install Processing:

http://processing.org/download/

If you have a 64-bit machine, you probably want to download the "Windows (without Java)" version, since the normal Windows version of Processing ships with 32-bit Java, which will cause problems.

3) Run Processing, and the sketch

If you've got everything working, run Processing, then go to File->Open and open "vigo.pde" from this repository. Hit the Play button, or go to Sketch->Run, and it should "just work".


== Full screen mode ==

In Processing, there is a "Present" mode needed to run a sketch full screen. You can either go to Sketch->Present in the menu, or go to File->Export Application..., and check the box about Present mode to export a standalone executable that will run fullscreen.

In Windows 7, full screen mode will only run on the monitor designated as "primary", so if you need to change this, go to the "Adjust screen resolution" settings dialog.


== License ==

Created by Eric Mill for the Sunlight Foundation, October 2011.

Code released under a CC Zero (public domain) license:
http://creativecommons.org/publicdomain/zero/1.0/

Included images derive from the wallpaper of Vigo the Carpathian found here, licensing status unclear:
http://www.goodfon.com/wallpaper/92399.html