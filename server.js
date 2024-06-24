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

// Endpoint to fetch questions
app.get('/questions', (req, res) => {
  const questions = [
    "Jika Anda menunjuk sesuatu di ruangan, apakah anak Anda melihatnya? (Misalnya, jika Anda menunjuk hewan atau mainan, apakah anak Anda melihat ke arah hewan atau mainan yang Anda tunjuk?)",
    "Pernahkah Anda berpikir bahwa anak Anda tuli?",
    "Apakah anak Anda pernah bermain pura-pura? (Misalnya, berpura-pura minum dari gelas kosong, berpura-pura berbicara menggunakan telepon, atau menyuapi boneka atau boneka binatang?)",
    "Apakah anak Anda suka memanjat benda-benda? (Misalnya, furniture, alat-alat bermain, atau tangga)",
    "Apakah anak Anda menggerakkan jari-jari tangannya dengan cara yang tidak biasa di dekat matanya? (Misalnya, apakah anak Anda menggoyangkan jari dekat pada matanya?)",
    "Apakah anak Anda pernah menunjuk dengan satu jari untuk meminta sesuatu atau untuk meminta tolong? (Misalnya, menunjuk makanan atau mainan yang jauh dari jangkauannya)",
    "Apakah anak Anda pernah menunjuk dengan satu jari untuk menunjukkan sesuatu yang menarik pada Anda? (Misalnya, menunjuk pada pesawat di langit atau truk besar di jalan)",
    "Apakah anak Anda tertarik pada anak lain? (Misalnya, apakah anak Anda memperhatikan anak lain, tersenyum pada mereka atau pergi ke arah mereka)",
    "Apakah anak Anda pernah memperlihatkan suatu benda dengan membawa atau mengangkatnya kepada Anda tidak untuk minta tolong, hanya untuk berbagi? (Misalnya, memperlihatkan Anda bunga, binatang atau truk mainan)",
    "Apakah anak Anda memberikan respon jika namanya dipanggil? (Misalnya, apakah anak Anda melihat, bicara atau bergumam, atau menghentikan apa yang sedang dilakukannya saat Anda memanggil namanya)",
    "Saat Anda tersenyum pada anak Anda, apakah anak Anda tersenyum balik?",
    "Apakah anak Anda pernah marah saat mendengar suara bising sehari-hari? (Misalnya, apakah anak Anda berteriak atau menangis saat mendengar suara bising seperti vacuum cleaner atau musik keras)",
    "Apakah anak Anda bisa berjalan?",
    "Apakah anak Anda menatap mata Anda saat Anda bicara padanya, bermain bersamanya, atau saat memakaikan pakaian?",
    "Apakah anak Anda mencoba meniru apa yang Anda lakukan? (Misalnya, melambaikan tangan, tepuk tangan atau meniru saat Anda membuat suara lucu)",
    "Jika Anda memutar kepala untuk melihat sesuatu, apakah anak Anda melihat sekeliling untuk melihat apa yang Anda lihat?",
    "Apakah anak Anda mencoba utuk membuat Anda melihat kepadanya? (Misalnya, apakah anak Anda melihat Anda untuk dipuji atau berkata “lihat” atau “lihat aku”)",
    "Apakah anak Anda mengerti saat Anda memintanya melakukan sesuatu? (Misalnya, jika Anda tidak menunjuk, apakah anak Anda mengerti kalimat “letakkan buku itu di atas kursi” atau “ambilkan saya selimut”)",
    "Jika sesuatu yang baru terjadi, apakah anak Anda menatap wajah Anda untuk melihat perasaan Anda tentang hal tersebut? (Misalnya, jika anak Anda mendengar bunyi aneh atau lucu, atau melihat mainan baru, akankah dia menatap wajah Anda?)",
    "Apakah anak Anda menyukai aktivitas yang bergerak? (Misalnya, diayun-ayun atau dihentak-hentakkan pada lutut Anda)"
  ];
  res.status(200).json(questions.map((question, index) => ({ id: index + 1, text: question })));
});

// Start the server
app.listen(port, () => {
  console.log(`Server running at http://localhost:${port}`);
});