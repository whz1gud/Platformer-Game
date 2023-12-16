public class AnimatedSprite extends Sprite {
  PImage[] currentImages;
  PImage[] standNeutral;
  PImage[] moveLeft;
  PImage[] moveRight;
  int direction;
  int index;
  int frame;
  public AnimatedSprite(PImage img, float scale) {
    super(img, scale);
    direction = NEUTRAL;
    index = 0;
    frame = 0;
  }

  public void updateAnimation() {
    frame++;
    if (frame % 5 == 0) {
      selectDirection();
      selectCurrentImages();
      advanceToNextImage();
    }
  }

  public void selectDirection() {
    if (change_x > 0) {
      direction = FACING_RIGHT;
    } else if (change_x < 0) {
      direction = FACING_LEFT;
    } else
      direction = NEUTRAL;
  }

  public void selectCurrentImages() {
    if (direction == FACING_RIGHT) {
      currentImages = moveRight;
    } else if (direction == FACING_LEFT) {
      currentImages = moveLeft;
    } else
      currentImages = standNeutral;
  }

  public void advanceToNextImage() {
    index++;
    if (index == currentImages.length) {
      index = 0;
    }
    image = currentImages[index];
  }
}
