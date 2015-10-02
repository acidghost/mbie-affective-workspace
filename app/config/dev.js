/**
 * Created by acidghost on 31/08/15.
 */

module.exports = {

  debug: false,
  freq: 100,
  loopFreq: 1000,
  chartsWindow: 10,
  accel: [
    {
      pins: [ 'I0', 'I1' ],
      autoCalibrate: false
    },
    {
      pins: [ 'I2', 'I3' ],
      autoCalibrate: false
    }
  ]

};
