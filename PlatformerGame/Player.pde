public class Player extends AnimatedSprite {
  int lives;
  boolean onPlatform, inPlace;
  PImage[] standLeft;
  PImage[] standRight;
  PImage[] jumpLeft;
  PImage[] jumpRight;
  public Player(PImage img, float scale) {
    super(img, scale);
    center_y = 2906;
    center_x = 81;

    standLeft = new PImage[2];
    standRight = new PImage[2];
    jumpLeft = new PImage[2];
    jumpRight = new PImage[2];
    moveLeft = new PImage[2];
    moveRight = new PImage[2];

    standLeft[0] = loadImage("data/Player/player_standLeft.png");
    standLeft[1] = loadImage("data/Player/player_standLeft.png");
    standRight[0] = loadImage("data/Player/player_standRight.png");
    standRight[1] = loadImage("data/Player/player_standRight.png");
    jumpLeft[0] = loadImage("data/Player/player_jumpLeft.png");
    jumpLeft[1] = loadImage("data/Player/player_jumpLeft.png");
    jumpRight[0] = loadImage("data/Player/player_jumpRight.png");
    jumpRight[1] = loadImage("data/Player/player_jumpRight.png");
    moveLeft[0] = loadImage("data/Player/player_walkLeft1.png");
    moveLeft[1] = loadImage("data/Player/player_walkLeft2.png");
    moveRight[0] = loadImage("data/Player/player_walkRight1.png");
    moveRight[1] = loadImage("data/Player/player_walkRight2.png");
    currentImages = standRight;

    lives = 1;
    direction = FACING_RIGHT;
    onPlatform = true;
    inPlace = true;
  }

  @Override
    public void updateAnimation() {
    onPlatform = isOnPlatform(this, platforms);
    inPlace = change_x == 0 && change_y == 0;
    super.updateAnimation();
  }

  @Override
    public void selectDirection() {
    if (change_x > 0) {
      direction = FACING_RIGHT;
    } else if (change_x < 0) {
      direction = FACING_LEFT;
    }
  }

  @Override
    public void selectCurrentImages() {
    if (direction == FACING_RIGHT) {
      if (inPlace) {
        currentImages = standRight;
      } else if (!onPlatform) {
        currentImages = jumpRight;
      } else {
        currentImages = moveRight;
      }
    }
    if (direction == FACING_LEFT) {
      if (inPlace) {
        currentImages = standLeft;
      } else if (!onPlatform) {
        currentImages = jumpLeft;
      } else {
        currentImages = moveLeft;
      }
    }
  }
}
