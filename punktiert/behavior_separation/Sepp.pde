class Sepp extends VParticle {

  BSeparate separation;

  Sepp(float x, float y, float z, float weight, float rad) {
    super(x, y, z, weight, rad);
    separation=new BSeparate(0, 3.5, 0.1);
    addBehavior(separation);
  }

  void setSeparation(float radius) {
    separation.setDesiredSeperation(radius);
  }
}
