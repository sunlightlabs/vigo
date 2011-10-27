// Shows an image of Vigo the Carpathian, whose eyes remain closed until "he" (the Kinect) spots a moving target,
// at which point they snap open, and then follow the target until that target moves off frame.

// This uses no skeleton tracking, just passive user identification and tracking. 
// It is not perfect; Vigo is known to become fixated on walls and pillars, though he seems to lose interest in them easily when a person walks in front.

// Created by Eric Mill for the Sunlight Foundation, October 2011.

// Code released under a CC Zero (public domain) license:
// http://creativecommons.org/publicdomain/zero/1.0/

// Included images derive from the wallpaper of Vigo the Carpathian found here, licensing status unclear:
// http://www.goodfon.com/wallpaper/92399.html


import SimpleOpenNI.*;
SimpleOpenNI  kinect;

// display resolution of the screen (adjust for your own display)
int screenWidth = 1920;
int screenHeight = 1080;

// size of Kinect's depth map
int width = 640;
int height = 480;

boolean debug = false;
float kinectX = screenWidth - width;
float kinectY = screenHeight - height;

// width of eyes (size of pupil track, without accounting for buffer)
int eyeWidth = 100;

// buffer of pixels on either side of the eye to restrain and scale the pupil track
int pupilBufferLeft = 28; 
int pupilBufferRight = 30;

// just used for debug eyes
int eyeHeight = 50;
int pupilSize = 30;

// absolute positions of eyelid images
int lidLeftX = 686;
int lidLeftY = 519;
int lidRightX = 950;
int lidRightY = 493;

// center point of iris for left and right eyes, in the context of the painting
float leftX = 770;
float leftY = 553;
float rightX = 1008;
float rightY = 528;

// center point of iris for left and right eyes, in the context of their respective image files
float leftEyeCenterX = 78;
float leftEyeCenterY = 61;
float rightEyeCenterX = 71;
float rightEyeCenterY = 62;

// position and user ID of target
PVector target;
int targetId;

PImage painting, leftEye, rightEye, leftLid, rightLid;


void setup() {
  size(screenWidth, screenHeight);
  
  painting = loadImage("data/vigo.png");
  leftEye = loadImage("data/vigo-left.png");
  rightEye = loadImage("data/vigo-right.png");
  leftLid = loadImage("data/eye-left.png");
  rightLid = loadImage("data/eye-right.png");
  
  kinect = new SimpleOpenNI(this);
  kinect.enableDepth();
  
  // not using any skeleton tracking
  kinect.enableUser(SimpleOpenNI.SKEL_PROFILE_NONE);
  
  // mirror the data
  kinect.setMirror(true);
}


void draw() {
  background(0);
  
  // tell the kinect to grab a new image
  kinect.update();
  
  // all available targets
  IntVector userList = new IntVector();
  kinect.getUsers(userList);
  
  // if there's a target and they stayed in frame, get their new position
  if (target != null) {
    PVector center = centerFor(targetId);
    if (center == null) {
      println("Lost target: " + targetId);
      target = null;
      targetId = -1;
    } else
      target = center;    
  }
  
  // if we don't have the target, or we lost it, find the next valid target
  if (target == null) {
    for (int i=0; i<userList.size(); i++) {
      int userId = userList.get(i);
      
      PVector center = centerFor(userId);
      
      if (center != null) {
        target = center;
        targetId = userId;
        println("Got target: " + userId);
      }
    }
  }
  
  // always draw eyes, even with no target
  leftEye(target);
  rightEye(target);
  
  // then draw vigo
  image(painting, 0, 0);
  
  // then eye lids, if there's no target
  if (target == null) {
    image(leftLid, lidLeftX, lidLeftY);
    image(rightLid, lidRightX, lidRightY);
  }
  
  // if debug is on, show kinect depth map with little eyes on targets, 
  // andthen redraw left and right eyes on top of everything, complete with red ovals
  if (debug) {
    PImage depth = kinect.depthImage();
    image(depth, kinectX, kinectY);
    if (target != null)
      littleEye(kinectX + target.x, kinectY + target.y);
      
    leftEye(target);
    rightEye(target);
  }
}


void leftEye(PVector target) {
  float pupilPosition;
  
  // if there's a target, map the person's position on the screen to the corresponding pupil position on the track
  if (target != null)
    pupilPosition = map(target.x, 0, width, 0 + pupilBufferLeft, eyeWidth - pupilBufferLeft);

  // otherwise, just draw the eye centered
  else
    pupilPosition = eyeWidth / 2;
  
  // convert pupilPosition within eye to an offset from the center
  float pupilOffset = pupilPosition - (eyeWidth / 2);
  
  // adjust pupil for size of eye image files
  float pupilLeft = leftX - leftEyeCenterX;
  float pupilTop = leftY - leftEyeCenterY;
  
  // draw the eye in its final position
  image(leftEye, pupilLeft + pupilOffset, pupilTop);
  
  // if debug mode's on, draw the big red eye on top of all of this
  if (debug)
    bigEye(leftX, leftY, pupilOffset);
}

void rightEye(PVector target) {
  float pupilPosition;
  
  // if there's a target, map the person's position on the screen to the corresponding pupil position on the track
  if (target != null)
    pupilPosition = map(target.x, 0, width, 0 + pupilBufferRight, eyeWidth - pupilBufferRight);
    
  // otherwise, just draw the eye centered
  else
    pupilPosition = eyeWidth / 2;
  
  // convert pupilPosition within eye to an offset from the center  
  float pupilOffset = pupilPosition - (eyeWidth / 2);
  
  // adjust pupil for size of eye image files
  float pupilLeft = rightX - rightEyeCenterX;
  float pupilTop = rightY - rightEyeCenterY;
  
  // draw the eye in its final position
  image(rightEye, pupilLeft + pupilOffset, pupilTop);
  
  // if debug mode's on, draw the big red eye on top of all of this
  if (debug)
    bigEye(rightX, rightY, pupilOffset); 
}

// draws a simple red eye with a simple red pupil, to better illustrate the motion of pupils.
// only drawn during debug mode.
void bigEye(float x, float y, float pupilOffset) {
  fill(255, 0, 0);
  ellipse(x, y, eyeWidth, eyeHeight);
  
  fill(180, 0, 0);
  ellipse(x + pupilOffset, y, pupilSize, pupilSize);
}

// draws a little eye over the target on the debug window
void littleEye(float x, float y) {
  fill(255, 255, 255);
  ellipse(x, y, 50, 25);
  fill(180, 0, 0);
  ellipse(x, y, 15, 15);
}

// looks to see if there's a center of mass for the given user ID, and one that is not on the edge of the frame
PVector centerFor(int userId) {  
  PVector position = new PVector();
  kinect.getCoM(userId, position);
  
  if (position == null)
    return null;
  
  PVector converted = new PVector();
  kinect.convertRealWorldToProjective(position, converted); 
  
  if (converted == null)
    return null;
  
  // don't wait for the Kinect to decide the user isn't coming back - if someone goes off frame, they're out
  if (!(converted.x > 0 && converted.x < width))
    return null;
    
  return converted;
}

// hitting the Up arrow toggles debug mode
void keyPressed() {
  if (keyCode == UP)
   debug = !debug; 
}
