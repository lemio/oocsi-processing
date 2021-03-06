import nl.tue.id.oocsi.*;

int fillColor = 255;
int position = 0;

void setup() {
  size(200, 200);
  noStroke();

  // connect to OOCSI server running on the same machine (localhost)
  // with "receiverName" to be my channel others can send data to
  OOCSI oocsi = new OOCSI(this, "receiverName", "localhost");

  // subscribe to channel "testchannel"
  oocsi.subscribe("testchannel");
}

void draw() {
  background(255);
  fill(fillColor, 120, 120);
  rect(20, position, 20, 20);
}

void handleOOCSIEvent(OOCSIEvent event) {
  // assign the new fill color from the OOCSI event
  fillColor = event.getInt("color", 0);
  // assign the new y position from the OOCSI event
  position = event.getInt("position", 0);
}

