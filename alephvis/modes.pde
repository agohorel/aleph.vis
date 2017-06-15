void vectorscope() {
  background(0);
  pushMatrix();
  translate(width/2, height/2);
  rotate(radians(45));
  for (int i = 0; i < bufferSize; i++) {

    stroke(volume * 6);
    strokeWeight(map(volume, 0, 400, 1, 3));
    point(in.left.get(i) * 250, in.right.get(i) * 250, volume);
    point(in.right.get(i) * 250, in.left.get(i) * 250, volume);

    stroke(volume * 3);
    point(in.left.get(i) * 500, in.right.get(i) * 500, volume * 1.5);
    point(in.right.get(i) * 500, in.left.get(i) * 500, volume * 1.5);

    stroke(volume * 1.5);
    point(in.left.get(i) * 1000, in.right.get(i) * 1000, volume * 2);
    point(in.right.get(i) * 1000, in.left.get(i) * 1000, volume * 2);
  }
  popMatrix();

  if (volume < 0.1) {
    noStroke();
    rect(0, 0, width, height);
    fill(255, 1);
  }
}

void black(){
 background(0); 
}