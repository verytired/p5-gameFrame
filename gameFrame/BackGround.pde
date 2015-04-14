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

