public class TextField {
  String text;
  float x, y;
  boolean isSelected;

  TextField(float x, float y) {
    this.x = x;
    this.y = y;
    text = "";
  }

  void display() {
    fill(255);
    rect(x, y, 200, 30);
    fill(0);
    text(text, x + 10, y + 20);
  }

  void addCharacter(char key) {
    if (key == '\n') { // If the 'Enter' key is pressed
      executeCommand(text); // Execute the command
      text = ""; // Clear the command
    } else if (key == BACKSPACE) {
      if (text.length() > 0) {
        text = text.substring(0, text.length() - 1);
      }
    } else {
      text += key; // Add the typed character to the command
    }
  }

  public void select() {
    this.isSelected = true;
  }

  public void deselect() {
    this.isSelected = false;
  }

  public boolean isSelected() {
    return this.isSelected;
  }
}
