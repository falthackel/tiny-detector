const express = require('express');
const cors = require('cors');
const { Pool } = require('pg');
const bodyParser = require('body-parser');
const { Sequelize, DataTypes } = require('sequelize');

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
  port: 5432, // PostgreSQL default port is 5432
});

// Initialize Sequelize
const sequelize = new Sequelize('balita', 'saya', 'password', {
  host: 'localhost',
  dialect: 'postgres'
});

// Define models
const Users = sequelize.define('users', {
  id: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true
  },
  name: {
    type: DataTypes.STRING,
    allowNull: false
  },
  domicile: {
    type: DataTypes.STRING,
    allowNull: false
  },
  gender: {
    type: DataTypes.INTEGER,
    allowNull: false
  },
  age: {
    type: DataTypes.INTEGER,
    allowNull: false
  }
}, {
  tableName: 'users', // specify the actual table name here
  timestamps: false
});

const Assessment = sequelize.define('assessments', {
  response_id: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true
  },
  id: {
    type: DataTypes.INTEGER,
    allowNull: false,
    references: {
      model: Users,
      key: 'id'
    }
  },
  q1: DataTypes.INTEGER,
  q2: DataTypes.INTEGER,
  q3: DataTypes.INTEGER,
  q4: DataTypes.INTEGER,
  q5: DataTypes.INTEGER,
  q6: DataTypes.INTEGER,
  q7: DataTypes.INTEGER,
  q8: DataTypes.INTEGER,
  q9: DataTypes.INTEGER,
  q10: DataTypes.INTEGER,
  q11: DataTypes.INTEGER,
  q12: DataTypes.INTEGER,
  q13: DataTypes.INTEGER,
  q14: DataTypes.INTEGER,
  q15: DataTypes.INTEGER,
  q16: DataTypes.INTEGER,
  q17: DataTypes.INTEGER,
  q18: DataTypes.INTEGER,
  q19: DataTypes.INTEGER,
  q20: DataTypes.INTEGER,
  total_score: DataTypes.INTEGER,
  results: DataTypes.INTEGER
}, {
  tableName: 'assessments', // specify the actual table name here
  timestamps: false
});

Users.hasMany(Assessment, { foreignKey: 'id' });
Assessment.belongsTo(Users, { foreignKey: 'id' });

// Sync database
sequelize.sync();

// Simple endpoint to return a message
app.get('/', (req, res) => {
  res.send('Hello World!');
});

app.get('/users', async (req, res) => {
  try {
    const users = await Users.findAll();
    res.status(200).json(users);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'An error occurred while fetching users' });
  }
});

// Define routes
app.post('/users', async (req, res) => {
  try {
    const newUser = await Users.create(req.body);
    res.status(201).json(newUser);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
});

app.get('/assessments', async (req, res) => {
  try {
    const assessments = await Assessment.findAll();
    res.status(200).json(assessments);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'An error occurred while fetching assessments' });
  }
});

app.post('/assessments', async (req, res) => {
  try {
    const assessment = await Assessment.create(req.body);
    res.json(assessment);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
});

// Define user-assessment endpoint
app.get('/user-assessments', async (req, res) => {
  try {
    const users = await Users.findAll({
      include: {
        model: Assessment,
        attributes: ['response_id', 'total_score', 'results'],
      },
    });

    const result = users.map(user => ({
      id: user.id,
      name: user.name,
      domicile: user.domicile,
      gender: user.gender,
      age: user.age,
      assessments: user.assessments.map(assessment => ({
        response_id: assessment.response_id,
        total_score: assessment.total_score,
        results: assessment.results,
      }))
    }));

    res.status(200).json(result);
  } 
  catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Internal Server Error' });
  }
});

app.post('/submit-answers', async (req, res) => {
  const { answers, totalScore } = req.body;

  try {
    const result = await pool.query(
      'INSERT INTO answers (answers, total_score) VALUES ($1, $2) RETURNING *',
      [answers, totalScore]
    );
    res.status(201).json(result.rows[0]);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Internal Server Error' });
  }
});

app.listen(port, () => {
  console.log(`Server running at http://localhost:${port}`);
});