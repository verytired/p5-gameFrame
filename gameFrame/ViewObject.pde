
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

