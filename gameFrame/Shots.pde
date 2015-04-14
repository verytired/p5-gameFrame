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

