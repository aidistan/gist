#!/usr/bin/env node
const addon = require('./build/Release/addon');

addon(function(msg){
  console.log(msg);
});
