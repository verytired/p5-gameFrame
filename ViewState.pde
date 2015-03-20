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

