class Line {
  float xStart;
  float yStart;
  float xEnd;
  float yEnd;
  
  float alpha = 120;
  float red;
  float green;
  float blue;
  
  int lineColor;
  int life = 25;
  
  Line(float xStart, float yStart, float xEnd, float yEnd, int lineColor) {
    this.xStart = xStart;
    this.yStart = yStart;
    this.xEnd = xEnd;
    this.yEnd = yEnd;
    this.lineColor = lineColor;
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
  
    stroke(this.lineColor, 3 * this.life);
    vertex(this.xStart, this.yStart);
    vertex(this.xEnd, this.yEnd);
   
    --life;
  }
  
}
