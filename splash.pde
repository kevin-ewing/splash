import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.math.BigInteger;


float NOISE_DIFF = 20;

int NUMBER_COLORS = 3;
float NOISE_SCALE = 0.005;
float CIRCLE_SCALE = 29;
int CIRCLE_OP = 100;
PFont font;

void setup() {
  size(1400, 350, JAVA2D);
  surface.setVisible(false); // Make window not visible
  ellipseMode(CENTER);
  colorMode(HSB, 360, 100, 100);
  background(0,0,100);
  noLoop();
  // Replace with the path to your local font file, or use createFont to use default fonts
  font = createFont("Arial", 14);
  String hash = generateSHA2Hash(str(floor(random(1000000, 9999999))));
  String filename = "./output/sketch_" + hash + ".png"; // Construct filename with hash
  drawSketch();
  println("Saving " + filename);
  save(filename); // Save the frame as a PNG file
  exit(); // Close the sketch after saving
}

void drawSketch() {
  color[][] palette = generatePalette();
  for (int x = 0; x < NUMBER_COLORS; x++) {
    circles(palette[x], x);
  }
  addDesc(palette);
  addNoise();
}

color[][] generatePalette() {
  colorMode(HSB, 360, 100, 100);
  color[][] palette = new color[NUMBER_COLORS][3]; // Clear previous palette
  float baseHue = random(0, 360); // Starting hue
  int colorType = floor(random(4)); // 0: Analogous, 1: Complimentary, 2: Triadic, 3: Monochromatic
  switch (colorType) {
    case 0: // Analogous
      for (int i = 0; i < NUMBER_COLORS; i++) {
        palette[i] = new color[] {(int)((baseHue + i * 30) % 360), 80, 80};
      }
      break;
    case 1: // Complimentary
      for (int i = 0; i < NUMBER_COLORS; i++) {
        palette[i] = new color[] {(int)((baseHue + i * 180) % 360), 80, 80};
      }
      break;
    case 2: // Triadic
      for (int i = 0; i < NUMBER_COLORS; i++) {
        palette[i] = new color[] {(int)((baseHue + i * 120) % 360), 80, 80};
      }
      break;
    case 3: // Monochromatic
      for (int i = 0; i < NUMBER_COLORS; i++) {
        palette[i] = new color[] {(int)(baseHue), 80, (60 + i * 20) % 100}; // Change brightness for monochromatic
      }
      break;
  }
  return palette;
}

void circles(color[] clr, int seed) {
  noFill();
  stroke(clr[0], clr[1], clr[2], CIRCLE_OP);
  strokeWeight(2);
  int spacing = 20;
  for (float x = 0; x <= width; x += spacing) {
    for (float y = 0; y <= height; y += spacing) {
      float radius =
        noise(x * NOISE_SCALE + 100 * seed, y * NOISE_SCALE + 100 * seed) *
        CIRCLE_SCALE -
        4; // Drive radius by noise, adjust multiplier for variation
      if (y % (2 * spacing) == 0) {
        ellipse(x, y, radius, radius);
      } else {
        ellipse(x + spacing / 2, y, radius, radius);
      }
    }
  }
}

void addDesc(color[][] palette) {
  noStroke();
  fill(0,0,100);
  rect(width - 360, height - 20, width, height);

  fill(palette[0][0], palette[0][1], palette[0][2]);
  textFont(font);
  textSize(14);
  text(
    "Generated with https://github.com/kevin-ewing/splash",
    width - 345,
    height - 6
  );
}

String generateSHA2Hash(String input) {
  String hashtext = "";
  try {
    MessageDigest md = MessageDigest.getInstance("SHA-256");
    byte[] messageDigest = md.digest(input.getBytes());
    BigInteger no = new BigInteger(1, messageDigest);
    hashtext = no.toString(16);
    while (hashtext.length() < 32) {
      hashtext = "0" + hashtext;
    }
  } catch (NoSuchAlgorithmException e) {
    println("Exception thrown for incorrect algorithm: " + e);
  }
  return hashtext;
}

void addNoise() {
  colorMode(RGB, 255); // Set the color mode
  loadPixels();
  for (int i = 0; i < pixels.length; i++) {
    float r = red(pixels[i]);
    float g = green(pixels[i]);
    float b = blue(pixels[i]);
    r += random(-NOISE_DIFF, NOISE_DIFF); // Add random value between -10 and 10 to the red channel
    g += random(-NOISE_DIFF, NOISE_DIFF); // Add random value between -10 and 10 to the green channel
    b += random(-NOISE_DIFF, NOISE_DIFF); // Add random value between -10 and 10 to the blue channel
    // Constrain RGB values to be between 0 and 255
    r = constrain(r, 0, 255);
    g = constrain(g, 0, 255);
    b = constrain(b, 0, 255);
    pixels[i] = color(r, g, b);
  }
  updatePixels();
}