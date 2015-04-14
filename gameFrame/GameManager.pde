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

