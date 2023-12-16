public class Enemy extends AnimatedSprite {
  float leftBoundry, rightBoundry;
  public Enemy(PImage img, float scale, float lBound, float rBound) {
    super(img, scale);
    moveLeft = new PImage[3];
    moveRight = new PImage[3];
    for (int i = 0; i < 3; i++) {
      moveLeft[i] = loadImage("data/Enemy/enemy" + nf(i + 1, 1) + ".png");
      moveRight[i] = loadImage("data/Enemy/enemy" + nf(i + 1, 1) + ".png");
    }
    currentImages = moveRight;
    direction = FACING_RIGHT;
    leftBoundry = lBound;
    rightBoundry = rBound;
    change_x = 2;
  }

  public void update() {
    super.update();
    if (getLeft() <= leftBoundry) {
      setLeft(leftBoundry);
      change_x *= -1;
    } else if (getRight() >= rightBoundry) {
      setRight(rightBoundry);
      change_x *= -1;
    }
  }
}
