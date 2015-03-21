var nodeWin = require('node-windows');

if(process.platform === 'win32') {
    nodeWin.elevate('calc');
}