final static float MOVE_SPEED = 4;
final static float SPRITE_SCALE = 50.0/70;
final static float SPRITE_SIZE = 50;
final static float COIN_SCALE = 25.0/48;
final static float GRAVITY = 0.4;
final static float JUMP_SPEED = 12;
final static float MARGIN_LEFT = 400;
final static float MARGIN_RIGHT = 400;
final static float MARGIN_VERTICAL = 20;
final static float GROUND = 3000;

final static int NEUTRAL = 0;
final static int FACING_RIGHT = 1;
final static int FACING_LEFT = 2;

Player player;
//Enemy enemy;

ArrayList<Sprite> platforms;
ArrayList<Coin> coins;
boolean [] keys;

PImage coin, enemyImg, playerImg, bg, purp, tiles;
float originX = 0, originY = 0;
boolean isGameOver, editor = false;
int score, numCoins;
int curMap = 1;

int mapWidth = 40;
int mapHeight = 60;
int id;

int[][] currentMap = new int[60][40];
PImage[] tileArray;

//Pseudo code variables

TextField textField;

int frameCounter = 0;
final int FRAMES_PER_COMMAND = 60;  // Number of frames to wait before executing the next command
String command = "";
int remainingStepsR = 0;
int remainingStepsL = 0;
String[] commandList;
int currentCommandIndex = 0;

void setup() {
  size(800, 600);
  imageMode(CENTER);
  frameRate(60);

  commandList = loadStrings("commandsCopy.txt");
  textField = new TextField(originX + 14, originY + 40);

  isGameOver = false;
  score = 0;

  playerImg = loadImage("data/Player/player_standRight.png");
  player = new Player(playerImg, 0.8);

  platforms = new ArrayList<Sprite>();
  coins = new ArrayList<Coin>();
  keys = new boolean[65537];

  tiles = loadImage("data/Tiles/Spritesheet/sheet.png");
  tileArray = new PImage[100];
  createTileArray();

  coin = loadImage("data/Coins/coin_01.png");
  bg = loadImage("data/bg.png");

  if (curMap == 1) {
    loadLevel("data/Levels/level1.csv", currentMap);
    numCoins = coins.size();
  } else if (curMap == 2) {
    loadLevel("data/Levels/level2.csv", currentMap);
    numCoins = coins.size();
  } else {
    loadLevel("data/Levels/level3.csv", currentMap);
    numCoins = coins.size();
  }
}

void draw() {
  if (editor) {
    mapEditor();
  } else {
    image(bg, 0, 20);
    textField.display();
    scroll();

    displayAll();

    if (!isGameOver) {
      if (frameCounter >= FRAMES_PER_COMMAND) {
        if (currentCommandIndex < commandList.length) {
          executeCommand(commandList[currentCommandIndex]);
          currentCommandIndex++;
        }
        frameCounter = 0;  // Reset the frame counter
      } else {
        frameCounter++;  // Increment the frame counter
      }

      updateAll();
      checkDeath();
      coinCollection(player, coins);
    }
  }
}

void loadLevel(String filename, int[][] numberMap)
{
  String[] map = loadStrings(filename);

  for (int i = 0; i < map.length; ++i)
  {
    String[] line = split(map[i], ",");

    for (int j = 0; j < line.length; ++j)
    {
      numberMap[i][j] = int(line[j]);
      if (int(line[j]) != 0 && int(line[j]) != -1)
      {
        Sprite s = new Sprite(tileArray[int(line[j])], SPRITE_SCALE);
        s.center_x = SPRITE_SIZE / 2 + j * SPRITE_SIZE;
        s.center_y = SPRITE_SIZE / 2 + i * SPRITE_SIZE;
        s.tileNumber = i * mapWidth + j;
        platforms.add(s);
      } else if (int(line[j]) == -1) {
        Coin c = new Coin(coin, COIN_SCALE);
        c.center_x = SPRITE_SIZE / 2 + j * SPRITE_SIZE;
        c.center_y = SPRITE_SIZE / 2 + i * SPRITE_SIZE;
        c.tileNumber = i * mapWidth + j;
        coins.add(c);
      }
    }
  }
}

public void createTileArray() {
  PImage temp;

  for (int i = 0; i < 5; ++i)
  {
    for (int g = 0; g < 5; ++g)
    {
      temp = tiles.get(70 * g, 70 * i, 70, 70);
      tileArray[i * 5 + g + 1] = temp;
    }
  }
}

public void displayAll() {
  for (Sprite s : platforms)
    s.display();

  for (Coin c : coins) {
    c.display();
  }
  player.display();
  //enemy.display();
  
  //textField.display();

  fill(255, 0, 0);
  textSize(26);
  text("Coins: " + score + "/" + numCoins, originX + 14, originY + 26);

  if (isGameOver) {
    if (player.lives == 0) {
      text("YOU DIED!", originX + width/2 - 100, originY + height/2);
      text("Press SPACE to restart!", originX + width/2 - 100, originY + height/2 + 40);
    } else if (curMap == 4) {
      text("YOU WIN!", originX + width/2 - 100, originY + height/2);
      text("Press SPACE to play again!", originX + width/2 - 100, originY + height/2 + 40);
    } else {
      text("Press SPACE to advance!", originX + width/2 - 100, originY + height/2 + 40);
    }
  }
}

public void updateAll() {
  player.updateAnimation();
  resolveCollisions(player, platforms);
  //enemy.update();
  //enemy.updateAnimation();
  for (Coin c : coins) {
    c.updateAnimation();
  }
}

public void checkDeath() {
  //boolean collideEnemy = checkCollision(player, enemy);
  boolean fallOffCliff = player.getBottom() > GROUND;

  if (fallOffCliff) {
    player.lives--;
    if (player.lives == 0) {
      isGameOver = true;
    }
  }

  //if (collideEnemy || fallOffCliff) {
  //  player.lives--;
  //  if (player.lives == 0) {
  //    isGameOver = true;
  //  }
  //}
}

public void move()
{
  float xDelta = 0;
  float yDelta;
  if (keys['a'])
    xDelta = -MOVE_SPEED;
  if (keys['d'])
    xDelta = MOVE_SPEED;
  if (keys[' '] && isOnPlatform(player, platforms)) {
    yDelta = -JUMP_SPEED;
    player.change_y = yDelta;
  }

  player.change_x = xDelta;
  if (remainingStepsR > 0) {
    player.change_x += MOVE_SPEED;
    remainingStepsR--;
  }
  if (remainingStepsL > 0) {
    player.change_x -= MOVE_SPEED;
    remainingStepsL--;
  }
}

public void coinCollection(Player p, ArrayList<Coin> coins) {
  ArrayList<Coin> collisionList = checkCollisionList(p, coins);
  if (collisionList.size() > 0) {
    for (Coin c : collisionList) {
      coins.remove(c);
      score += 1;
    }
  }
  if (coins.size() == 0) {
    isGameOver = true;
    curMap++;
  }
}

public void resolveCollisions(Sprite p, ArrayList<Sprite> objects) {
  move();
  p.change_y += GRAVITY;
  p.center_y += p.change_y;
  ArrayList<Sprite> collisionList = checkCollisionList(p, objects);
  if (collisionList.size() > 0) {
    Sprite collided = collisionList.get(0);

    if (p.change_y > 0) { //krenta zemyn
      p.setBottom(collided.getTop());
    } else if (p.change_y < 0) {
      p.setTop(collided.getBottom());
    }
    p.change_y = 0;
  }

  p.center_x += p.change_x;
  collisionList = checkCollisionList(p, objects);
  if (collisionList.size() > 0) {
    Sprite collided = collisionList.get(0);

    if (p.change_x > 0) { //krenta zemyn
      p.setRight(collided.getLeft());
    } else if (p.change_x < 0) {
      p.setLeft(collided.getRight());
    }
  }
}

//Tikrinam ar vienas objektas collidina su kitu. Pvz playeris su siena.
public boolean checkCollision(Sprite s1, Sprite s2) {

  boolean noXoverlap = s1.getLeft() >= s2.getRight() || s1.getRight() <= s2.getLeft();
  boolean noYoverlap = s1.getBottom() <= s2.getTop() || s1.getTop() >= s2.getBottom();

  if (noXoverlap || noYoverlap) {
    return false;
  } else
    return true;
}

public boolean checkCollision(Player p, Coin c) {

  boolean noXoverlap = p.getLeft() >= c.getRight() || p.getRight() <= c.getLeft();
  boolean noYoverlap = p.getBottom() <= c.getTop() || p.getTop() >= c.getBottom();

  if (noXoverlap || noYoverlap) {
    return false;
  } else
    return true;
}

// sudarom collision lista, kur playeris vienas object su kitais objects collidina. pvz player su sienomis ar viena siena.
public ArrayList<Sprite> checkCollisionList(Sprite s, ArrayList<Sprite> list) {
  ArrayList<Sprite> collisionList = new ArrayList<Sprite>();
  for (Sprite spr : list) {
    if (checkCollision(s, spr)) {
      collisionList.add(spr);
    }
  }
  return collisionList;
}

public ArrayList<Coin> checkCollisionList(Player p, ArrayList<Coin> list) {
  ArrayList<Coin> collisionList = new ArrayList<Coin>();
  for (Coin c : list) {
    if (checkCollision(p, c)) {
      collisionList.add(c);
    }
  }
  return collisionList;
}

public boolean isOnPlatform(Sprite p, ArrayList<Sprite> platforms) {
  p.center_y += 5;
  ArrayList<Sprite> collisionList = checkCollisionList(p, platforms);
  p.center_y -= 5;

  if (collisionList.size() > 0) {
    return true;
  } else
    return false;
}

public void scroll() {
  float leftBoundry = originX + MARGIN_LEFT;
  if (player.getLeft() < leftBoundry) {
    originX -= leftBoundry - player.getLeft();
  }

  float rightBoundry = originX + width - MARGIN_RIGHT;
  if (player.getRight() > rightBoundry) {
    originX += player.getRight() - rightBoundry;
  }

  float bottomBoundry = originY + height - MARGIN_VERTICAL;
  if (player.getBottom() > bottomBoundry) {
    originY += player.getBottom() - bottomBoundry;
  }

  float topBoundry = originY + MARGIN_VERTICAL;
  if (player.getTop() < topBoundry) {
    originY -= topBoundry - player.getTop();
  }
  translate(-originX, -originY);
}

void executeCommand(String command) {
  command = command.trim().toUpperCase(); // Trim whitespace and convert to uppercase for consistent comparison

  if (command.equals("ML")) {
    player.change_x = -MOVE_SPEED;
  } else if (command.equals("MR")) {
    player.change_x = MOVE_SPEED;
  } else if (command.equals("MR10")) {
    remainingStepsR = 10;
  } else if (command.equals("ML10")) {
    remainingStepsL = 10;
  } else if (command.equals("MR50")) {
    remainingStepsR = 50;
  } else if (command.equals("ML50")) {
    remainingStepsL = 50;
  } else if (command.equals("JMR25")) {
    if (isOnPlatform(player, platforms)) {
      player.change_y = -JUMP_SPEED;
      remainingStepsR = 25;
    }
  } else if (command.equals("JML25")) {
    if (isOnPlatform(player, platforms)) {
      player.change_y = -JUMP_SPEED;
      remainingStepsL = 25;
    }
  } else if (command.equals("JMR50")) {
    if (isOnPlatform(player, platforms)) {
      player.change_y = -JUMP_SPEED;
      remainingStepsR = 50;
    }
  } else if (command.equals("JML50")) {
    if (isOnPlatform(player, platforms)) {
      player.change_y = -JUMP_SPEED;
      remainingStepsL = 50;
    }
  } else {
    println("Unknown command: " + command); // If the command is not recognized, print an error message
  }
}

void keyPressed()
{
  keys[key] = true;
  if (isGameOver && key == ' ') {
    if (curMap == 4) {
      curMap = 1;
      setup();
      originX = 0;
      originY = 0;
    } else {
      setup();
      originX = 0;
      originY = 0;
    }
  }
  if (key == 'e') {
    editor = true;
  }
}

void keyReleased()
{
  keys[key] = false;
}

void keyTyped() {
  if (textField.isSelected()) {
    textField.addCharacter(key);
  }
}

void mouseClicked() {
  if (mouseX >= textField.x && mouseX <= textField.x + 200 &&
      mouseY >= textField.y && mouseY <= textField.y + 30) {
    // If the mouse is clicked inside the text field, select it
    textField.select();
  } else {
    // If the mouse is clicked outside the text field, deselect it
    textField.deselect();
  }
}
