const NOISE_DIFF = 40;

let NUMBER_COLORS = 3;
let NOISE_SCALE = 0.002;
let CIRCLE_SCALE = 29;
let CIRCLE_OP = 100;

function preload() {
  // Specify the path to your SF Pro font file
  font = loadFont(
    "https://fonts.gstatic.com/s/abeezee/v22/esDR31xSG-6AGleN6tKukbcHCpE.ttf"
  );
}

function setup() {
  createCanvas(1400, 350);
  ellipseMode(CENTER);
  background(256);
  noLoop();
}

function draw() {
  let palette = generatePalette();
  for (let x = 0; x < NUMBER_COLORS; x++) {
    circles(palette[x], x);
  }
  addDesc(palette);
  addNoise();
}

function generatePalette() {
  colorMode(HSB, 360, 100, 100, 100);
  let palette = Array(NUMBER_COLORS); // Clear previous palette
  let baseHue = random(0, 360); // Starting hue
  let colorType = floor(random(4)); // 0: Analogous, 1: Complimentary, 2: Triadic, 3: Monochromatic
  switch (colorType) {
    case 0: // Analogous
      console.log("Analogous");
      for (let i = 0; i < NUMBER_COLORS; i++) {
        palette[i] = [(baseHue + i * 30) % 360, 80, 80];
      }
      break;
    case 1: // Complimentary
      console.log("Complimentary");
      for (let i = 0; i < NUMBER_COLORS; i++) {
        palette[i] = [(baseHue + i * 180) % 360, 80, 80];
      }
      break;
    case 2: // Triadic
      console.log("Triadic");
      for (let i = 0; i < NUMBER_COLORS; i++) {
        console.log("");
        palette[i] = [(baseHue + i * 120) % 360, 80, 80];
      }
      break;
    case 3: // Monochromatic
      console.log("Monochromatic");
      for (let i = 0; i < NUMBER_COLORS; i++) {
        palette[i] = [baseHue, 80, (60 + i * 20) % 100]; // Change brightness for monochromatic
      }
      break;
  }
  return palette;
}

function circles(color, seed) {
  noFill();
  stroke(color[0], color[1], color[2], CIRCLE_OP);
  strokeWeight(2);
  let spacing = 20;
  for (let x = 0; x <= width; x += spacing) {
    // Adjust grid spacing and circle size by changing 20
    for (let y = 0; y <= height; y += spacing) {
      // Adjust grid spacing and circle size by changing 20
      let radius =
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

function addDesc(palette) {
  noStroke();
  fill(256);
  rect(width - 380, height - 20, width, height);

  fill(palette[0]);
  textFont(font);
  textSize(14);
  text(
    "Generated with https://github.com/kevin-ewing/splash",
    width - 375,
    height - 6
  );
}

function addNoise() {
  // Add noise to the image
  loadPixels();
  for (let i = 0; i < width; i++) {
    for (let j = 0; j < height * 4; j++) {
      let index = (i + j * width) * 4;
      let r = pixels[index];
      let g = pixels[index + 1];
      let b = pixels[index + 2];

      // Add noise to the color values
      r += random(-NOISE_DIFF, NOISE_DIFF);
      g += random(-NOISE_DIFF, NOISE_DIFF);
      b += random(-NOISE_DIFF, NOISE_DIFF);

      pixels[index] = r;
      pixels[index + 1] = g;
      pixels[index + 2] = b;
    }
  }
  updatePixels();
}
