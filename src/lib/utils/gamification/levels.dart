// Defining levels
const levels = {
  1: 100,
  2: 245,
  3: 420,
  4: 620,
  5: 845,
  6: 1090,
  7: 1355,
  8: 1640,
  9: 1940,
  10: 2260
};

// Level calculation constants.
const basePoints = 50;

const nonEventTaskMultiplier = 0.6;

const taskComboMultiplier = 0.2;
const taskComboPoints = 30;

const moduleComboMultiplier = 0.5;
const moduleComboPoints = 20;

// Pomodoro constants
const sessionBonus = 6; //0.2*30*number of sessions
const longerBreakPoints = 35;
const longerWorkPoints = 40;
