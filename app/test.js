var five = require("johnny-five"),
  board, accel;

board = new five.Board();

board.on("ready", function() {

  // Create a new `Accelerometer` hardware instance.
  //
  // Devices:
  //
  // - Dual Axis http://tinkerkit.tihhs.nl/accelerometer/
  //

  accel = new five.Accelerometer({
    pins: ["I0", "I1"],
    freq: 1000
  });

  // Accelerometer Event API

  // "acceleration"
  //
  // Fires once every N ms, equal to value of freg
  // Defaults to 500ms
  //
  accel.on("acceleration", function(err, timestamp) {

    // console.log("acceleration", this.pitch, this.roll, this.inclination, this.orientation);
		console.log(this.inclination);
  });

  // "axischange"
  //
  // Fires only when X, Y or Z has changed
  //
  accel.on("axischange", function(err, timestamp) {

    console.log("axischange", this.raw);
  });
});
