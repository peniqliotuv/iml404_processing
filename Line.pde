class Line {
  float xStart;
  float yStart;
  float xEnd;
  float yEnd;
  
  float alpha = 120;
  float red;
  float green;
  float blue;
  
  int life = 5;
  
  Line(float xStart, float yStart, float xEnd, float yEnd) {
    this.xStart = xStart;
    this.yStart = yStart;
    this.xEnd = xEnd;
    this.yEnd = yEnd;
    this.red = 0;
    this.green = 0;
    this.blue = 0;
  }
  
  public void setColor(float red, float green, float blue) {
    this.red = red;
    this.green = green;
    this.blue = blue;
  }
  
  public void draw() {
    strokeWeight(1);
    stroke(this.red, this.green, this.blue, 25 * this.life);
    line(this.xStart, this.yStart, this.xEnd, this.yEnd);
    
    --life;
  }
  
}
