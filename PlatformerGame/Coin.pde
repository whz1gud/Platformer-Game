public class Coin extends AnimatedSprite {
  public Coin(PImage img, float scale) {
    super(img, scale);
    standNeutral = new PImage[8];
    for (int i = 0; i < 8; i++) {
      standNeutral[i] = loadImage("data/Coins/coin_0" + nf(i + 1, 1) + ".png");
    }
    currentImages = standNeutral;
  }
}
