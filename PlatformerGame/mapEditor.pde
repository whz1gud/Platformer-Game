public void mapEditor() {
  background(#000000);

  int tempCol = 0;
  int tempRow = 0;
  Sprite newTile;
  Coin newCoin;

  int curMapBegX = 400;

  rect(0, 350, 70, 70);
  if (mouseX > 0 && mouseX < 70 && mouseY > 350 && mouseY < 420 && mousePressed) {
    id = 0;
  }

  image(coin, 105, 385, 70, 70);
  if (mouseX > 105 && mouseX < 175 && mouseY > 385 && mouseY < 455 && mousePressed) {
    id = -1;
  }

  if (id == -1) {
    image(coin, mouseX, mouseY, 40, 40);
  }

  image(tiles, tiles.width/2, tiles.height/2);
  fill(#FFFFFF);
  if (mouseY > 0 && mouseY < tiles.height && mouseX > 0 && mouseX < tiles.width && mousePressed) {
    tempCol = int(mouseX / 70);
    tempRow  = int(mouseY / 70);
    id = tempRow * 5 + tempCol + 1;
  }
  if (id != 0 && id != -1) {
    image(tileArray[id], mouseX, mouseY, 40, 40);
  }

  textSize(30);
  text("save", 275, 400);

  if (mouseX > 275 && mouseX < 335 && mouseY > 380 && mouseY < 400 && mousePressed) {
    editor = !editor;
    writeTable();
  }

  for (int i = 0; i < mapHeight; ++i) {
    for (int j = 0; j < mapWidth; ++j) {
      if (currentMap[i][j] == 0) {
        fill(255);
        rect(j * 10 + curMapBegX, i * 10, 10, 10);
      } else if (currentMap[i][j] == -1) {
        image(coin, j * 10 + 5 + curMapBegX, i * 10 + 5, 10, 10);
      } else {
        image(tileArray[currentMap[i][j]], j * 10 + 5 + curMapBegX, i * 10 + 5, 10, 10);
      }
    }
  }

  if (mouseX > curMapBegX && mouseX < 800 && mouseY > 0 && mouseY < 600 && mousePressed) {
    int selectedTileX = (mouseX - curMapBegX) / 10;
    int selectedTileY = mouseY / 10;

    if (id != 0 && id != -1) {
      currentMap[selectedTileY][selectedTileX] = id;
      newTile = new Sprite(tileArray[currentMap[selectedTileY][selectedTileX]], SPRITE_SCALE);
      newTile.tileNumber = selectedTileY * mapWidth + selectedTileX;
      newTile.center_x = selectedTileX * SPRITE_SIZE + 25;
      newTile.center_y = selectedTileY * SPRITE_SIZE + 25;
      platforms.add(newTile);
    } else if (id == -1) {
      currentMap[selectedTileY][selectedTileX] = id;
      newCoin = new Coin(coin, COIN_SCALE);
      newCoin.center_x = selectedTileX * SPRITE_SIZE + 25;
      newCoin.center_y = selectedTileY * SPRITE_SIZE + 25;
      coins.add(newCoin);
      numCoins++;
    } else if (id == 0) {
      int tileToRemove = selectedTileY * mapWidth + selectedTileX;
      currentMap[selectedTileY][selectedTileX] = id;
      for (int i = 0; i < coins.size(); ++i) {
        Coin temp = coins.get(i);
        if (temp.tileNumber == tileToRemove) {
          coins.remove(i);
          numCoins--;
        }
      }
      for (int i = 0; i < platforms.size(); ++i) {
        Sprite temp = platforms.get(i);
        if (temp.tileNumber == tileToRemove) {
          platforms.remove(i);
        }
      }
    }
  }
}

public void writeTable()
{
  Table table = new Table();

  for (int i = 0; i < mapWidth; ++i)
    table.addColumn();

  for (int i = 0; i < mapHeight; ++i)
  {
    TableRow newRow = table.addRow();
    for (int j = 0; j < mapWidth; ++j)
      newRow.setInt(j, currentMap[i][j]);
  }
  saveTable(table, "data/Levels/level" + curMap + ".csv");
}
