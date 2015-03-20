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

