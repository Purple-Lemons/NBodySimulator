/*
This class is simply the help screen that you see at the start of the simulation
 */

public class HelpTab {

  private String title = "Help";
  private String subtitle = "This is the help tab, press any key to close it, press h to reopen it";
  private String description = "This is a physics simulation of a planet with many moons, the moons interact with each other via gravitational \n distortion (pull) and collisions. You can add moons by click and dragging, the further you drag the faster they'll \n be moving";
  private String controls = "Controls: \n Zoom In/Out: Scroll Wheel \n Speed Up Time: . \n Slow Down Time: , \n Increase New Moon Mass: + \n Decrease New Moon Mass: - \n Create New Moon: Click and Drag";
  private String uiInfo = "You can also change start mass and time step using the UI in the top left. \n Info about the moons can be found by hovering over them"; 

  public HelpTab() {
  }

  public void render() {
    //Draws a translucent text box on screen to house the text and still show whats happening in the simulation
    fill(64, 64, 64, 128);
    rect(100, 100, 1400, 700, 50);

    //Fills the box with the text
    textAlign(CENTER);
    fill(200);
    textSize(52);
    text(title, 800, 200);

    textSize(24);
    text(subtitle, 800, 270);
    text(description, 800, 320);
    text(controls, 800, 450);
    text(uiInfo, 800, 720);

    //Resets text size and fill properties
    textSize(16);
    fill(255, 255, 255);
  }
}