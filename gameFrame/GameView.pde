
class MenuView extends ViewState {

  MenuView(GameManager gm) {
    super(gm);
    init();
  }

  void init() {
  }

  void mousePressed() {
    super.mousePressed();
  }

  void mouseReleased() {
    super.mouseReleased();
    gm.setGame();
  }

  void keyPressed(char key) {
    super.keyPressed(key);
    char S='s';
    if (key == S) {
      gm.setGame();
    }
  }

  void display() {
    super.display();
    background(BGCOLOR);
    PFont font = createFont("Meiryo", 32);
    textFont(font); //フォントの指定
    fill(255, 128, 0);
    textSize(24);
    text("シューティング", 30, 120);
    text("ゲーム（仮）", 30, 160);
    fill(255, 0, 255);
    textSize(18);
    text("Tap Start", 80, 200);
  }
}

//gameView

class GameView extends ViewState {

  BackGround bg;
  Player p;
  Enemies e;
  Effects efx;
  EffectDeads defx;
  Score sc; 
  Boss b;

  int stageNum=0;
  //flag
  Boolean isBossBattle=false;
  Boolean isStageClear=false;
  Boolean gameOver=false;

  //param
  int stageClearStart=0;
  int gameOverStart=0;

  //constant
  int stageClearFrame=200;
  int gameOverFrame=100;

  GameView(GameManager gm) {
    super(gm);
    bg=new BackGround();
    p=new Player();
    sc=new Score();

    init();		

  }

  void mousePressed() {
    super.mousePressed();
    if (gameOver) {
      gm.setGame();
      return;
    } else if (isStageClear) {
      init();
      return;
    }
    if (p.isDead) {
      return;
    }
    p.setShots();
  }

  void mouseReleased() {
    super.mouseReleased();
  }

  void keyPressed(char key) {
    super.keyPressed(key);
    char S='s';
    if (key == S) {
      if (gameOver) {
        gm.setOpening();
        return;
      } else if (isStageClear) {
        init();
        return;
      }
    }
  }  

  void init() {
    super.init();
    size(SCREEN_WIDTH, SCREEN_HEIGHT); 
    background(BGCOLOR);

    isBossBattle=false;
    isStageClear=false;
    stageClearStart=0;
    gameOverStart=0;
    stageNum++;
    e=new Enemies();
    efx=new Effects();
    defx=new EffectDeads();
    b=new Boss();
  }

  void update() {
    super.update();
    bg.update();
    p.update();
    e.update();
    if (isBossBattle) {
      b.update();
      hitTestShotBoss(p, b);
      hitTestPlayerBoss(p, b);
      hitTestPlayerBossShot(p, b);
    } 
    sceneUpdate(countNow);     
    hitTestPlayerShot(p, e);
    hitTestPlayer(p, e);
    hitTestPlayerEnemyShot(p, e);
    efx.update();
    defx.update();
    sc.update();
  }

  void display() {
    background(BGCOLOR);
    bg.display();
    //sceneUpdate(countNow);
//    if (!isStageClear) {
//      sceneUpdateBoss(countNow);
//    }

    p.display();
    e.display();

    if (isBossBattle) {
      b.display();
    }
    
    efx.display();
    defx.display();
    p.shotDisplay();
    //自機が死んで一定期間経ったらゲームオーバー
    int gameOverNow=frameCount-gameOverStart;
    int stageClearNow=frameCount-stageClearStart;
    if (gameOver && gameOverNow>=gameOverFrame) {
      stroke(0);
      fill(0, 0, 0, 170);
      rect(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
      PFont font = createFont("Meiryo", 32);
      textFont(font); //フォントの指定
      fill(255, 128, 0);
      textSize(24);
      text("GAME OVER", 40, 120);
      fill(255, 0, 255);
      textSize(18);
      text("Press S", 80, 200);
    } else if (isStageClear && stageClearNow>=stageClearFrame) {
      stroke(0);
      fill(0, 0, 0, 170);
      rect(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
      PFont font = createFont("Meiryo", 32);
      textFont(font); //フォントの指定
      fill(255, 128, 0);
      textSize(24);
      text("Stage Clear", 40, 120);
      fill(255, 0, 255);
      textSize(18);
      text("Tap NextStage", 80, 200);
    }
    sc.display();

    //stagenum
    fill(255, 128, 0);
    textSize(10);
    text("Stage " + stageNum, 5, 312);

    super.display();
  }

  //自機と敵の当たり判定
  void hitTestPlayer(Player p, Enemies target) {
    if (p.isDead) {
      return;
    }

    Enemy[] enemies=target.getEnemies();
    for (int i=0;i<enemies.length;i++) { 
      Enemy e=enemies[i];
      if (!e.visible) {
        continue;
      }

      float dx=p.position.x-e.position.x;
      float dy=p.position.y-e.position.y;
      float d= sqrt(dx*dx+dy*dy);
      if (d<(p._width/2)) {
        p.setDead();
        efx.setEffect(p.position);
        gameOverStart=frameCount;
        e.setDead(true);
        gameOver=true;
      }
    }
  }

  //敵の弾と自機の当たり判定
  void hitTestPlayerEnemyShot(Player p, Enemies target) {
    if (p.isDead) {
      return;
    }
    Enemy[] enemies=target.getEnemies();
    for (int j=0;j<enemies.length;j++) { 
      Enemy e=enemies[j];
      Shot[] shots=e.getShots();
      for (int i=0;i<shots.length;i++) {
        if (!shots[i].visible) {
          continue;
        }
        float dx=p.position.x-shots[i].position.x;
        float dy=p.position.y-shots[i].position.y;
        float d= sqrt(dx*dx+dy*dy);
        if (d<(p._width/2-4)) {
          p.setDead();
          defx.setEffect(p.position);
          gameOverStart=frameCount;
          shots[i].visible=false;
          gameOver=true;
          break;
        }
      }
      if (gameOver==true) {
        break;
      }
    }
  }

  //自分の弾と敵の当たり判定
  void hitTestPlayerShot(Player p, Enemies target) {
    Enemy[] enemies=target.getEnemies();
    Shot[] shots=p.getShots();
    for (int j=0;j<shots.length;j++) { 
      Shot s=shots[j];
      if (!s.visible) {
        continue;
      }
      for (int i=0;i<enemies.length;i++) {
        Enemy e=enemies[i];
        if (!e.visible) {
          continue;
        } else if (e.isNotHit) {
          continue;
        }
        float dx=e.position.x-s.position.x;
        float dy=e.position.y-s.position.y;
        float d= sqrt(dx*dx+dy*dy);
        if (d<(e._width/2)) {
          Boolean isDead=e.setDamage(1);
          if (isDead) {
            //efx.setEffect(e.position); 
            defx.setEffect(e.position);
            sc.addScore(e.score);
          }
          s.visible=false;
        }
      }
    }
  }

  void sceneUpdateBoss(int frame) {
    if (frame==100) {
      bossStart();
    }
    return;
  }

  //滴出現処理
  //todo　敵出現などスクリプト化したい。
  void sceneUpdate(int frame) {
    switch(frame) {
    case 50:
      e.addEnemy(ENEMY_TYPE1, 120, -30);
      break;
    case 100:
      e.addEnemy(ENEMY_TYPE2, 120, -30);
      break;
    case 200:
      e.addEnemy(ENEMY_TYPE2, 30, -30);
      e.addEnemy(ENEMY_TYPE2, 70, -30);
      e.addEnemy(ENEMY_TYPE2, 100, -30);
      e.addEnemy(ENEMY_TYPE2, 150, -30);
      break;
    case 400:
      e.addEnemy(ENEMY_TYPE2, 30, -30);
      e.addEnemy(ENEMY_TYPE2, 70, -30);
      e.addEnemy(ENEMY_TYPE2, 100, -30);
      e.addEnemy(ENEMY_TYPE2, 150, -30);
      break;  
    case 500:
      e.addEnemy(ENEMY_TYPE1, 100, -30);
      e.addEnemy(ENEMY_TYPE1, 140, -30);
      e.addEnemy(ENEMY_TYPE1, 180, -30);
      e.addEnemy(ENEMY_TYPE1, 220, -30);
      break;
    case 600:
      e.addEnemy(ENEMY_TYPE1, 30, -30);
      e.addEnemy(ENEMY_TYPE1, 70, -30);
      e.addEnemy(ENEMY_TYPE1, 110, -30);
      e.addEnemy(ENEMY_TYPE2, 120, -30);
      e.addEnemy(ENEMY_TYPE2, 170, -30);
      e.addEnemy(ENEMY_TYPE2, 220, -30);
      break;
    case 800:
      e.addEnemy(ENEMY_TYPE1, 30, -30);
      e.addEnemy(ENEMY_TYPE1, 70, -30);
      e.addEnemy(ENEMY_TYPE1, 110, -30);
      e.addEnemy(ENEMY_TYPE2, 120, -30);
      e.addEnemy(ENEMY_TYPE2, 170, -30);
      e.addEnemy(ENEMY_TYPE2, 220, -30);
      break;  
    case 1000:
      e.addEnemy(ENEMY_TYPE2, 30, -10);
      e.addEnemy(ENEMY_TYPE2, 70, -10);
      e.addEnemy(ENEMY_TYPE2, 110, -10);
      e.addEnemy(ENEMY_TYPE2, 120, -10);
      e.addEnemy(ENEMY_TYPE2, 170, -10);
      e.addEnemy(ENEMY_TYPE2, 220, -10);
      break;
    case 1400:
      bossStart();
      break;
    }
  }

  //ボス処理
  void bossStart() {
    isBossBattle=true;
    b.start();
  }

  //ボスの当たり判定
  void hitTestShotBoss(Player p, Boss b) {
    //とりま中心より40pxを当りとする
    Shot[] shots=p.getShots();
    for (int j=0;j<shots.length;j++) { 
      Shot s=shots[j];
      if (!s.visible) {
        continue;
      } else if (!b.visible) {
        continue;
      } else if (b.isNotHit) {
        continue;
      }
      float d= PVector.dist(s.position, b.position);
      if (d<30) {
        Boolean isDead=b.setDamage(1);
        if (isDead) {
          defx.setEffect(b.position); 
          sc.addScore(b.score);
          stageClearStart=frameCount;
          isStageClear=true;
        }
        s.visible=false;
      }
    }
  }

  //自機とボスとの当たり判定
  void hitTestPlayerBoss(Player p, Boss b) {
    if (p.isDead) {
      return;
    }
    if (!b.visible) {
      return;
    }
    if (p.position.x>(b.position.x-b._width/2) && p.position.x<(b.position.x+b._width/2) && p.position.y>(b.position.y-b._height/2) && p.position.y<(b.position.y+b._height/2)) {
      p.setDead();
      defx.setEffect(p.position);
      gameOverStart=frameCount;

      gameOver=true;
    }
  }

  //自機とボスの弾との当たり判定
  void hitTestPlayerBossShot(Player p, Boss b) {
    if (p.isDead) {
      return;
    }
    Shot[] shots=b.getShots();
    for (int i=0;i<shots.length;i++) {
      if (!shots[i].visible) {
        continue;
      }
      float dx=p.position.x-shots[i].position.x;
      float dy=p.position.y-shots[i].position.y;
      float d= sqrt(dx*dx+dy*dy);
      if (d<(p._width/2-4)) {
        p.setDead();
        defx.setEffect(p.position);
        gameOverStart=frameCount;
        shots[i].visible=false;
        gameOver=true;
        break;
      }
      if (gameOver==true) {
        break;
      }
    }
  }
}

