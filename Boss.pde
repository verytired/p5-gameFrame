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

