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

