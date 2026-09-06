import Timer from "timer";

let state = false;

Timer.repeat(() => {
  state = !state;
  trace(`LED ${state ? "ON" : "OFF"}\n`);
}, 500);
