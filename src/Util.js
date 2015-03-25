var exec = require('exec');
var Promise = require('bluebird');
var fs = require('fs');
var path = require('path');
var open = require('open');

module.exports = {
  exec: function (args, options) {
    options = options || {};
    return new Promise((resolve, reject) => {
      exec(args, options, (stderr, stdout, code) => {
        if (code) {
          var cmd = Array.isArray(args) ? args.join(' ') : args;
          reject(new Error(cmd + ' returned non zero exit code\nstdout:' + stdout + '\nstderr:' + stderr));
        } else {
          resolve(stdout);
        }
      });
    });
  },
  home: function () {
    return process.env[this.isWindows() ? 'USERPROFILE' : 'HOME'];
  },
  openPathOrUrl: function (pathOrUrl, callback) {
    open(pathOrUrl, callback);
  },
  supportDir: function () {
    var dirs = ['Library', 'Application\ Support', 'Kitematic'];
    var acc = this.home();
    dirs.forEach(function (d) {
      acc = path.join(acc, d);
      if (!fs.existsSync(acc)) {
        fs.mkdirSync(acc);
      }
    });
    return acc;
  },
  resourceDir: function () {
    return process.env.RESOURCES_PATH;
  },
  packagejson: function () {
    return JSON.parse(fs.readFileSync(path.join(__dirname, '..', 'package.json'), 'utf8'));
  },
  settingsjson: function () {
    var settingsjson = {};
    try {
      settingsjson = JSON.parse(fs.readFileSync(path.join(__dirname, '..', 'settings.json'), 'utf8'));
    } catch (err) {}
    return settingsjson;
  },
  isWindows: function () {
    return process.platform === 'win32';
  }
  webPorts: ['80', '8000', '8080', '3000', '5000', '2368', '9200', '8983']
};
