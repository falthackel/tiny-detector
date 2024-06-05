const express = require('express');
const cors = require('cors');
const { Pool } = require('pg');

const app = express();
const port = 3000;
app.use(cors());
app.use(express.json());

// PostgreSQL connection setup
const pool = new Pool({
  user: 'saya',
  host: 'localhost',
  database: 'balita',
  password: 'password',
  port: 5432, // PostgreSQL default port is 5432
});

// Simple endpoint to return a message
app.get('/', (req, res) => {
  res.send('Hello World!');
});

// API endpoint to return data from 'users' table
app.get('/users', async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM users');
    res.json({ message: result.rows }); // Wrap rows in a message key
  } catch (err) {
    console.error('Error executing query', err.stack);
    res.status(500).json({ error: 'Failed to fetch data from the database' });
  }
});

// API endpoint to return data from 'assessments' table
app.get('/assessments', async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM assessments');
    res.json({ message: result.rows }); // Wrap rows in a message key
  } catch (err) {
    console.error('Error executing query', err.stack);
    res.status(500).json({ error: 'Failed to fetch data from the database' });
  }
});

// API endpoint to return combined data from 'users' and 'assessments' tables
app.get('/user-assessments', async (req, res) => {
  try {
    const result = await pool.query(`
      SELECT u.id, u.name, u.domicile, u.gender, u.age, a.results 
      FROM users u
      JOIN assessments a ON u.id = a.id
    `);
    res.json({ message: result.rows }); // Wrap rows in a message key
  } catch (err) {
    console.error('Error executing query', err.stack);
    res.status(500).json({ error: 'Failed to fetch data from the database' });
  }
});

app.listen(port, () => {
  console.log(`Server running at http://localhost:${port}`);
});