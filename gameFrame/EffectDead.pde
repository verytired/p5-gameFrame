
class Effects {
  int max=10;

  EffectDead[] _effects = {
  };

  Effects() {
    for (int i=0;i<max;i++) {
      _effects = (EffectDead[])append(_effects, new EffectDead());
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

class EffectDead extends ViewObject {

  int moveFrame=10;
  float particleWidth=0;
  float particleHeight=0;

  private Particle[] _particles= {
  };

  EffectDead() {
    _particles = (Particle[])append(_particles, new Particle(new PVector(1, 1)));
    _particles = (Particle[])append(_particles, new Particle(new PVector(-1, 1)));
    _particles = (Particle[])append(_particles, new Particle(new PVector(-1, -1)));
    _particles = (Particle[])append(_particles, new Particle(new PVector(1, -1)));
    position=new PVector();
  }
  
  void start(PVector p) {
    position=p.get();
    countStart=frameCount;
    visible=true;
    for (int i=0;i<_particles.length;i++) {
      _particles[i].visible=true;
      _particles[i].position=p.get();
    }
  }

  void update() {
    if (!visible) {
      return;
    }
    countNow=frameCount-countStart;

    for (int i=0;i<_particles.length;i++) {
      _particles[i].update();
    }

    if (countNow==moveFrame) {
      for (int i=0;i<_particles.length;i++) {
        _particles[i].visible=false;
      }
      visible=false;
    }
  }

  void display() {
    for (int i=0;i<_particles.length;i++) {
      _particles[i].display();
    }
  }
}

class Particle extends ViewObject {

  Particle(PVector vec) {
    _width=4;
    _height=4;
    position=new PVector();
    accelation=new PVector(6*vec.x, 6*vec.y);
    visible=false;
  }

  void update() {
    if (!visible) {
      return;
    }
    position.add(accelation);
  }

  void display() { 
    if (!visible) {
      return;
    }
    stroke(255, 255, 0);
    noFill();
    rect(position.x-_width/2, position.y-_height/2, _width, _height);
  }
}

