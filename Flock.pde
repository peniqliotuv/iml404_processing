// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

// Flock class
// Does very little, simply manages the ArrayList of all the boids

class Flock {
  ArrayList<Boid> boids; // An ArrayList for all the boids
  ArrayList<PVector> means;
  ArrayList<Integer> colors;
  int k;
  
  Flock() {
    println("Initializing Flock");
    boids = new ArrayList<Boid>(); // Initialize the ArrayList
    k = 10;
    means = new ArrayList(k);
    colors = new ArrayList(k);
    
    for (int i = 0; i < k; ++i) {
      means.add(new PVector(random(0, width), random(0, height)));
      colors.add((int) random(0, 255));
    }  
    println("Finished init flock");
  }

  void run() {
    println("Running!");
    ArrayList<PVector> locations = new ArrayList(k);
    for (int i = 0; i < k; i++) {
      locations.add(new PVector(0, 0));
    }
    
    for (Boid b : boids) {
      b.run(boids);  // Passing the entire list of boids to each boid individually 
    }
    
    for (int i = boids.size() - 1; i >= 0; i--) {
      Boid b = boids.get(i);
      if (b.location.x <= 0 || b.location.x >= width || b.location.y <= 0 || b.location.y >= height) {
        // println("Removing boid " + i);
        boids.remove(i);
      } else {
        // K-Means algorithm
        int idx = calculateIndexOfClosestMean(b);
        b.meanIdx = idx;
        b.fillColor = colors.get(idx);
        locations.set(idx, locations.get(idx).add(b.location));
      }
      //if (b.lifespan <= 0)
      //  boids.remove(i);
      
    }
    
    for (int i = 0; i < boids.size(); ++i) {
      Boid b = boids.get(i);
      int idx = b.meanIdx;
      
    }
  }
  
  int calculateIndexOfClosestMean(Boid b) {
    float minDist = Float.MAX_VALUE;
    int idx = 0;
    for (int i = 0; i < k; ++i) {
      float dist = means.get(i).dist(b.location);
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
