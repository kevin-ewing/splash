const { createCanvas } = require("canvas");
const p5 = require("p5");

// Create a new instance of p5 and attach the sketch.
new p5((sketch) => {
  global.window = global; // Mock global window object for p5
  global.document = {
    createElement: (name) => {
      if (name === "canvas") {
        return createCanvas(400, 400); // Set canvas dimensions as needed
      }
    },
  };

  sketch.setup = () => {
    sketch.createCanvas(400, 400);
    sketch.background(100);
  };

  sketch.draw = () => {
    sketch.ellipse(200, 200, 100, 100);
    sketch.noLoop(); // Stop the draw loop after one iteration
  };

  sketch.saveCanvas = () => {
    const fs = require("fs");
    const canvas = document.createElement("canvas");
    const buffer = canvas.toBuffer("image/png");
    fs.writeFileSync("./output.png", buffer);
  };

  // Call saveCanvas at the end of draw to save the frame as PNG
  sketch.draw = () => {
    sketch.ellipse(200, 200, 100, 100);
    sketch.noLoop(); // Stop loop after one draw
    sketch.saveCanvas(); // Save the canvas as an image
  };
}, {});
