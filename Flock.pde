// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

// Flock class
// Does very little, simply manages the ArrayList of all the boids
import java.util.Iterator; 

class Flock {
  ArrayList<Boid> boids; // An ArrayList for all the boids
  ArrayList<PVector> means;
  ArrayList<Integer> reds;
  ArrayList<Integer> blues;
  ArrayList<Integer> greens;
  ArrayList<Integer> colors;

  ArrayList<Line> allLines;
  ArrayList<ArrayList<Line>> linesByClass;

  int k;

  // Boolean value represent if the boids should be rendered or not.
  Boolean hideBoids;
  // Boolean value representing if the traces should be kept or not
  Boolean keepTraces;
  // Draw graph between each boid
  Boolean drawGraph;
  // Draw complete graph
  Boolean drawCompleteGraph;

  Flock() {
    println("Initializing Flock");
    this.boids = new ArrayList<Boid>(); // Initialize the ArrayList
    this.k = 5;
    this.means = new ArrayList(k);
    this.hideBoids = false;
    this.keepTraces = false;
    this.drawGraph = false;
    this.drawCompleteGraph = false;

    this.colors = new ArrayList(this.k);
    this.allLines = new ArrayList();
    this.linesByClass = new ArrayList(this.k);

    int white = color(255, 255, 255);
    int black = color(0, 0, 0);
    
    for (int i = 0; i < k; ++i) {
      means.add(new PVector(random(0, width), random(0, height)));
      colors.add(lerpColor(white, black, (float)(i+1) / k));
      this.linesByClass.add(new ArrayList<Line>());
    }

    println("Finished init flock");
  }

  void toggleKeepTraces() {
    if (this.keepTraces) {
      this.allLines.clear();
    }
    this.keepTraces = !this.keepTraces;
  }

  void run() {
    //println("#Boids: " + boids.size() + " #Lines: " + allLines.size());
    // Keeps track of the cumulative locations for each group;
    ArrayList<PVector> locations = new ArrayList(k);
    // Counts the number of boids in each group
    ArrayList<Integer> counts = new ArrayList(k);
    for (int i = 0; i < k; ++i) {
      locations.add(new PVector(0, 0));
      counts.add(0);
      this.linesByClass.get(i).clear();
    }

    for (Boid b : boids) {
      b.run(boids, this.hideBoids);  // Passing the entire list of boids to each boid individually
    }


    beginShape(LINES);
    strokeWeight(1);
    
    for (int i = boids.size() - 1; i >= 0; i--) {
      Boid b = boids.get(i);
      if (b.lifespan <= 0 || b.location.x <= 0 || b.location.x >= width || b.location.y <= 0 || b.location.y >= height) {
        boids.remove(i);
      } else {
        // K-Means algorithm
        int idx = calculateIndexOfClosestMean(b);
        // println(idx);
        b.meanIdx = idx;
       
        b.fillColor = colors.get(idx);

        // Add each vector's location to the appropriate bucket in the ArrayList
        locations.set(idx, locations.get(idx).add(b.location));
        counts.set(idx, counts.get(idx) + 1);
        
      
        // Draw a line between the mean and the boid

        Line line = new Line(b.location.x, b.location.y, means.get(idx).x, means.get(idx).y, colors.get(idx));
        //line.setColor(reds.get(idx), greens.get(idx), blues.get(idx));  
        this.linesByClass.get(idx).add(line);
        if (this.keepTraces) {
          this.allLines.add(line);
        } else {
          line.draw();
        }
        
        
        
        

        //strokeWeight(1);
        //stroke(reds.get(idx), greens.get(idx), blues.get(idx), 120);
        //line(b.location.x, b.location.y, means.get(idx).x, means.get(idx).y);
      }
    }

    if (this.keepTraces) {
      for (Iterator<Line> it = this.allLines.iterator(); it.hasNext(); ) {
        Line line = it.next();
        line.draw();
        if (line.life == 0) {
          it.remove();
        }
      }
    }
    
    if (this.drawCompleteGraph) {
      drawCompleteGraphs();
    }
    
    
    endShape(LINES);

    // update means
    for (int i = 0; i < k; ++i) {
      int cnt = counts.get(i);
      if (cnt > 0) {
        PVector newMean = locations.get(i).div(cnt);
        means.set(i, newMean);
      }
    }

    // draw means
    for (int i = 0; i < k; ++i) {
      PVector mean = means.get(i);
      //fill(reds.get(i), greens.get(i), blues.get(i), 150);
      fill(colors.get(i), 150);
      strokeWeight(2);
      stroke(255, 0.25);

      //int diameter = counts.get(i) + 20;
      int diameter = 20;
      ellipse(mean.x, mean.y, diameter, diameter);
    }
  }

  int calculateIndexOfClosestMean(Boid b) {
    float minDist = Float.MAX_VALUE;
    int idx = 0;
    for (int i = 0; i < k; ++i) {
      float dist = PVector.dist(means.get(i), b.location);
      if (dist < minDist) {
        minDist = dist;
        idx = i;
      }
    }
    return idx;
  }

  void addBoid(Boid b) {
    boids.add(b);
  }
  
  void drawCompleteGraphs() {
    
    strokeWeight(0.25);
    for (int i = 0; i < this.k; ++i) {
      ArrayList<Line> lines = this.linesByClass.get(i);
      if (!lines.isEmpty()) {
        stroke(colors.get(i), lines.get(0).life * 3);
        for (int j = 0; j < lines.size(); j++) {
          for (int k = 0; k < lines.size(); k++) {
            if (j != k) {
              vertex(lines.get(j).xStart, lines.get(j).yStart);
              vertex(lines.get(k).xStart, lines.get(k).yStart);
            }
          }
        }
      }
    }
  }
}
