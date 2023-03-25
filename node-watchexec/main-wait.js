const log = () => console.log('waiting for replacement at', process.argv[1]);
log();
setInterval(log, 5000);
