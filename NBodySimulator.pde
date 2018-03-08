/*
This program is an interactive N-Body simulation of a planet with many moons orbiting it. The moons interact with each other via 
 gravitational distortion and innelastic particle like collisions. The current orbital predictions are drawn on screen
 in the form of ellipses. These change as the moons interact.
 
 There is also functionality that allows users to add moons by clicking and dragging the mouse, the furthe you drag the faster the
 moon will be travelling. (If an orbit isn't displayed for this moon, it has reach escape velocity).
 
 The moons and planets are rendered as coloured ellipses on screen
 
 Controls:
 (These are also displayed in a help gui when the program starts up)
 Zoom In/Out: Scroll Wheel 
 Speed Up Time: . 
 Slow Down Time: ,
 Increase New Moon Mass: + 
 Decrease New Moon Mass: - 
 Create New Moon: Click and Drag";
 
 References:
 https://en.wikipedia.org/wiki/Orbital_elements - Used for the equations to calculate orbital elements
 The Processing Reference - For some syntactical information such as 'mouseWheel()'
 */

private Space space;//Where the game logic is centered
private HelpTab helpTab;//The help screen that appears when the program starts

private boolean menuOpen = true;

void setup() {
  size(1600, 900);
  frameRate(60);

  space = new Space();
  helpTab = new HelpTab();
}

void draw() {
  background(8);
  space.run();

  if (menuOpen) {
    helpTab.render();
  }
}

public void keyPressed() {
  if (!menuOpen) {//If the menu is open controls aren't active
    if (key == '.') {
      space.setSpeed(true);
    }
    if (key == ',') {
      space.setSpeed(false);
    }
    if (key == '+') {
      space.setStartMass(true);
    }
    if (key == '-') {
      space.setStartMass(false);
    }
    if (key == 'h') {
      menuOpen = true;
    }
  } else {
    menuOpen = false;
  }
}

public void mouseDragged() {
  if (!menuOpen) {
    space.mouseDrag(mouseX, mouseY);
  }
}

public void mousePressed() {
  if (!menuOpen) {
    space.setNewStart(mouseX, mouseY);
  }
}

public void mouseReleased() {
  if (!menuOpen) {
    space.setNewEnd(mouseX, mouseY);
  }
}

public void mouseWheel(MouseEvent e) {
  space.zoom(e.getCount());
}