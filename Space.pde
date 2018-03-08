/*
This class is where all of the moons and the planet exist and are controlled during run time.
It also handle the controls input for the moons and adding new moons.
 */
public class Space implements UniversalValues {

  private Planet earth;
  private ArrayList<Moon> moons = new ArrayList<Moon>();
  private UI ui;

  private float timeStep = 600.0;//The speed at which time runs in the simulation

  private float[][] moonStartParams = {{12000000, 0, 450000, 9.7E20, timeStep / fps}, {0, 8000000, 90000, 1.7E20, timeStep / fps}, {-4000000, 0, 150000, 3.0E20, timeStep / fps}, {4000000, 0, 90000, 1.7E20, timeStep / fps}, {0, -9000000, 135000, 2.5E20, timeStep / fps}};
  private float[][] moonStartSpeeds = {{0, 542.5}, {-600, 0}, {0, -900}, {0, 800}, {550, 0}};

  private float scale = 40000;//The scale at which the system is rendered

  private float xOffset = 0;//The camera offset - where the relative center of the system is on screen
  private float yOffset = 0;

  //When mouse is dragged these are set to define the velocity of a new moon
  private float startX;//The start position where the mouse was dragged
  private float startY;
  private float endX;//The end point of a mouse drag
  private float endY;
  private float startMass = 5.0E20;//The start mass of a new moon

  public Space() {
    ui = new UI(this);

    earth = new Earth(0, 0, 900000, 5.2915793E22, timeStep / fps);

    //Adding the default moons
    for (int i = 0; i < moonStartParams.length; i++) {
      moons.add(new Moon(moonStartParams[i][0], moonStartParams[i][1], moonStartParams[i][2], moonStartParams[i][3], moonStartParams[i][4])); 
      moons.get(i).setSpeed(moonStartSpeeds[i][0], moonStartSpeeds[i][1]);
    }
  }

  public void run() {
    //Sets the offsets such that the planet is at the center of the screen
    xOffset = (-earth.getX()) / scale + 800;
    yOffset = (-earth.getY()) / scale + 450;

    for (int i = 0; i < moons.size(); i++) {
      if (moons.get(i) != null) {
        moons.get(i).calculate(moons, i);
        moons.get(i).calcOrbitalParams(earth);
        moons.get(i).render(scale, (xOffset * scale), (yOffset * scale));//Renders the moon itself
        moons.get(i).renderOrbit(scale, (xOffset * scale), (yOffset * scale));//Renders the moons orbital elipse
      }
    }

    for (int i = 0; i < moons.size(); i++) {//Moves the moons after all of the forces have been applied
      moons.get(i).move();
    }

    earth.calculate(moons, -1);
    earth.render(scale, (xOffset * scale), (yOffset * scale));

    findMoonAtMouse();//Check is the mouse is hovering over a moon

    ui.render(startMass, timeStep);
  }

  public void setSpeed(boolean up) {//Sets the time step for the simulation
    if (!up && timeStep > 1) {
      timeStep -= 10;

      earth.setStep(timeStep / fps);
      for (int i = 0; i < moons.size(); i++) {
        if (moons.get(i) != null) {
          moons.get(i).setStep(timeStep / fps);
        }
      }
    }
    if (up) {
      timeStep += 10; 

      earth.setStep(timeStep / fps);
      for (int i = 0; i < moons.size(); i++) {
        if (moons.get(i) != null) {
          moons.get(i).setStep(timeStep / fps);
        }
      }
    }
  }

  public void zoom(float e) {
    //zooms camera in of the center planet
    if (e == -1 && scale > 1) {
      scale -= 1000;
    }
    if (e == 1) {
      scale += 1000;
    }
  }

  public void setNewStart(float x, float y) {
    //Sets the start position for a new moon
    if (!ui.isMouseInUI()) {
      startX = x;
      startY = y;
    }
  }
  
  public void setStartMass(boolean up) {
    //Sets the mass of new moons being added
    if (up) {
      startMass += 0.1E20;
    } else if (!up && startMass > 0.1E20) {
      startMass -= 0.1E20;
    }
  }

  public void setNewEnd(float x_, float y_) {
    //Sets the end of where the mouse was dragged to determine the velocity of the new moon
    if (!ui.isMouseInUI()) {
      endX = x_;
      endY = y_;

      float x = (startX - xOffset) * scale;
      float y = (startY - yOffset) * scale;

      float xSpeed = (endX - startX) * 7;
      float ySpeed = (endY - startY) * 7;

      moons.add(new Moon(x, y, startMass / 2.2E15, 5.0E20, timeStep / fps));
      moons.get(moons.size() - 1).setSpeed(xSpeed, ySpeed);
    }
  }

  public void findMoonAtMouse() {//Determines if the mouse is hovering over a moon, so that an info box can be displayed
    //Turns the mouse position into the position in the universe
    xOffset = (-earth.getX()) / scale + 800;
    yOffset = (-earth.getY()) / scale + 450;

    float x = (mouseX - xOffset) * scale;
    float y = (mouseY - yOffset) * scale;

    //Searches through the moons to find if the mouse is on them
    for (int i = 0; i < moons.size(); i++) {
      if (abs(moons.get(i).getX() - x) < moons.get(i).getRadius() && abs(moons.get(i).getY() - y) < moons.get(i).getRadius()) {
        moons.get(i).setSelected();
      }
    }
  }

  public void mouseDrag(float x, float y) {
    //Draws an indicator line when the mouse is dragged to represent where the moon will go
    if (!ui.isMouseInUI()) {
      line(x, y, startX, startY);
    }
  }
}