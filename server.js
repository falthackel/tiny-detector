const express = require('express');
const cors = require('cors');
const { Pool } = require('pg');
const bodyParser = require('body-parser');

const app = express();
const port = 3000;
app.use(cors());
app.use(express.json());
app.use(bodyParser.json());

// PostgreSQL connection setup
const pool = new Pool({
  user: 'saya',
  host: 'localhost',
  database: 'balita',
  password: 'password',
  port: 5432,
});

// Endpoint to fetch all users
app.get('/users', async (req, res) => {
  try {
    const users = await pool.query('SELECT * FROM users');
    res.status(200).json(users.rows);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'An error occurred while fetching users' });
  }
});

// Endpoint to create a new user
app.post('/users', async (req, res) => {
  try {
    const { name, domicile, gender, age } = req.body;
    const newUser = await pool.query(
      'INSERT INTO users (name, domicile, gender, age) VALUES ($1, $2, $3, $4) RETURNING *',
      [name, domicile, gender, age]
    );
    res.status(201).json(newUser.rows[0]);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
});

// Endpoint to check if a user exists
app.post('/users/check', async (req, res) => {
  try {
    const { name, domicile, gender, age } = req.body;
    const user = await pool.query(
      'SELECT * FROM users WHERE name = $1 AND domicile = $2 AND gender = $3 AND age = $4',
      [name, domicile, gender, age]
    );

    if (user.rows.length > 0) {
      res.status(200).json({ exists: true });
    } else {
      res.status(200).json({ exists: false });
    }
  } catch (error) {
    console.error('Error checking user existence:', error.message);
    res.status(500).json({ error: 'An error occurred while checking user existence' });
  }
});

// Endpoint to submit assessment answers
app.post('/assessments', async (req, res) => {
  try {
    const { id, ...answers } = req.body;
    const totalScore = Object.values(answers).filter(value => value).length;
    const result = totalScore <= 2 ? 1 : totalScore <= 7 ? 2 : 3;

    await pool.query(
      'INSERT INTO assessments (id, total_score, results) VALUES ($1, $2, $3)',
      [id, totalScore, result]
    );

    res.status(200).json({ success: true });
  } catch (error) {
    console.error('Error submitting assessment:', error.message);
    res.status(500).json({ error: 'An error occurred while submitting the assessment' });
  }
});

// Endpoint to update assessment
app.put('/assessments/:responseId', async (req, res) => {
  try {
    const { responseId } = req.params;
    const answers = req.body;
    const totalScore = Object.values(answers).filter(value => value).length;
    const result = totalScore <= 2 ? 1 : totalScore <= 7 ? 2 : 3;

    await pool.query(
      'UPDATE assessments SET total_score = $1, results = $2 WHERE response_id = $3',
      [totalScore, result, responseId]
    );

    res.status(200).json({ success: true });
  } catch (error) {
    console.error('Error updating assessment:', error.message);
    res.status(500).json({ error: 'An error occurred while updating the assessment' });
  }
});

app.get('/user-assessments/:userId', async (req, res) => {
  try {
    const { userId } = req.params;
    const result = await pool.query(
      `SELECT u.id, u.name, u.domicile, u.gender, u.age, 
              json_agg(json_build_object(
                'response_id', a.response_id,
                'total_score', a.total_score,
                'results', a.results
              )) as assessments
       FROM users u
       JOIN assessments a ON u.id = a.id
       WHERE u.id = $1
       GROUP BY u.id`,
      [userId]
    );
    if (result.rows.length === 0) {
      res.status(404).json({ error: 'User not found' });
    } else {
      res.status(200).json(result.rows[0]);
    }
  } catch (error) {
    console.error('Error fetching user assessments:', error.message);
    res.status(500).json({ error: 'An error occurred while fetching assessments' });
  }
});

// Start the server
app.listen(port, () => {
  console.log(`Server running at http://localhost:${port}`);
});