/*
This class handles the ui at the top left of the screen, that displays the time step
 and the start mass of new moons that the player can add, and also allows the user to
 alter these values.
 The ui consists of information boxes and buttons to change the values
 */

public class UI {

  private String[][] uiElems = {{"-", "TimeStep: " + 600, "+"}, {"-", "StartMass: " + 0, "+"}};//The content of the ui
  private int[] uiElemsDimensions = {40, 160, 40};//The widths of each section of the ui

  private int xMargin = 10;//The margins from the edge of the screen
  private int yMargin = 10;

  private int buttonHeight = 40;

  private Space space;

  public UI(Space space_) {
    space = space_;
  }

  public void render(float mass, float timeStep) {
    //Updates the time step and mass information
    uiElems[0][1] = "TimeStep: " + timeStep;
    uiElems[1][1] = "StartMass: " + mass;

    //Draws then information and buttonss on screen
    for (int i = 0; i < uiElems.length; i++) {
      int currentX = xMargin;
      for (int j = 0; j < uiElems[i].length; j++) {
        stroke(128);
        fill(64, 64, 64, 128);
        rect(currentX, yMargin + i * buttonHeight, uiElemsDimensions[j], buttonHeight);

        fill(255);
        textAlign(LEFT, TOP);
        text(uiElems[i][j], currentX + 5, 10 + i * 40);

        currentX += uiElemsDimensions[j];
      }
    }

    buttons();
  }

  public void buttons() {//Detects when a button is pressed in the UI
    if (mousePressed) {
      if (mouseX > xMargin && mouseX < xMargin + uiElemsDimensions[0] && mouseY > yMargin && mouseY < yMargin + buttonHeight) {//The '-' time speed button
        space.setSpeed(false);
      }
      if (mouseX > xMargin + uiElemsDimensions[0] + uiElemsDimensions[1] && mouseX < 250 + uiElemsDimensions[0] + uiElemsDimensions[1] + uiElemsDimensions[2] && mouseY > yMargin && mouseY < yMargin + buttonHeight) {//The '+' time speed button
        space.setSpeed(true);
      }
      if (mouseX > xMargin && mouseX < xMargin + uiElemsDimensions[0] && mouseY > yMargin + buttonHeight && mouseY < yMargin + 2 * buttonHeight) {//The '-' start mass button
        space.setStartMass(false);
      }
      if (mouseX > xMargin + uiElemsDimensions[0] + uiElemsDimensions[1] && mouseX < 250 + uiElemsDimensions[0] + uiElemsDimensions[1] + uiElemsDimensions[2] && mouseY > yMargin + buttonHeight && mouseY < yMargin + 2 * buttonHeight) {//The '+' start mass button
        space.setStartMass(true);
      }
    }
  }

  //Checks if the the mouse is in the ui box so that moons aren't added while clicking on the UI
  public boolean isMouseInUI() {
    if (mouseX > 10 && mouseX < 250 && mouseY > 10 && mouseY < 90) {
      return true;
    }
    return false;
  }
}