//爆風アニメ格納テスト
class EffectDeads {
  int max=10;

  Character[] _effects = {
  };

  EffectDeads() {
    for (int i=0;i<max;i++) {
      _effects = (Character[])append(_effects, new Character("baku"));
    }
  }

  void setEffect(PVector p) {
    boolean end=false;
    for (int i=0;i<_effects.length;i++) {
      if (!_effects[i].visible) {
        _effects[i].start(p);
        end=true;
      }  
      if (end) {
        break;
      }
    }
  }

  void update() {
    for (int i=0;i<_effects.length;i++) {
      _effects[i].update();
    }
  }

  void display() {
    for (int i=0;i<_effects.length;i++) {
      _effects[i].display();
    }
  }
}


class Character extends ViewObject {
  // 属性
  FrameAnim anim;

  float charaX, charaY, initY;
  float speedX, speedY;

  Character(String name) {
    super();
    anim = new FrameAnim(name, 18);
    //開始フレーム　終了フレーム　フレームレート
    anim.setAnim(0, 17, 60);
  }

  // キャラクターの位置を計算する
  void move() {
  }

  void start(PVector p) {
    position=p.get();
    countStart=frameCount;
    visible=true;
    anim.setFrame(0);
  }

  // キャラクターを画面に描く
  void update() {
    if (!visible) {
      return;
    }
    anim.step();
    println("index:"+anim.index);
  }

  void display() {
    if (!visible) {
      return;
    }

    PImage img=anim.img();
    if (img!=null) {
      imageMode(CENTER);
      image(img, position.x, position.y);
    }
    else {
      visible=false;
    }

    //     image(anim.img(), position.x, position.y);
  }
}


class FrameAnim {
  PImage[] frames;
  public int index, start, end;
  int rate;
  int wait;
  Boolean isLoop=false;
  Boolean isEnd=false;
  FrameAnim(String name, int num) {
    index = start = end = 0;
    rate = 2;
    wait = 2;

    frames = new PImage[num];
    for (int i=0 ; i < num ; i++) {
      frames[i] = loadImage(name + "_" + nf(i, 2) + ".png");
    }
  }

  PImage img() {
    if (index >= end) {
      return null;
    }
    return frames[index];
  }

  void setAnim(int st, int len, int _rate) {
    start = index = st;
    end = start + len;
    rate = _rate;
    wait = 0;
  }

  void setFrame(int n) {
    index=n;
  }

  void step() {
    if (isEnd)return;
    wait++;
    if (wait > ( frameRate / rate ) ) {
      wait = 0;
      index++;
      if (index >= end && isLoop==true) {
        index = start;
        if (isLoop==false) {
          isEnd=true;
          index=end;
        }
      }
    }
  }
}

