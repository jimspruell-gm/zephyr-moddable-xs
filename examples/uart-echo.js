function onSerialData(data) {
  trace(`RX: ${data}\n`);
  trace(`TX: ${data}\n`);
}

onSerialData("echo test");
