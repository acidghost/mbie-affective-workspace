/**
 * Created by acidghost on 31/08/15.
 */

module.exports = {

  debug: {
    sensors: false,
    info: true
  },
  freq: 100,
  loopFreq: 1000,
  chartsWindow: 30,
  maxSeatingIterations: 30,
  postureThreshold: 0.5,
  initialPreferred: 0.53,
  initialWeight: 1,
  postureDecrement: 0.01,
  weightIncrement: 0.1,
  supportThreshold: 0.01,
  accel: [
    {
      pins: [ 'I0', 'I1' ],
      autoCalibrate: false
    },
    {
      pins: [ 'I2', 'I3' ],
      autoCalibrate: false
    },
    {
      pins: [ 'I4', 'I5' ],
      autoCalibrate: false
    }
  ]

};
