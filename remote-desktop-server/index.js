const express = require('express');
const http = require('http');
const { Server } = require('socket.io');
const { exec } = require('child_process');

const app = express();
const server = http.createServer(app);
const io = new Server(server, {
  cors: {
    origin: '*',
  },
});

io.on('connection', (socket) => {
  console.log('New client connected');

  // Command to capture and send screen data
  socket.on('request-screen', () => {
    exec('screencapture -x temp.jpg', (err) => {
      if (!err) {
        socket.emit('screen-data', 'temp.jpg'); // Send image path
      }
    });
  });

  // Handle remote commands
  socket.on('run-command', (cmd) => {
    exec(cmd, (error, stdout, stderr) => {
      socket.emit('command-output', error ? stderr : stdout);
    });
  });

  socket.on('disconnect', () => {
    console.log('Client disconnected');
  });
});

server.listen(3000, () => {
  console.log('Server listening on port 3000');
});


