BattleGround[][] battleGround = new BattleGround[30][30];
int battleTime;
int turn ;
int rank = 0;
int scene;
int pointor;
int howManySelectedPlayer;
static int member = 8;
Player[] playerList;
Player[] selectedPlayer;
PImage[] playerIcon;
PFont font;
static int[][] weaponStatus= {{0,0,0}, {20, 2,2 }, {30, 2,3 }, {25, 3,3 }, {0, 0,0}, {0, 0,0}, {0, 0,0}, {0, 0,0}, {0, 0,0}, {15, 0,0}};
static int[] itemStatus  ={0, 10, 25, 15, 0, 0, 0, 0, 0, 5};


void setup() {
  size(800, 800);
  background(255);
  frameRate(60);
  font =loadFont("IPAPGothic-32.vlw");
  textFont(font, 32);
  battleTime = 0;
  turn = 0;
  scene = 0;
  pointor = 0;
  howManySelectedPlayer = 0;
  for (int i = 0; i<battleGround.length; i++) {
    for (int j = 0; j<battleGround.length; j++) {
      battleGround[i][j] = new BattleGround();
    }
  }
  initializingBattleGround(battleGround);
  spownningItem(battleGround);
  playerList = new Player[20];
  selectedPlayer = new Player[20];
  playerIcon = new PImage[20];
  for (int i= 0; i <20; i++) {
    playerList[i] = null;
    selectedPlayer[i] = null;
    playerIcon[i] = null;
  }
/*write here */
  playerList[0] = new randomAI();
  playerList[1] = new randomAI();
  playerList[2] = new randomAI();
  playerList[10] = new randomAI();
  //playerList[i] = new sampleAI();

/*write here*/

  for (int i = 0; i<20; i++) {
    if (playerList[i] != null) {
      playerList[i].img.resize(width/10, height/10);
    }
  }
}

void draw() {
  if (scene == 0 ) {
    background(255);
    textSize(50);
    fill(#000000);
    textAlign(CENTER,CENTER);
    text("PUEC", width/2, height/2);
    text("PRESS ANY KEY",width/2,height*2/3);
    textAlign(LEFT);
    textSize(16);
    text("version 1.0",0,16);
    battleTime = 0;
    turn = 0;
    howManySelectedPlayer = 0;
  } else
    if (scene == 1) {
      textSize(50);
      stroke(0);
      background(128);
      //draw playerList
      for (int i = 0; i<20; i++) {
        // 上段
        if (i<10) {
          fill(255);
          rect(i*width/10, height*2/3-height/10, width/10, height/10);
          if (playerList[i] != null) {
            image(playerList[i].img, i*width/10, height*2/3-height/10);
          }
          //下段
        } else {
          fill(255);
          rect((i-10)*width/10, height*2/3, width/10, height/10);
          if (playerList[i] != null) {
            image(playerList[i].img, (i-10)*width/10, height*2/3);
          }
        }
      }
      stroke(#FF0000);
      strokeWeight(5);
      fill(0, 0);
      if (pointor < 10) {
        rect(pointor*width/10, height*2/3 -height/10, width/10, height/10, 5);
      } else {
        rect((pointor-10)*width/10, height*2/3, width/10, height/10, 5);
      }
      //draw selected player
      fill(255);
      stroke(0);
      for (int i = 0; i<8; i++) {
        rect((i+1)*width/10, height/3, width/10, height/10);
        if (selectedPlayer[i] != null) {
          image(selectedPlayer[i].img, (i+1)*width/10, height/3);
        }
      }
      text(howManySelectedPlayer, width/2, height/2);
    } else if (scene == 2) {
      background(255);
      stroke(0);
      strokeWeight(1);
      // drrawing map
      for (int i = 0; i<battleGround.length; i++) {
        for (int j = 0; j<battleGround.length; j++) {
          switch( battleGround[i][j].structure) {
          case 0:
            fill(#A0FFA0);
            break;
          case 1:
            fill(#FF0000);
            break;
          case 2:
            fill(#0000FF);
            break;
          default:
            fill(#FFFFFF);
            break;
          }
          rect(i*width/40, j*height/40, width/40, height/40);
          if (battleGround[i][j].bullet[0] != 0) {
            fill(#FF0000);
            ellipse(i*width/40+width/80, j*height/40+height/80, width/80, height/80);
          }
          // 毒の描写
          if (battleGround[i][j].poison == 1) {
            fill(#A901DB, 100);
            rect(i*width/40, j*height/40, width/40, height/40);
          } else if (battleGround[i][j].poisonCheck == 1) {
            fill(#F000F0, 100);
            rect(i*width/40, j*height/40, width/40, height/40);
          }
        }
      }

      for (int i = 0; i<member; i++) {
        //右側のメンバーリストの描写
        fill(255);
        rect(width*3/4, i*height/(member+1), width/4, height/(member+1));
        image(selectedPlayer[i].img, width*3/4, i*height/(member+1));
        fill(0);
        textSize(height*3/160);
        text(selectedPlayer[i].AIname, width*3/4+width/10, i*height/(member+1)+height/50);
        fill(255, 0, 0);
        rect(width*17/20, i*height/(member+1)+height/45, width/7, height/50);
        if (selectedPlayer[i].hp > 0) {
          fill(60, 250, 60);
          rect(width*3/4+width/10, i*height/(member+1)+height/45, (width/7)*(float(selectedPlayer[i].hp)/100), height/50);
        }
        textSize(height*3/160);
        fill(0);
        text("x:" +selectedPlayer[i].x +"y:" + selectedPlayer[i].y, width*17/20, i*height/(member+1)+height/15);
        switch(selectedPlayer[i].getWeapon()) {
        case 0:
          text("武器:なし", width*17/20, i*height/(member+1)+height/15+height*3/160);
          break;
        case 1:
          text("武器:ハンドガン", width*17/20, i*height/(member+1)+height/15+height*3/160);
          break;
        case 2:
          text("武器:ショットガン", width*17/20, i*height/(member+1)+height/15+height*3/160);
          break;
        case 3:
          text("武器:ライフル", width*17/20, i*height/(member+1)+height/15+height*3/160);
          break;
        case 9:
          text("武器:フライパン", width*17/20, i*height/(member+1)+height/15+height*3/160);
          break;
        default:
          text("武器:?", width*17/20, i*height/(member+1)+height/15+height*3/160);
        }
        switch(selectedPlayer[i].getItem()) {
        case 0:
          text("アイテム:なし", width*17/20, i*height/(member+1)+height/15+height*3/80);
          break;
        case 1:
          text("アイテム:包帯", width*17/20, i*height/(member+1)+height/15+height*3/80);
          break;
        case 2:
          text("アイテム:救急キット", width*17/20, i*height/(member+1)+height/15+height*3/80);
          break;
        case 3:
          text("アイテム:鎮痛剤", width*17/20, i*height/(member+1)+height/15+height*3/80);
          break;
        case 9:
          text("アイテム:ちくわ", width*17/20, i*height/(member+1)+height/15+height*3/80);
          break;
        default:
          text("アイテム:?", width*17/20, i*height/(member+1)+height/15+height*3/80);
        }
        if (!selectedPlayer[i].live) {
          fill(0, 70);
          rect(width*3/4, i*height/(member+1), width/4, height/(member+1));
          fill(#FFFF00);
          textSize(height/(member+1)-height/15);
          text(selectedPlayer[i].getRank(), width*3/4+width/7, i*height/(member+1)+height/17);
        }
        //マップ上のメンバーの位置の描写
        if (turn > 0) {
          image(playerIcon[i], selectedPlayer[i].x*width/40, selectedPlayer[i].y*height/40);
        }
      }
      if (battleTime > 60 && battleTime % 600 == 0) {
        startingTurn();
        for (int i =0; i <member; i++) {
          if (turn==0) {
            playerIcon[i] = loadImage(selectedPlayer[i].AIname+ ".png");
            playerIcon[i].resize(width/40, height/40);
            selectedPlayer[i].fallingAt(int(random(battleGround.length-1)), int(random(battleGround.length-1)));
            selectedPlayer[i].setHp(100);
            selectedPlayer[i].live = true;
            selectedPlayer[i].weapon = 3;
            selectedPlayer[i].item = 9;
            selectedPlayer[i].rank = 0;
          } else {
            // turn > 0 以降のプレイヤーの行動
            if (selectedPlayer[i].live) {
              switch(selectedPlayer[i].ai()) {
              case 1:
                selectedPlayer[i].moveN();
                break;
              case 2:
                selectedPlayer[i].moveS();
                break;
              case 3:
                selectedPlayer[i].moveW();
                break;
              case 4:
                selectedPlayer[i].moveE();
                break;
              case 5:
                selectedPlayer[i].pickUpWeapon();
                break;
              case 6:
                selectedPlayer[i].pickUpItem();
                break;
              case 7:
                selectedPlayer[i].useItem();
                break;
              case 8:
                selectedPlayer[i].shootWeaponN(i);
                break;
              case 9:
                selectedPlayer[i].shootWeaponS(i);
                break;
              case 10:
                selectedPlayer[i].shootWeaponW(i);
                break;
              case 11:
                selectedPlayer[i].shootWeaponE(i);
                break;
              default:
              }
            }
          }
        }
        endingTurn();
        turn++;
      }
      battleTime += 10;
      fill(#000000);
      textSize(width/40);
      text("turn:" +turn, 0, height*3/4+width/40);
    } else if (scene == 3) {
      stroke(0);
      strokeWeight(1);
      // drrawing map
      for (int i = 0; i<battleGround.length; i++) {
        for (int j = 0; j<battleGround.length; j++) {
          switch( battleGround[i][j].structure) {
          case 0:
            fill(#A0FFA0);
            break;
          case 1:
            fill(#FF0000);
            break;
          case 2:
            fill(#0000FF);
            break;
          default:
            fill(#FFFFFF);
            break;
          }
          rect(i*width/40, j*height/40, width/40, height/40);
          // 毒の描写
          if (battleGround[i][j].poison == 1) {
            fill(#A901DB, 100);
            rect(i*width/40, j*height/40, width/40, height/40);
          } else if (battleGround[i][j].poisonCheck == 1) {
            fill(#F000F0, 100);
            rect(i*width/40, j*height/40, width/40, height/40);
          }
        }
      }
      for (int i = 0; i<member; i++) {
        //右側のメンバーリストの描写
        fill(255);
        rect(width*3/4, i*height/(member+1), width/4, height/(member+1));
        image(selectedPlayer[i].img, width*3/4, i*height/(member+1));
        fill(0);
        textSize(height*3/160);
        text(selectedPlayer[i].AIname, width*3/4+width/10, i*height/(member+1)+height/50);
        fill(255, 0, 0);
        rect(width*17/20, i*height/(member+1)+height/45, width/7, height/50);
        if (selectedPlayer[i].hp > 0) {
          fill(60, 250, 60);
          rect(width*3/4+width/10, i*height/(member+1)+height/45, (width/7)*(float(selectedPlayer[i].hp)/100), height/50);
        }
        textSize(height*3/160);
        fill(0);
        text("x:" +selectedPlayer[i].hp +"y:" + selectedPlayer[i].y, width*17/20, i*height/(member+1)+height/15);
        switch(selectedPlayer[i].getWeapon()) {
        case 0:
          text("武器:なし", width*17/20, i*height/(member+1)+height/15+height*3/160);
          break;
        case 1:
          text("武器:ハンドガン", width*17/20, i*height/(member+1)+height/15+height*3/160);
          break;
        case 2:
          text("武器:ショットガン", width*17/20, i*height/(member+1)+height/15+height*3/160);
          break;
        case 3:
          text("武器:ライフル", width*17/20, i*height/(member+1)+height/15+height*3/160);
          break;
        case 9:
          text("武器:フライパン", width*17/20, i*height/(member+1)+height/15+height*3/160);
          break;
        default:
          text("武器:?", width*17/20, i*height/(member+1)+height/15+height*3/160);
        }
        switch(selectedPlayer[i].getItem()) {
        case 0:
          text("アイテム:なし", width*17/20, i*height/(member+1)+height/15+height*3/80);
          break;
        case 1:
          text("アイテム:包帯", width*17/20, i*height/(member+1)+height/15+height*3/80);
          break;
        case 2:
          text("アイテム:救急キット", width*17/20, i*height/(member+1)+height/15+height*3/80);
          break;
        case 3:
          text("アイテム:鎮痛剤", width*17/20, i*height/(member+1)+height/15+height*3/80);
          break;
        case 9:
          text("アイテム:ちくわ", width*17/20, i*height/(member+1)+height/15+height*3/80);
          break;
        default:
          text("アイテム:?", width*17/20, i*height/(member+1)+height/15+height*3/80);
        }
        if (!selectedPlayer[i].live) {
          fill(0, 70);
          rect(width*3/4, i*height/(member+1), width/4, height/(member+1));
          fill(#FFFF00);
          textSize(height/(member+1)-height/15);
          text(selectedPlayer[i].getRank(), width*3/4+width/7, i*height/(member+1)+height/17);
        }
        //マップ上のメンバーの位置の描写
        if (turn > 0) {
          image(playerIcon[i], selectedPlayer[i].x*width/40, selectedPlayer[i].y*height/40);
        }
      }
      for (int i = 0; i<member; i++) {
        if (selectedPlayer[i].live) {
          textSize(48);
          fill(#FFFF00);
          text("Winner:" + selectedPlayer[i].AIname, width/4-width/8, height*3/8);
          image(selectedPlayer[i].img, width/4+width/20, height*3/8+16);
        }
      }
    }
}

void startingTurn() {

  for (int i = 0; i<battleGround.length; i++) {
    for (int j = 0; j<battleGround.length; j++) {
      if (turn >= 15 && turn%10 >= 5) {
        spreadingPoison(battleGround, i, j);
      }
      battleGround[i][j].bullet[0] = 0;
      battleGround[i][j].bullet[1] = 0;
      battleGround[i][j].battleSound = 0;
    }
  }

  for (int i = 0; i<member; i++) {
    if (selectedPlayer[i].hp <= 0 && selectedPlayer[i].live ) {
      selectedPlayer[i].setLive(false);
      selectedPlayer[i].rank = member -rank;
      rank++;
    }
  }
  if (rank == 7) {
    scene = 3;
  }
}


void endingTurn() {
  for (int i = 0; i<battleGround.length; i++) {
    for (int j = 0; j<battleGround.length; j++) {
      if (turn >= 14 && turn%10 >=4) {
        checkPoison(battleGround, i, j);
      }
    }
  }
  for (int i = 0; i<member; i++) {
    if (battleGround[selectedPlayer[i].getX()][selectedPlayer[i].getY()].poison == 1 && selectedPlayer[i].live) {
      selectedPlayer[i].decreasingHp(10);
    }
    if (battleGround[selectedPlayer[i].getX()][selectedPlayer[i].getY()].bullet[1] != int(i)+1 && selectedPlayer[i].live) {
      selectedPlayer[i].decreasingHp(weaponStatus[battleGround[selectedPlayer[i].getX()][selectedPlayer[i].getY()].bullet[0]][0]);
    }
    if (selectedPlayer[i].hp <= 0 && selectedPlayer[i].live) {
      selectedPlayer[i].setLive(false);
      selectedPlayer[i].rank = member -rank;
      rank ++;
    }
    if (selectedPlayer[i].reloadTime > 0){
      selectedPlayer[i].reloadTime --;
    }
  }
}

void keyPressed() {
  switch(scene) {
  case 0:
    scene = 1;
    break;
  case 1:
    if (keyCode == SHIFT) {
      scene = 2;
    } else if (keyCode == UP) {
      if (pointor < 10) {
        pointor += 10;
      } else {
        pointor -= 10;
      }
    } else if (keyCode == DOWN) {
      if (pointor < 10) {
        pointor += 10;
      } else {
        pointor -= 10;
      }
    } else if (keyCode == LEFT) {
      if (pointor == 0 || pointor == 10) {
        pointor += 9;
      } else {
        pointor -= 1;
      }
    } else if (keyCode == RIGHT) {
      if (pointor == 9 || pointor == 19) {
        pointor -= 9;
      } else {
        pointor += 1;
      }
    } else if (key == 'z') {
      if (howManySelectedPlayer < 8  && playerList[pointor] != null) {
        selectedPlayer[howManySelectedPlayer] = playerList[pointor].clone();
        howManySelectedPlayer ++;
      } else if (howManySelectedPlayer == 8) {
        scene = 2;
      }
    } else if (key == 'x') {
      if (howManySelectedPlayer > 0) {
        selectedPlayer[howManySelectedPlayer-1] = null;
        howManySelectedPlayer --;
      } else {
        scene = 0;
      }
    }
    break;
  case 3:
    initializingBattleGround(battleGround);
    for (int i= 0; i<member; i++) {
      selectedPlayer[i]= null;
    }
    howManySelectedPlayer = 0;
    rank = 0;
    scene = 1;
    break;
  }
}