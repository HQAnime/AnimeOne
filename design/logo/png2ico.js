const fs = require('fs');
const pngToIco = require('png-to-ico');

pngToIco('round.png')
  .then(buf => {
    fs.writeFileSync('app_icon.ico', buf);
  })
  .catch(console.error);