//todo ボムというか弾消し
//todo 敵出現順外部ファイル化


//default
GameManager gm;

void setup() {
  gm=new GameManager();
  gm.init();
}

void draw() {
  gm.update();
  gm.display();
}

void mousePressed() {
  gm.mousePressed();
}

void mouseReleased() {
  gm.mouseReleased();
}

void keyPressed() {
  gm.keyPressed(key);
}

class BackGround extends ViewObject {
  PImage img1, img2;

  int dy=2;
  int y1=0;
  int y2=-320;

  BackGround() {
    img1=loadImage("bg.jpg"); 
    img2=loadImage("bg.jpg");   

    img2.resize(SCREEN_WIDTH, SCREEN_HEIGHT);
  }
  void update() {
    y1+=dy;
    y2+=dy;
    if (y1>=320) {
      y1=-320;
    }
    if (y2>=320) {
      y2=-320;
    }
  }
	void test(){
}

  void display() {
    imageMode(CORNER); 
      image(img1, 0, y1);
    image(img2, 0, y2);
  }
}

class Boss extends ViewObject {

  int color_line= #00CCFF;
  int color_bg=#00FF00;

  public int score=100000;
  int nowHp=3000;
  int moveNo=0;
  int shotNo=0;
  int max_shots=300;  
  Shot[] _shots= {
  };

  Boolean nowDamage=false;

  public Boolean isDead=true;
  public Boolean isNotHit=false;

  PImage img1, img2;
  Boss() {
    _width=180;
    _height=100;
    position=new PVector(SCREEN_WIDTH/2, -100);
    for (int i=0;i<max_shots;i++) {
      _shots = (Shot[])append(_shots, new EnemyShot());
    }
    img1=loadImage("boss_00.png");
    img2=loadImage("boss_01.png");
  }

  void start() {
    countStart=frameCount;
    visible=true;
    isNotHit=true;
    //    mx=0.5;
    accelation=new PVector(0.5, 0);
  }

  Boolean shotFlag=false;
  void update() {
    super.update();
    for (int i=0;i<_shots.length;i++) {
      _shots[i].update();
    }
    if (!visible) {
      return;
    }

    switch(moveNo) {
    case 0:
      float step=(100-(-120))/100;
      position.y+= step;
      if (countNow==100) {
        moveNo=1;
      }
      break;
    case 1:
      if (countNow==200) {
        moveNo=2;
        isNotHit=false;
      }
      break;
    case 2:
      //ここからバトル開始
      //      position.x+=mx;
      position.add(accelation);
      if (position.x>200) {
        position.x=200;
        accelation.x=-0.5;
      } else if (position.x<40) {
        position.x=40;
        accelation.x=0.5;
      }
      //shot
      if (position.x==120) {
        setShot();
      }
      if (nowHp<2000) {
        moveNo=3;
      }
      break;
    case 3:
      position.add(accelation);
      if (position.x>200) {
        position.x=200;
        accelation.x=-0.9;
        setShot();
      } else if (position.x<40) {
        position.x=40;
        accelation.x=0.9;
        setShot();
      }
      //shot
      if (position.x==120) {
        setShot();
      }
      if (nowHp<1000) {
        moveNo=4;
      }
      break;
    case 4:      
      position.add(accelation);
      if (position.x>200) {
        position.x=200;
        accelation.x=-1.2;
        setShot();
        shotFlag=false;
      } else if (position.x<40) {
        position.x=40;
        accelation.x=1.2;
        setShot();
        shotFlag=false;
      }
      if (accelation.x>0 && position.x>120 && shotFlag==false) {
        setShot();
        shotFlag=true;
      } else if (accelation.x<0 && position.x<=120 && shotFlag==false) {
        setShot();
        shotFlag=true;
      }
      break;
    }
  }



  Shot[] getShots() {
    return _shots;
  }

  void setShot() {
    int max=20;
    int cc=0;
    switch(moveNo) {
    case 0:
      break;
    case 1:
      break;
    case 2:
      println("shot!!!!!");

      for (int i=0;i<_shots.length;i++) {
        if (!_shots[i].visible) {
          _shots[i].setShot(position);
          _shots[i].setAcce(new PVector(1, 1));
          cc++;
        }
        if (cc>=max) {
          break;
        }
      }
      break;
    case 3:
      max=20;
      for (int i=0;i<_shots.length;i++) {
        if (!_shots[i].visible) {
          _shots[i].setShot(position);
          _shots[i].setAcce(new PVector(1.5, 1.5));
          cc++;
        }
        if (cc>=max) {
          break;
        }
      }
      break;
    case 4:
      for (int i=0;i<_shots.length;i++) {
        if (!_shots[i].visible) {
          _shots[i].setShot(position);
          _shots[i].setAcce(new PVector(1.5, 1.5));
          cc++;
        }
        if (cc>=max) {
          break;
        }
      }
      break;
    }
  }

  void display() {
    for (int i=0;i<_shots.length;i++) {
      _shots[i].display();
    }
    if (!visible) {
      return;
    }
    stroke(color_line);
    noFill();
//    ellipse( position.x, position.y, 40, 40);
//    ellipse( position.x, position.y, _width, _height);
    imageMode(CENTER);
    image(img1, position.x, position.y-20);
    if (nowDamage==true) {
//      stroke(#FF0000);
//      fill(#FF0000, 128);
//      ellipse(position.x, position.y, 40, 40);
        tint(255, 128, 0);
      nowDamage=false;
    }
    image(img2, position.x, position.y);
    noTint();
  }

  //ダメージを食らう
  Boolean setDamage(int damage) {
    nowHp-=damage*1.5;
    nowDamage=true;
    println(nowHp);
    if (nowHp<=0) {
      setDead();    
      return true;
    } 
    return false;
  }

  //死んだ
  void setDead() {
    isDead=true;
    visible=false;
  }
}


public static class Debugger{
  public static Boolean isDebug=true;
  public static void log(String str){
    if(isDebug){
      println(str);
    }
  }
  
}

class Effects {
  int max=10;

  EffectDead[] _effects = {
  };

  Effects() {
    for (int i=0;i<max;i++) {
      _effects = (EffectDead[])append(_effects, new EffectDead());
    }
  }

  void setEffect(PVector p) {
    boolean end=false;
    for (int i=0;i<_effects.length;i++) {
      if (!_effects[i].visible) {
        _effects[i].start(p);
        end=true;
      }  
      if (end) {
        break;
      }
    }
  }

  void update() {
    for (int i=0;i<_effects.length;i++) {
      _effects[i].update();
    }
  }

  void display() {
    for (int i=0;i<_effects.length;i++) {
      _effects[i].display();
    }
  }
}

class EffectDead extends ViewObject {

  int moveFrame=10;
  float particleWidth=0;
  float particleHeight=0;

  private Particle[] _particles= {
  };

  EffectDead() {
    _particles = (Particle[])append(_particles, new Particle(new PVector(1, 1)));
    _particles = (Particle[])append(_particles, new Particle(new PVector(-1, 1)));
    _particles = (Particle[])append(_particles, new Particle(new PVector(-1, -1)));
    _particles = (Particle[])append(_particles, new Particle(new PVector(1, -1)));
    position=new PVector();
  }
  
  void start(PVector p) {
    position=p.get();
    countStart=frameCount;
    visible=true;
    for (int i=0;i<_particles.length;i++) {
      _particles[i].visible=true;
      _particles[i].position=p.get();
    }
  }

  void update() {
    if (!visible) {
      return;
    }
    countNow=frameCount-countStart;

    for (int i=0;i<_particles.length;i++) {
      _particles[i].update();
    }

    if (countNow==moveFrame) {
      for (int i=0;i<_particles.length;i++) {
        _particles[i].visible=false;
      }
      visible=false;
    }
  }

  void display() {
    for (int i=0;i<_particles.length;i++) {
      _particles[i].display();
    }
  }
}

class Particle extends ViewObject {

  Particle(PVector vec) {
    _width=4;
    _height=4;
    position=new PVector();
    accelation=new PVector(6*vec.x, 6*vec.y);
    visible=false;
  }

  void update() {
    if (!visible) {
      return;
    }
    position.add(accelation);
  }

  void display() { 
    if (!visible) {
      return;
    }
    stroke(255, 255, 0);
    noFill();
    rect(position.x-_width/2, position.y-_height/2, _width, _height);
  }
}


int ENEMY_TYPE1=1;
int ENEMY_TYPE2=2;
int ENEMY_TYPE3=3;
int ENEMY_TYPE4=4;  
int ENEMY_TYPE5=5;
int ENEMY_MAX=10;

class Enemies {

  Enemy[] _enemies = {
  };

  Enemies() {
    for (int i=0;i<ENEMY_MAX;i++) {
      _enemies = (Enemy[])append(_enemies, new Enemy(ENEMY_TYPE1, 0, 0));
    }
  }

  void addEnemy(int no, float x, float y) {
    boolean end=false;
    for (int i=0;i<_enemies.length;i++) {
      if (_enemies[i].isDead) {
        _enemies[i]=null;
        _enemies[i]=new Enemy(no, x, y);   
        _enemies[i].start();
        end=true;
      }  
      if (end) {
        break;
      }
    }
  }

  void update() {
    for (int i=0;i<_enemies.length;i++) {
      _enemies[i].update();
    }
  }

  void display() {
    for (int i=0;i<_enemies.length;i++) {
      _enemies[i].display();
    }
  }

  Enemy[] getEnemies() {
    return _enemies;
  }
}


class Enemy extends ViewObject {

  int maxHp=1;
  int nowHp=1;
  int typeNo=1;
  public int score=100;

  int color_line=#00FFFF;
  int color_bg=#00FF00;

  Boolean nowDamage=false;
  public Boolean isDead=true;
  public Boolean isNotHit=false;

  int max_shots=20;  
  Shot[] _shots= {
  };

  Enemy(int typeNum, float startx, float starty) {
    visible = false;
    isDead = true;
    initialize(typeNum);
    for (int i=0;i<max_shots;i++) {
      _shots = (Shot[])append(_shots, new EnemyShot());
    }
    position=new PVector(startx, starty);
    accelation=new PVector();
  }

  PImage img1;
  PImage img2;
  void initialize(int Num) {
    typeNo=Num;
    switch(typeNo) {
    case 1:
      _width=20;
      _height=20;
      maxHp=1;
      nowHp=1;
      score=100;
      imageMode(CENTER);
      img1=loadImage("ene_00.png");
      break;
    case 2:
      _width=20;
      _height=20;
      maxHp=0;
      nowHp=20;
      score=1000;
      color_line=140;
      color_bg=#00FF00;
      imageMode(CENTER);
      img2=loadImage("ene_01.png");
      break;
    case 3:
      break;
    case 4:
      break;
    case 5:
      break;
    }
  }

  void update() {  
    super.update();
    for (int i=0;i<_shots.length;i++) {
      _shots[i].update();
    }
    if (isDead) {
      return;
    }
    setMove();
  }

  void display() {
    for (int i=0;i<_shots.length;i++) {
      _shots[i].display();
    }
    if (!visible) {
      return;
    }
    setDraw();
  }

  void start() {
    visible=true;
    isDead=false;
    countStart=frameCount;
    switch(typeNo) {
    case 1:
      accelation.set(0, 4);
      break;
    case 2:
      accelation.set(0, 5);
      break;
    case 3:
      break;
    case 4:
      break;
    case 5:
      break;
    }
  }

  void setMove() {
    switch(typeNo) {
    case 1:
      position.add(accelation);
      if (position.y>=SCREEN_HEIGHT) {
        visible=false;
      }
      break;
    case 2:
      int stopFrame=20;
      int shotFrame=60;
      int returnFrame=150;
      if (countNow==stopFrame) {
        accelation.y=0;
      } else if (countNow==shotFrame) {
        setShots();
        accelation.y=0;
      } else if (countNow==returnFrame) {
        accelation.y=-5;
      } else if (countNow==300) {
        //一定期間経ったら消去
        setDead(true);
      }
      position.add(accelation);
      if (countNow>=returnFrame && position.y<-_height/2) {
        visible=false;
      }
      break;
    case 3:
      break;
    case 4:
      break;
    case 5:
      break;
    }
    //一定期間経ったら消去
    if (countNow>=300) {
      setDead(true);
    }
  }

  //描画
  void setDraw() {
    switch(typeNo) {
    case 1:
      imageMode(CENTER);
      image(img1, position.x, position.y);
      break;
    case 2:
      stroke(color_line);
      if (nowDamage==true) {
//        stroke(#FF0000);
        tint(255, 128, 0);
        nowDamage=false;
      }
      noFill();
      //rect(position.x-_width/2, position.y-_height/2, _width, _height);
      imageMode(CENTER);
      image(img2, position.x, position.y);
      noTint();
      break;
    case 3:
      break;
    case 4:
      break;
    case 5:
      break;
    }
  }

  //ダメージを食らう
  Boolean setDamage(int damage) {
    nowHp-=damage;
    nowDamage=true;
    if (nowHp<=0) {
      return setDead(true);
    } 
    return setDead(false);
  }

  //死んだ
  Boolean setDead(Boolean flag) {
    isDead=flag;
    visible=!flag;
    return isDead;
  }

  Shot[] getShots() {
    return _shots;
  }

  //発射
  void setShots() {
    switch(typeNo) {
    case 1:
    case 2:
      int max=3;
      int cc=0;
      for (int i=0;i<_shots.length;i++) {
        if (!_shots[i].visible) {
          _shots[i].setShot(position);
          cc++;
        }
        if (cc>=max) {
          break;
        }
      }
      break;
    case 3:
      break;
    case 4:
      break;
    case 5:
      break;
    }
  }
}

//Constract
int BGCOLOR=#000000;
int SCREEN_WIDTH=240;
int SCREEN_HEIGHT=320;

class GameManager {

  int counterNow;
  int counterStart;

  ViewState _state;
  GameManager() {
    _state=new MenuView(this);
  }

  void init() {
    size(SCREEN_WIDTH, SCREEN_HEIGHT); 
    background(BGCOLOR);
  }

  void mousePressed() {
    _state.mousePressed();
  }

  void mouseReleased() {
    _state.mouseReleased();
  }

  void keyPressed(char key) {
    _state.keyPressed(key);
  }  

  void update() {
    _state.update();
  }

  void display() {
    _state.display();
  }

  void destructScene() {
    _state.destruct();
    _state=null;
  }

  void setGame() {
    destructScene();
    _state=new GameView(this);
  }
  void setOpening() {
    destructScene();
    _state=new MenuView(this);
  }
}


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

//----------player
class Player extends ViewObject {

  int color_line= #00FF00;
  int color_bg=#00FF00;
  private Shot[] _shots= {
  };
  int max_shots=30;    
  int shotFrame=6;
  public Boolean isDead = false;

  PImage img1;

  Player() {
    _width=20;
    _height=20;
    visible=true;
    for (int i=0;i<max_shots;i++) {
      _shots = (Shot[])append(_shots, new Shot());
    }
    position=new PVector();
    img1=loadImage("jiki_00.png");
  }

  void update() {
    for (int i=0;i<_shots.length;i++) {
      _shots[i].update();
    }
    if (isDead) {
      return;
    }
    position.x=mouseX;
    position.y=mouseY;
    if (countNow%shotFrame==0) {
      setShots();
    }
  }

  void display() {

    if (!visible) {
      return;
    }
    //    stroke(color_line);
    //    noFill();
    //    ellipse(position.x, position.y, _width, _height);
    imageMode(CENTER);
    image(img1, position.x, position.y);
  }

  public void shotDisplay() {
    for (int i=0;i<_shots.length;i++) {
      _shots[i].display();
    }
  }

  void setDead() {
    isDead=true;
    visible=false;
//    return _shots;
  }

  Shot[] getShots() {
    return _shots;
  }

  void setShots() {
    boolean end=false;
    for (int i=0;i<_shots.length;i++) {
      if (!_shots[i].visible) {
        PVector p=new PVector(position.x, position.y-24);
        _shots[i].setShot(p);
        end=true;
      }
      if (end) {
        break;
      }
    }
  }
}

//----------
class Shot extends ViewObject {
  int color_line=#FF0000;
  int color_bg=#FF0000;
  PImage img1;
  Shot() {
    visible = false;
    _width=8;
    _height=8;
    position=new PVector(0, 0);
    vector=new PVector(0, -1);
    vector.normalize();
    accelation=new PVector(1, 12);
    img1=loadImage("shot_01.png");
  }

  public void setShot(PVector p) {
    position=p.get();
    visible = true;
  }

  public void setAcce(PVector a) {
    accelation=a.get();
    visible = true;
  }

  public void setVector(PVector v) {
    vector=v.get();
    visible = true;
  }

  //目標までのベクターを定義
  public void setTargetVector(PVector p) {
    float cx = p.x-position.x;
    float cy = p.y-position.y;
    float d=sqrt(cx*cx+cy*cy);
    vector=new PVector(cx/d, cy/d);
    vector.normalize();
  }

  void update() {
    if (!visible) {
      return;
    }
    PVector v=new PVector();
    v.x=vector.x*accelation.x;
    v.y=vector.y*accelation.y;
    position.add(v);

    if (position.x<-_width/2) {
      visible=false;
    } else if (position.x>SCREEN_WIDTH-_width/2) {
      visible=false;
    } else if (position.y<-_height/2) {
      visible=false;
    } else if (position.y>SCREEN_HEIGHT-_height/2) {
      visible=false;
    }
  }

  void display() {
    if (!visible) {
      return;
    }
    //    stroke(color_line);
    //    noFill();
    //    rect(position.x-_width/2, position.y-_height/2, _width, _height)
    imageMode(CENTER);
    image(img1, position.x, position.y);
    ;
  }
}

//----------
class EnemyShot extends Shot {

  int color_line=#BBBBBB;
  int color_bg=#FF0000;

  PImage img1;
  EnemyShot() {
    super();
    visible = false;
    vector=new PVector(random(6)-3, random(3)+3);
    vector.normalize();
    accelation=new PVector(random(6)-3, random(3)+3);
    img1=loadImage("shot_00.png");
  }


  //  void setShot(PVector p) {
  //    position=p.get();
  //    visible = true;
  //  }
  //
  //  void setAcce(PVector a) {
  //    accelation=a.get();
  //    visible = true;
  //  }
  //
  //  void setVector(PVector v) {
  //    accelation=v.get();
  //    visible = true;
  //  }

  //  void update() {
  //    if (!visible) {
  //      return;
  //    }
  //    position.add(accelation);
  //
  //    if (position.x<-_width/2) {
  //      visible=false;
  //    } else if (position.x>SCREEN_WIDTH-_width/2) {
  //      visible=false;
  //    } else if (position.y<-_height/2) {
  //      visible=false;
  //    } else if (position.y>SCREEN_HEIGHT-_height/2) {
  //      visible=false;
  //    }
  //  }

  void display() {
    if (!visible) {
      return;
    }
    //    stroke(255, 255, 0);
    //    noFill();
    //    rect(position.x-_width/2, position.y-_height/2, _width, _height);
    imageMode(CENTER);
    image(img1, position.x, position.y);
  }
}


class ViewObject {

  int countStart=0;
  int countNow=0; 


  int _width;
  int _height;
  public PVector vector, position, accelation;
  public boolean visible =false;

  ViewObject() {
    countStart=frameCount;
    vector=new PVector();
    position=new PVector();
    accelation=new PVector();
  }

  void update() {
    countNow=frameCount-countStart;
  }

  void display() {
  }

  void destruct() {
  }
}

class ViewState {
  int countStart;
  int countNow; 

  ViewObject[] _objects= {
  };

  GameManager _gm;
  ViewState(GameManager gm) {
    _gm=gm;
    countStart=frameCount;
  }

  void init() {
    countStart=countStart=frameCount;
  }
  void mousePressed() {
//    println("press");
  }

  void mouseReleased() {
//    println("release");
  }

  void keyPressed(char key) {
  }  

  void add(ViewObject obj) {
    _objects = (ViewObject[])append(_objects, obj);
  }

  void update() {
    countNow=frameCount-countStart;
    for (int i=0;i<_objects.length;i++) {
      _objects[i].update();
    }
  }

  void display() {
    viewCount();
    for (int i=0;i<_objects.length;i++) {
      _objects[i].display();
    }
  }

  void destruct() {
    for (int i=0;i<_objects.length;i++) {
      _objects[i].destruct();
      _objects[i]=null;
    }
  }

  void viewCount() {
    PFont font = createFont("Meiryo", 32);
    textFont(font); //フォントの指定
    fill(255, 0, 0);
    textSize(12);
    text(countNow, 12, 12);
  }
}

//爆風アニメ格納テスト
class EffectDeads {
  int max=10;

  Character[] _effects = {
  };

  EffectDeads() {
    for (int i=0;i<max;i++) {
      _effects = (Character[])append(_effects, new Character("baku"));
    }
  }

  void setEffect(PVector p) {
    boolean end=false;
    for (int i=0;i<_effects.length;i++) {
      if (!_effects[i].visible) {
        _effects[i].start(p);
        end=true;
      }  
      if (end) {
        break;
      }
    }
  }

  void update() {
    for (int i=0;i<_effects.length;i++) {
      _effects[i].update();
    }
  }

  void display() {
    for (int i=0;i<_effects.length;i++) {
      _effects[i].display();
    }
  }
}


class Character extends ViewObject {
  // 属性
  FrameAnim anim;

  float charaX, charaY, initY;
  float speedX, speedY;

  Character(String name) {
    super();
    anim = new FrameAnim(name, 18);
    //開始フレーム　終了フレーム　フレームレート
    anim.setAnim(0, 17, 60);
  }

  // キャラクターの位置を計算する
  void move() {
  }

  void start(PVector p) {
    position=p.get();
    countStart=frameCount;
    visible=true;
    anim.setFrame(0);
  }

  // キャラクターを画面に描く
  void update() {
    if (!visible) {
      return;
    }
    anim.step();
    println("index:"+anim.index);
  }

  void display() {
    if (!visible) {
      return;
    }

    PImage img=anim.img();
    if (img!=null) {
      imageMode(CENTER);
      image(img, position.x, position.y);
    }
    else {
      visible=false;
    }

    //     image(anim.img(), position.x, position.y);
  }
}


class FrameAnim {
  PImage[] frames;
  public int index, start, end;
  int rate;
  int wait;
  Boolean isLoop=false;
  Boolean isEnd=false;
  FrameAnim(String name, int num) {
    index = start = end = 0;
    rate = 2;
    wait = 2;

    frames = new PImage[num];
    for (int i=0 ; i < num ; i++) {
      frames[i] = loadImage(name + "_" + nf(i, 2) + ".png");
    }
  }

  PImage img() {
    if (index >= end) {
      return null;
    }
    return frames[index];
  }

  void setAnim(int st, int len, int _rate) {
    start = index = st;
    end = start + len;
    rate = _rate;
    wait = 0;
  }

  void setFrame(int n) {
    index=n;
  }

  void step() {
    if (isEnd)return;
    wait++;
    if (wait > ( frameRate / rate ) ) {
      wait = 0;
      index++;
      if (index >= end && isLoop==true) {
        index = start;
        if (isLoop==false) {
          isEnd=true;
          index=end;
        }
      }
    }
  }
}
class Score extends ViewObject {

  int myScore=0;
  int nowScore=0;
  int step=10;
  int stepFrame=1;
  int stepAddScore=0;
  Boolean isAdding=false;

  Score(){
    myScore=0;
  }
  
  void update() {
    countNow=frameCount-countStart;
    if (isAdding) {
      if (countNow%stepFrame==0) {
        nowScore+=stepAddScore;
      }  
      if (countNow>(step*stepFrame)) {
        nowScore=myScore;
        isAdding=false;
      }
    }
  }

  void addScore(int addScore) {
    if(isAdding){
      isAdding=false;
      nowScore=myScore;
    }
    myScore+=addScore;
    countStart=frameCount;
    stepAddScore=addScore/step;
    isAdding=true;
  }

  void display() {
    PFont font = createFont("Meiryo", 32);
    textFont(font); //フォントの指定
    fill(255, 128, 0);
    textSize(20);
    text("SCORE : "+nowScore, 40, 24);
  }
}


