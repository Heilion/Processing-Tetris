int BOARD_WIDTH = 10;
int BOARD_HEIGHT = 20;
float squareSize = 30;
Block[][] blocks = new Block[BOARD_HEIGHT][BOARD_WIDTH];
ArrayList[] possibleBlocks = new ArrayList[7];
ArrayList currentBlocks = new ArrayList();
boolean gameOver = false;

class Block {

  Block(int tempX, int tempY, color tempColor) {
    xPos = tempX;
    yPos = tempY;
    blockColor = tempColor;
  }

  void draw() {
    fill(blockColor);
    float tempX = (xPos * (squareSize + 2)) + 2;
    float tempY = (yPos * (squareSize + 2)) + 2;
    rect(tempX, tempY, squareSize, squareSize);
  }

  color blockColor;
  int xPos;
  int yPos;
}

void setup() {
  randomSeed(hour() + second() + millis());
  size(600, 800);
  setupPossibleBlocks();
  spawnBlocks();
}

void draw() {
  if (!gameOver) {
    if (frameCount % 8 == 0) {
    moveCurrentBlocksDown();
    }
    checkLines();
    background(30, 30, 30);
    pushMatrix();
    translate(100, 100);
    drawBoard();
    drawBlocks();
    drawCurrentBlocks();
    popMatrix();  
  } else {
    checkLines();
    background(30, 30, 30);
    pushMatrix();
    translate(100, 100);
    drawBoard();
    drawBlocks();
    popMatrix();
    fill(255);
    textSize(64);
    text("Game Over", (width / 2) - 200, height / 2);
  }
  
}

void drawBoard() {
  // Board background
  noStroke();
  fill(0, 0, 50);
  float boardWidth = BOARD_WIDTH * (squareSize + 2);
  float boardHeight = BOARD_HEIGHT * (squareSize + 2);
  rect(0, 0, boardWidth, boardHeight);

  stroke(60, 125, 255);
  strokeWeight(2);
  // Board grid
  // Horizontal line
  for (int i = 0; i <= BOARD_WIDTH; i++) {
    line(i * (squareSize + 2), 0, i * (squareSize + 2), boardHeight);
  }
  // Vertical line
  for (int i = 0; i <= BOARD_HEIGHT; i++) {
    line(0, i * (squareSize + 2), boardWidth, i * (squareSize + 2));
  }
}

void drawBlocks() {
  noStroke();
  for (int y = 0; y < BOARD_HEIGHT; y++) {
    for (int x = 0; x < BOARD_WIDTH; x++) {
      if (blocks[y][x] != null) {
        blocks[y][x].draw();
      }
    }
  }
}

void drawCurrentBlocks() {
  for (int i = 0; i < currentBlocks.size (); i++) {
    Block tempBlock = (Block) currentBlocks.get(i);
    if (tempBlock.yPos >= 0) {
      tempBlock.draw();
    }
  }
}

void moveCurrentBlocksDown() {
  for (int i = 0; i < currentBlocks.size (); i++) {
    Block tempBlock = (Block) currentBlocks.get(i);
    if (tempBlock.yPos + 1 >= 0) {
      if (tempBlock.yPos + 1 == BOARD_HEIGHT 
        || blocks[tempBlock.yPos + 1][tempBlock.xPos] != null) {
        lockCurrentBlocks();
        spawnBlocks();
        return;
      }
    }
  }
  for (int i = 0; i < currentBlocks.size (); i++) {
    Block tempBlock = (Block) currentBlocks.get(i);
    tempBlock.yPos++;
  }
}

void lockCurrentBlocks() {
  for (int i = 0; i < currentBlocks.size (); i++) {
    Block tempBlock = (Block) currentBlocks.get(i);
    if (tempBlock.yPos < 0) {
      gameOver = true;
      return;  
    }
    blocks[tempBlock.yPos][tempBlock.xPos] = tempBlock;
  }
  currentBlocks = null;
}

void spawnBlocks() {
  int index = int(random(possibleBlocks.length));
  currentBlocks = cloneBlocks(possibleBlocks[index]);
}

ArrayList cloneBlocks(ArrayList list) {
  ArrayList cloneList = new ArrayList();
  for (int i = 0; i < list.size (); i++) {
    Block tempBlock = (Block) list.get(i);
    cloneList.add(new Block(tempBlock.xPos, tempBlock.yPos, tempBlock.blockColor));
  }
  return cloneList;
}

void moveCurrentBlocks(int xDiff) {
  for (int i = 0; i < currentBlocks.size (); i++) {
    Block tempBlock = (Block) currentBlocks.get(i);
    if (tempBlock.yPos >= 0) {
      if (xDiff == 1) {
        if (tempBlock.xPos + 1 == BOARD_WIDTH 
          || blocks[tempBlock.yPos][tempBlock.xPos + 1] != null) {
          return;
        }
      } else {
        if (tempBlock.xPos - 1 < 0 
          || blocks[tempBlock.yPos][tempBlock.xPos - 1] != null) {
          return;
        }
      }
    }
  }
  for (int i = 0; i < currentBlocks.size (); i++) {
    Block tempBlock = (Block) currentBlocks.get(i);
    tempBlock.xPos += xDiff;
  }
}

void checkLines() {
  ArrayList linesToDelete = new ArrayList();
  for (int y = 0; y < BOARD_HEIGHT; y++) {
    boolean lineFull = true;
    for (int x = 0; x < BOARD_WIDTH; x++) {
      if (blocks[y][x] == null) {
        lineFull = false;
        break;
      }
    }
    if (lineFull) {
      linesToDelete.add(new Integer(y));
    }
  }
  if (linesToDelete.size() > 0) {
    deleteLines(linesToDelete);
  }
}

void deleteLines(ArrayList list) {
  for (int i = 0; i < list.size (); i++) {
    for (int x = 0; x < BOARD_WIDTH; x++) {
      blocks[(Integer)list.get(i)][x] = null;
    }
    for (int y = (Integer)list.get(i); y >= 0; y--) {
      for (int x = 0; x < BOARD_WIDTH; x++) {
        if (y - 1 < 0) {
          blocks[y][x] = null;
        } else {
          blocks[y][x] = blocks[y - 1][x];
          if (blocks[y][x] != null) {
            blocks[y][x].yPos++;
          }
        }
      }
    }
  }
  draw();
}

void setupPossibleBlocks() {
  ArrayList LBlock = new ArrayList();
  color navy = color(130, 130, 220);
  LBlock.add(new Block(4, -3, navy));
  LBlock.add(new Block(4, -2, navy));
  LBlock.add(new Block(5, -1, navy));
  LBlock.add(new Block(4, -1, navy));
  possibleBlocks[0] = LBlock;

  ArrayList JBlock = new ArrayList();
  color orange = color(255, 160, 0);
  JBlock.add(new Block(5, -3, orange));
  JBlock.add(new Block(5, -2, orange));
  JBlock.add(new Block(5, -1, orange));
  JBlock.add(new Block(4, -1, orange));
  possibleBlocks[1] = JBlock;

  ArrayList IBlock = new ArrayList();
  color cyan = color(0, 240, 240);
  IBlock.add(new Block(5, -4, cyan));
  IBlock.add(new Block(5, -3, cyan));
  IBlock.add(new Block(5, -1, cyan));
  IBlock.add(new Block(5, -2, cyan));
  possibleBlocks[2] = IBlock;

  ArrayList OBlock = new ArrayList();
  color yellow = color(120, 255, 0);
  OBlock.add(new Block(4, -2, yellow));
  OBlock.add(new Block(5, -2, yellow));
  OBlock.add(new Block(5, -1, yellow));
  OBlock.add(new Block(4, -1, yellow));
  possibleBlocks[3] = OBlock;

  ArrayList ZBlock = new ArrayList();
  color green = color(0, 230, 0);
  ZBlock.add(new Block(4, -2, green));
  ZBlock.add(new Block(5, -2, green));
  ZBlock.add(new Block(5, -1, green));
  ZBlock.add(new Block(6, -1, green));
  possibleBlocks[4] = ZBlock;

  ArrayList SBlock = new ArrayList();
  color red = color(230, 0, 30);
  SBlock.add(new Block(5, -2, red));
  SBlock.add(new Block(6, -2, red));
  SBlock.add(new Block(5, -1, red));
  SBlock.add(new Block(4, -1, red));
  possibleBlocks[5] = SBlock;

  ArrayList TBlock = new ArrayList();
  color pink = color(180, 0, 180);
  TBlock.add(new Block(5, -2, pink));
  TBlock.add(new Block(4, -1, pink));
  TBlock.add(new Block(5, -1, pink));
  TBlock.add(new Block(6, -1, pink));
  possibleBlocks[6] = TBlock;
}

void rotateCurrentBlock() {
  int coreX = ((Block) currentBlocks.get(2)).xPos;
  int coreY = ((Block) currentBlocks.get(2)).yPos;
  ArrayList tempBlocks = cloneBlocks(currentBlocks);
  for (int i = 0; i < tempBlocks.size(); i++) {
    Block tempBlock = (Block) tempBlocks.get(i);
    int diffX = coreX - tempBlock.xPos;
    int diffY = coreY - tempBlock.yPos;
    tempBlock.xPos = coreX + (diffY);
    tempBlock.yPos = coreY + (diffX * -1);
  }
  for (int i = 0; i < tempBlocks.size(); i++) {
    Block tempBlock = (Block) tempBlocks.get(i);
    if (tempBlock.xPos < 0 || tempBlock.xPos >= BOARD_WIDTH
    || tempBlock.yPos < 0 || tempBlock.yPos >= BOARD_HEIGHT
    || blocks[tempBlock.yPos][tempBlock.xPos] != null) {
       return;
    }
  }
  currentBlocks = tempBlocks;
}

void keyPressed() {
  switch (keyCode) {
  case LEFT:
    moveCurrentBlocks(-1);
    break;
  case RIGHT:
    moveCurrentBlocks(1);
    break;
  case DOWN:
    moveCurrentBlocksDown();
    break;
  case UP:
    rotateCurrentBlock();
    break;
  }
}

