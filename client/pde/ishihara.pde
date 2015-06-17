// Processing code

// TODO: allow dynamic image uploads
// TODO: render text strings
// TODO: accept input of strings

Circle[] circles = new Circle[5000]; // Magic number..

String motiv = "dog";

int count = 0;
int maxDiameter = 22;
int minDiameter = 8;
int lastAdded = 0;
int lastAddedTimeout = 100;
int lastX = -1, lastY = -1;
int COLOR = 1;

PImage motive;

color[] off, on;

// variables declared within setup() are not accessible within other functions
void setup() {
  size(600, 600);
  // first parameter of size() sets `width`, a System variable that stores the width of the display window
  smooth();
  background(255);
  colorMode(RGB);
  noFill();

  motive = loadImage("img/"+motiv+".png");
  
  // color from the interwebs, used as default
  color[] _off = {
  // style 1
    // color(#9CA594), color(#ACB4A5), color(#BBB964), color(#D7DAAA), color(#E5D57D), color(#D1D6AF)
  // style 2
    color(#F49427), color(#C9785D), color(#E88C6A), color(#F1B081), color(#FFCE00)
  };
  color[] _on = {
  // style 1
    // color(#F9BB82), color(#EBA170), color(#FCCD84)
  // style 2
    color(#89B270), color(#7AA45E), color(#B6C674), color(#7AA45E), color(#B6C674), color(#FECB05)
  };

  on = _on;
  off = _off;

}

// main function called directly after setup() and runs continously until program is stopped
// use noLoop() to stop
// use redraw() to execute once
// use loop() to resume
void draw() {

  if (count < circles.length) {
    circles[count] = new Circle();
    // void any circle that overlaps
    if (circles[count].overlapsAny()) {
      circles[count] = null;
    }
    
    if (circles[count] != null) {
      // draw the circle
      circles[count].draw();
      count++;
      lastAdded = 0;
    } else {
      if (lastAdded > lastAddedTimeout) {
         // trying to draw too big of circles
         maxDiameter--;
         lastAdded = 0;
      }
      // record waiting time
      lastAdded++;
    }
  }
  // reset to default
  lastX = lastY = -1;
}

class Circle
{
  float x, y, radius;
  int[] xs, ys;
  color bg = color(255,255,255), fg = -1; // default values
  
  Circle() {
    // small circle
    radius = random(minDiameter, maxDiameter) / 2.0;
    // containing circle
    float a = random(PI*2);
    float r = random(0, width*.48 - radius);
    // create new position or use first position
    x = lastX < 0 ? width*.5 + cos(a)*r : lastX;
    y = lastY < 0 ? height*.5 + sin(a)*r : lastY;
    init();
  }
  
  void init() {
    int x = int(this.x), y = int(this.y), r = int(radius);
    // setup coordinates of circle for reading pixels
    int[] xs = {
      x, x, x, x-r, x+r, int(x - r*.93), int(x - r*.93), int(x + r*.93), int(x + r*.93)
    };
    int[] ys = {
      y, y-r, y+r, y, y, int(y + r*.93), int(y - r*.93), int(y + r*.93), int(y - r*.93)
    };
    this.xs = xs;
    this.ys = ys;
  }
  
  boolean overlapsMotive() {
    for (int i = 0; i < xs.length; i++) {
      // use the x and y parameters to get the value of one pixel.
      int colour = motive.get(xs[i], ys[i]);
      if (colour != bg) {
        return true;
      }
    }
    return false;
  }
  
  boolean overlapsAny() {
    for (int i = 0; i < xs.length; i++) {
      // from canvas
      int colour = get(xs[i], ys[i]);
      if (colour != bg) {
        return true;
      }
    }
    // contain size of circle
    if (radius > minDiameter) {
      radius = minDiameter;
      init();
      return overlapsAny();
    }
    return false;
  }
  
  void draw() {
    switch(COLOR) {
      case 1:
        if (fg < 0) fg = overlapsMotive() ? on[int(random(0, on.length))] : off[int(random(0, off.length))];
      break;
      case 2:
        if (fg < 0) fg = overlapsMotive() ? color(#000000) : color(#F1F1F1);
      break;
      case 3: 
        if (fg < 0) fg = overlapsMotive() ? color(#F75B23) : color(#798B7D);
      break;
     }

    fill(fg);
    noStroke(); // no outline
    ellipse(x, y, radius*2, radius*2);
  }

}

// Must click on the image to give it focus first
void keyPressed() {
  // press s key to save image.
  if (key == 's') {
    save();
  }
 
  // select different image.
  if (key == '0') { background(); motive = loadImage("img/dog.png"); redraw(); }
  if (key == '1') { background(); motive = loadImage("img/bear.png"); redraw(); }
  if (key == '2') { background(); motive = loadImage("img/butterfly.png"); redraw(); }
  if (key == '3') { background(); motive = loadImage("img/duck.png"); redraw(); }
  if (key == '4') { background(); motive = loadImage("img/tree.png"); redraw(); }
  if (key == '5') { background(); motive = loadImage("img/5.png"); redraw(); }

  // select different color.
  if (key == 'v') { background(); COLOR = 1; redraw(); }
  if (key == 'b') { background(); COLOR = 2; redraw(); }
  if (key == 'n') { background(); COLOR = 3; redraw(); }

}
