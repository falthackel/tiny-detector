const express = require('express');
const cors = require('cors');

const app = express();
const port = 3000;
app.use(cors());

// Middleware to parse JSON bodies
app.use(express.json());

// Simple endpoint to return a message
app.get('/', (req, res) => {
  res.send('Hello World!');
});

// API endpoint to return data
app.get('/api/data', (req, res) => {
  res.json({ message: 'Hello from the API' });
});

app.listen(port, () => {
  console.log(`Server running at http://localhost:${port}`);
});
