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

