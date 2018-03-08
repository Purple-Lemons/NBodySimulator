/*
This is the class the handles the logic for planets and the bulk of the logic 
 for the moons since moons and planets are basically the same thing.
 */

public abstract class Planet implements UniversalValues {

  //Phyisical characteristics of the planet
  protected float x;
  protected float y;
  protected float radius;
  protected float mass;
  protected float timeStep;//The rate at whioch time moves in the simulation

  protected float xSpeed;
  protected float ySpeed;

  public void setStep(float tS) {
    timeStep = tS;
  }

  public void render(float scale, float xOffset, float yOffset) {
    stroke(0, 128, 255);
    fill(0, 128, 255);
    ellipse( (x + xOffset) / scale, (y + yOffset) / scale, radius / scale, radius / scale);//Renders the planet as an ellipse
    fill(255);
    stroke(255);
  }

  public void calculate(ArrayList<Moon> moons, int pos) {
    float distX;
    float distY;
    float dist;

    float F;//Magnitude of the gravitational force

    //Applys gravitational force to the moons
    for (int i = 0; i < moons.size(); i++) {
      if (moons.get(i) != null && i != pos) {
        distX = x - moons.get(i).getX();
        distY = y - moons.get(i).getY();
        dist = sqrt(sq(distX) + sq(distY));

        F = (G * mass * moons.get(i).getMass() / sq(dist));//Newtons law of gravitation

        moons.get(i).applyForce(F, x, y);//Applies the gravitational force to the moon

        if (collided(moons.get(i))) {
          //An attempt to simulate a planetary collision as a particle ( a 5% efficient collision)
          moons.get(i).applyForce(-(mass * (getVelocity() / timeStep)) / 20, x, y);
        }
      }
    }
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

  public float getX() {
    return x;
  }

  public float getY() {
    return y;
  }

  public float getMass() {
    return mass;
  }

  public float getVelocity() {
    return sqrt( sq(xSpeed) + sq(ySpeed) );
  }

  public float getRadius() {
    return radius;
  }
}