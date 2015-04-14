
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

