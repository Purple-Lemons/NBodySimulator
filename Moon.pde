/*
This is the class that handles the logic for the moons in the simulation. Moons inherit most of the planet logic
 with exception of a few rendering things including drawing info boxes and drawing orbits, since the planet doesn't have to do this.
 */
public class Moon extends Planet implements UniversalValues {

  private float angle;//The angle at which a force is being applied to the moon

  //Parameters for drawing the orbital predicition 
  private float argPer;//Argument of periapsis
  private float e;//The eccentricity of the orbit
  private float a;//The semi major axis (the average height of the orbit)
  private float aX;//x position of semi major axis
  private float aY;//y position of semi mahor axis
  private float cX;//x position of the center of the orbital ellipse
  private float cY;//y position of the center of the oribtal ellipse
  private float b;//The semi minor axis

  //The color that the moon will be drawn as
  private int red;
  private int green;
  private int blue;

  private boolean selected = false;//Used to determine if the the muse is hovering above the moons, so that an info box can be displayed

  public Moon(float startX, float startY, float rad, float m, float tS) {
    x = startX;
    y = startY;
    radius = rad;
    mass = m;
    timeStep = tS;

    //Sets a random color for the moon and orbit to be drawn in, this makes them more distict when close to each other
    red = (int) random(128, 255);
    green = (int) random(128, 255);
    blue = (int) random(128, 255);
  }

  public void render(float scale, float xOffset, float yOffset) {
    stroke(red, green, blue);
    fill(red, green, blue);
    ellipse( (x + xOffset) / scale, (y + yOffset) / scale, radius / scale, radius / scale);//Renders the moon an ellipse
    fill(255);

    if (selected) {//If the moons is being hovered over it displays the info box about the moon
      renderInfoBox((x + xOffset) / scale, (y + yOffset) / scale);
    }
    selected = false;
  }

  public void renderOrbit(float scale, float xOffset, float yOffset) {
    //Draws the orbit
    noFill();

    translate((cX + xOffset) / scale, (cY + yOffset) / scale);//Translates the reference frame to the center of the orbital ellipse
    rotate(argPer);//Rotates the reference frame by the argument of periapsis
    translate(-(cX + xOffset) / scale, -(cY + yOffset) / scale);//Translates back to the orginal reference frame so that the orbit can be draw in the correct location

    ellipse( (cX + xOffset) / scale, (cY + yOffset) / scale, a * 2 / scale, b * 2 / scale);//Draws the orbital ellipse

    //Undoes the rotation
    translate((cX + xOffset) / scale, (cY + yOffset) / scale);
    rotate(2 * PI - argPer);
    translate(-(cX + xOffset) / scale, -(cY + yOffset) / scale);
    fill(255);
    stroke(255);
  }

  public void renderInfoBox(float moonX, float moonY) {//Displays the info box about the moon when the moon is hovered over
    line(1300, 200, moonX, moonY);//Draws a line from the moon to the box
    fill(64, 64, 64, 128);
    rect(1300, 200, 200, 80);//Draws the info box

    //Fills the box with text
    fill(255);
    textAlign(CENTER);
    text("Mass: " + mass, 1400, 220);
    text("Speed: " + getVelocity(), 1400, 240);
    text("Radius: " + radius, 1400, 260);
  }

  public boolean collided(Moon moon) {
    //Checks if the moon has collided with another moon
    float xDist = moon.getX() - x;
    float yDist = moon.getY() - y;

    float distance = sqrt( sq(xDist) + sq(yDist) );

    if (distance < (moon.getRadius() + radius) / 2) {//Checks if there radii intersect
      return true;
    } else {
      return false;
    }
  }

  public void calcOrbitalParams(Planet parent) {//Calculates the information for drawing the orbital ellipse

    PVector rVec = new PVector(parent.getX() - x, parent.getY() - y);//The position vector of the moon
    float r = mag(rVec.x, rVec.y);//The magintude of position of the moon

    PVector vVec = new PVector(xSpeed, ySpeed);//The velocity vector of the moon
    float v = mag(vVec.x, vVec.y);//The magnitude of the velocity of the moon

    float mu = parent.getMass() * G;//The standard orbital parameteer

    PVector secondBit = vVec.mult(rVec.dot(vVec));//Just shortens the equation below
    PVector eVec = ((rVec.mult(sq(v) - (mu / r))).sub(secondBit.x, secondBit.y, secondBit.z)).div(mu);//The eccentricty vector of the moons orbit
    e = mag(eVec.x, eVec.y, eVec.z);//The eccentricty of the moons orbit

    float energy = ( sq(v) / 2 ) - ( mu / r );//The specific orbital energy of the moon
    a = -mu / (2 * energy);//The semi-major axis of the moons orbit

    float rPer = (1 - e) * a;//The periapsis of the moons orbit (the lowest point) 
    float rApp = (1 + e) * a;//The appoapsis of the moons orbit (the highest point)

    argPer = atan2(eVec.y, eVec.x);//The argument of periapsis of the moons orbit

    //The position of the apoapsis
    float appX = rApp * cos(argPer);
    float appY = rApp * sin(argPer);

    //The position of the periapsis
    float perX = rPer * cos(argPer + PI);
    float perY = rPer * sin(argPer + PI);

    a = (sqrt( sq(perX) + sq(perY) ) + sqrt( sq(appX) + sq(appY) )) / 2;//The semi major axis of the orbit
    aX = (appX - perX) / 2; 
    aY = (appY - perY) / 2;

    //The center of the orbits coordinates
    cX = aX + perX;
    cY = aY + perY;

    b = a * sqrt(1 - sq(e));//The semi minor axis
  }

  public void applyForce(float F, float oX, float oY) {//Used to apply gravitational and collision forces on the moons from other moons and earth
    float a = F / mass;//The resultant acceleration
    angle = atan2(oY - y, oX - x);//The angle at which the force is being apllied
    xSpeed += (a * cos(angle)) * timeStep;
    ySpeed += (a * sin(angle)) * timeStep;
  }

  public void move() {
    x += xSpeed * timeStep;
    y += ySpeed * timeStep;
  }

  public void setSpeed(float x, float y) {//Used to set the start speed of the moon
    xSpeed = x;
    ySpeed = y;
  }  

  public void setSelected() {//Sets selected if the mouse is hovering above the moons
    selected = true;
  }
}