const express = require('express');
const cors = require('cors');
const { Pool } = require('pg');
const bodyParser = require('body-parser');
const path = require('path');

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
    const { id, q1, q2, q3, q4, q5, q6, q7, q8, q9, q10, q11, q12, q13, q14, q15, q16, q17, q18, q19, q20, total_score, results } = req.body;

    await pool.query(
      `INSERT INTO assessments (id, q1, q2, q3, q4, q5, q6, q7, q8, q9, q10, q11, q12, q13, q14, q15, q16, q17, q18, q19, q20, total_score, results) 
       VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17, $18, $19, $20, $21, $22, $23)`,
      [id, q1, q2, q3, q4, q5, q6, q7, q8, q9, q10, q11, q12, q13, q14, q15, q16, q17, q18, q19, q20, total_score, results]
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
    const { q1, q2, q3, q4, q5, q6, q7, q8, q9, q10, q11, q12, q13, q14, q15, q16, q17, q18, q19, q20, total_score, results } = req.body;

    await pool.query(
      `UPDATE assessments 
       SET q1 = $1, q2 = $2, q3 = $3, q4 = $4, q5 = $5, q6 = $6, q7 = $7, q8 = $8, q9 = $9, q10 = $10, q11 = $11, q12 = $12, q13 = $13, q14 = $14, q15 = $15, q16 = $16, q17 = $17, q18 = $18, q19 = $19, q20 = $20, total_score = $21, results = $22 
       WHERE response_id = $23`,
      [q1, q2, q3, q4, q5, q6, q7, q8, q9, q10, q11, q12, q13, q14, q15, q16, q17, q18, q19, q20, total_score, results, responseId]
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
                'q1', a.q1,
                'q2', a.q2,
                'q3', a.q3,
                'q4', a.q4,
                'q5', a.q5,
                'q6', a.q6,
                'q7', a.q7,
                'q8', a.q8,
                'q9', a.q9,
                'q10', a.q10,
                'q11', a.q11,
                'q12', a.q12,
                'q13', a.q13,
                'q14', a.q14,
                'q15', a.q15,
                'q16', a.q16,
                'q17', a.q17,
                'q18', a.q18,
                'q19', a.q19,
                'q20', a.q20,
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
    res.status500.json({ error: 'An error occurred while fetching assessments' });
  }
});

// Endpoint to fetch questions with images
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

  const images = [
    'image1.png',
    'image2.png',
    'image3.png',
    'image4.png',
    'image5.png',
    'image6.png',
    'image7.png',
    'image8.png',
    'image9.png',
    'image10.png',
    'image11.png',
    'image12.png',
    'image13.png',
    'image14.png',
    'image15.png',
    'image16.png',
    'image17.png',
    'image18.png',
    'image19.png',
    'image20.png'
  ];

  const githubBaseUrl = 'https://raw.githubusercontent.com/falthackel/tiny-detector/main/flutter_tiny_detector/assets/';

  const questionsWithImages = questions.map((question, index) => ({
    id: index + 1,
    text: question,
    imageUrl: `${githubBaseUrl}${images[index]}`
  }));

  res.status(200).json(questionsWithImages);
});

// Serve static images (if local)
// app.use('/images', express.static(path.join(__dirname, 'flutter_tiny_detector/assets')));

// Start the server
app.listen(port, () => {
  console.log(`Server running at http://localhost:${port}`);
});