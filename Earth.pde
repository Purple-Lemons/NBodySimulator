/*
This is the class that creates a not abstract instance of a planet, it is the planet at the center
 of the moons in this simulation
 */
public class Earth extends Planet {

  public Earth(float startX, float startY, float rad, float m, float tS) {
    x = startX;
    y = startY;
    radius = rad;
    mass = m;
    timeStep = tS;
  }
}