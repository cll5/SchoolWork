class Ball {
  PVector position;
  PVector velocity;
  float ballSize;
  float mass;

  Ball() {
    ballSize = random(1, 50);
    mass = 0.5 * ballSize;

    position = new PVector(random(ballSize, width - ballSize), 
    random(ballSize, height - ballSize));
    velocity = new PVector(random(-2, 2), random(-2, 2));
  }

  void draw() {
    fill(122, 232, 170, 25);  
    pushMatrix();
      translate(position.x, position.y);
      ellipse(0, 0, ballSize * 2, ballSize* 2);
    popMatrix();
  }

  void checkWalls() {
    if (position.x < ballSize || position.x > width - ballSize) {
      velocity.x = -velocity.x;
    }

    if (position.y < ballSize || position.y > height - ballSize) {
      velocity.y = -velocity.y;
    }
  }

  void update() {
    velocity.x += (mouseX - position.x)/width / mass;
    velocity.y += (mouseY - position.y)/height / mass;
    velocity.x *= 0.98;
    velocity.y*= 0.98;

    position.add(velocity);
  }
}

