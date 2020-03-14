
import processing.video.*;
import gab.opencv.*;

/*
BLOB DETECTION: WEBCAM
Jeff Thompson | 2017 | jeffreythompson.org
An expanded version of the Blob Detection example
using the webcam as an input. Try using your phone's
flashlight in a darkened room, adjusting the threshold
until it's the only blob. The mouse's X position is
also used to set the minimum blob size – anything smaller
is ignored, which is useful for noisey environments.
Details on how the pre-processing and blob detection
work are skipped here, so see the previous example
if you want to understand what's happening there.
For more on getting webcam input, see the Image 
Processing code examples.
*/

Capture webcam;              // webcam input
OpenCV cv;                   // instance of the OpenCV library
ArrayList<Contour> blobs;    // list of blob contours

  PImage img1;

void setup() {
  size(640,480);
  
    img1 = loadImage("AuraS.png");
  
  // create an instance of the OpenCV library
  // we'll pass each frame of video to it later
  // for processing
  cv = new OpenCV(this, width,height);
  
  // start the webcam
  String[] inputs = Capture.list();
  printArray(inputs);
  if (inputs.length == 0) {
    println("Couldn't detect any webcams connected!");
    exit();
  }
  webcam = new Capture(this, inputs[0]);
  webcam.start();
 
  // text settings (for showing the # of blobs)
  textSize(20);
  textAlign(LEFT, BOTTOM);
}

    int threshold = 54;
    int blobMax = 11170;
void draw() {
  
  // don't do anything until a new frame of video
  // is available
  if (webcam.available()) {
    
    // read the webcam and load the frame into OpenCV
    webcam.read();
    cv.loadImage(webcam);
    
    // pre-process the image (adjust the threshold
    // using the mouse) and display it onscreen
    
    //set threshold manualy

    

    
    cv.threshold(threshold);
    //cv.invert();    // blobs should be white, so you might have to use this
    cv.dilate();
    cv.erode();
    
    //show the image
    //image(cv.getOutput(), 0,0);
    image(webcam,0,0);
    //filter(INVERT);
    
     //get the blobs and draw them
    blobs = cv.findContours();
    noFill();
    stroke(255,150,0);
    noStroke();
    for (Contour blob : blobs) {
      
      // optional: reject blobs that are too small
      if (blob.area() < blobMax) {
        continue;
      }
    float centerX = 0;
    float centerY = 0;
    int numPts = 0;
      beginShape();
      for (PVector pt : blob.getPolygonApproximation().getPoints()) {
        vertex(pt.x, pt.y);
        centerX += pt.x;
        centerY += pt.y;
        numPts +=1;
      }
      endShape(CLOSE);
      
    centerX /= numPts;
    centerY /= numPts;
    
    fill(255,0,0);
    //ellipse(centerX,centerY,30,30);
    imageMode(CENTER);
    tint(255, 126);
    image(img1,centerX,centerY);
    fill(0);
    
    imageMode(CORNER);
    tint(255);
    
    }
    
    // how many blobs did we find?
    fill(0,150,255);
    noStroke();
    
        if(key=='w'){
      threshold+=1;
      key='q';
    }
    
        if(key=='s'){
      threshold-=1;
      key='q';
    }
    
            if(key=='e'){
      blobMax+=10;
      key='q';
    }
    
        if(key=='d'){
      blobMax-=10;
      key='q';
    }
    
    //text(blobs.size() + " blobs", 20,height-20);
    //text(threshold + " threshold", 35,height-35);
    //text(blobMax + " blobMax", 50,height-50);
  }
  
  star(random(40,600),random(40,600),15,35,4);
  
}

void star(float x, float y, float radius1, float radius2, int npoints) {
  float angle = TWO_PI / npoints;
  float halfAngle = angle/2.0;
  beginShape();
  for (float a = 0; a < TWO_PI; a += angle) {
    float sx = x + cos(a) * radius2;
    float sy = y + sin(a) * radius2;
    vertex(sx, sy);
    sx = x + cos(a+halfAngle) * radius1;
    sy = y + sin(a+halfAngle) * radius1;
    vertex(sx, sy);
  }
  endShape(CLOSE);
}
