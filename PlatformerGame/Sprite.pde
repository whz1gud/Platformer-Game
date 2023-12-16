public class Sprite {
  PImage image;
  float center_x, center_y;
  float change_x, change_y;
  float size_x, size_y;
  int tileNumber = 0;

  public Sprite(String filename, float scale, float x, float y) {
    image = loadImage(filename);
    size_x = image.width * scale;
    size_y = image.height * scale;
    center_x = x;
    center_y = y;
    change_x = 0;
    change_y = 0;
  }
  public Sprite(String filename, float scale) {
    this(filename, scale, 0, 0);
  }
  public Sprite(PImage img, float scale) {
    image = img;
    size_x = image.width * scale;
    size_y = image.height * scale;
    center_x = 0;
    center_y = 0;
    change_x = 0;
    change_y = 0;
  }
  public void display() {
    image(image, center_x, center_y, size_x, size_y);
  }
  public void update() {
    center_x += change_x;
    center_y += change_y;
  }


  public float getTop() {
    return (center_y - (size_y/2));
  }

  public float getBottom() {
    return (center_y + (size_y/2));
  }

  public float getLeft() {
    return (center_x - (size_x/2));
  }

  public float getRight() {
    return (center_x + (size_x/2));
  }

  public void setTop(float val) {
    center_y = val + (size_y/2);
  }

  public void setBottom(float val) {
    center_y = val - (size_y/2);
  }

  public void setLeft(float val) {
    center_x = val + (size_x/2);
  }

  public void setRight(float val) {
    center_x = val - (size_x/2);
  }
}
