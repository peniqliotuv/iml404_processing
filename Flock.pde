// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

// Flock class
// Does very little, simply manages the ArrayList of all the boids

class Flock {
  ArrayList<Boid> boids; // An ArrayList for all the boids
  ArrayList<PVector> means;
  ArrayList<Integer> reds;
  ArrayList<Integer> blues;
  ArrayList<Integer> greens;
  
  int k;
  
  Flock() {
    println("Initializing Flock");
    boids = new ArrayList<Boid>(); // Initialize the ArrayList
    k = 10;
    means = new ArrayList(k);
    
    reds = new ArrayList(k);
    blues = new ArrayList(k);
    greens = new ArrayList(k);
    
    for (int i = 0; i < k; ++i) {
      means.add(new PVector(random(0, width), random(0, height)));
      reds.add((int) random(0, 255));
      greens.add((int) random(0, 255));
      blues.add((int) random(0, 255));
    }  
    println("Finished init flock");
    for (int i = 0; i < k; ++i) {
      //println(reds.get(i) + " , " + greens.get(i) + " , " +  blues.get(i));
      //println(means.get(i).x + ", " + means.get(i).y);
    }  
  }

  void run() {
    // Keeps track of the cumulative locations for each group;
    ArrayList<PVector> locations = new ArrayList(k);
    // Counts the number of boids in each group
    ArrayList<Integer> counts = new ArrayList(k);
    for (int i = 0; i < k; ++i) {
      locations.add(new PVector(0, 0));
      counts.add(0);
    }
    
    for (Boid b : boids) {
      b.run(boids);  // Passing the entire list of boids to each boid individually 
    }
    
    for (int i = boids.size() - 1; i >= 0; i--) {
      Boid b = boids.get(i);
      if (b.lifespan <= 0 || b.location.x <= 0 || b.location.x >= width || b.location.y <= 0 || b.location.y >= height) {
        boids.remove(i);
      } else {
        // K-Means algorithm
        int idx = calculateIndexOfClosestMean(b);
        // println(idx);
        b.meanIdx = idx;
        b.red = reds.get(idx);
        b.green = greens.get(idx);
        b.blue = blues.get(idx);
        
        // Add each vector's location to the appropriate bucket in the ArrayList
        locations.set(idx, locations.get(idx).add(b.location));
        counts.set(idx, counts.get(idx) + 1);
      }
      
    }
    
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
      fill(reds.get(i), greens.get(i), blues.get(i), 150);
      strokeWeight(4);
      stroke(reds.get(i), greens.get(i), blues.get(i), 0.25);
      ellipse(mean.x, mean.y, counts.get(i), counts.get(i));
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

}
