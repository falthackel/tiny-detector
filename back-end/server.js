const express = require('express');
const cors = require('cors');
const { Pool } = require('pg');
const bodyParser = require('body-parser');
const jwt = require('jsonwebtoken');

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

function generateToken(userId) {
  const payload = { userId };
  const secret = 'your-secret-key'; // Replace with your secret key
  const options = { expiresIn: '1h' }; // Token expires in 1 hour

  const token = jwt.sign(payload, secret, options);
  return token;
}

// Example usage
const userId = 1; // Replace with actual user ID
const token = generateToken(userId);

// Endpoint to get assessor profile
app.post("/users", async (req, res) => {
  try {
    const { assessor_email } = req.body; // Extract from request body
    const assessor = await pool.query(
      'SELECT * FROM assessor WHERE assessor_email = $1',
      [assessor_email]
    );

    if (assessor.rows.length === 0) {
      return res.status(404).json({ error: 'Assessor not found' });
    }

    res.status(200).json(assessor.rows);
  } catch (error) {
    console.error('Error fetching users:', error);
    res.status(500).json({ error: 'An error occurred while fetching users' });
  }
});

// Endpoint to check if the Assessor exists
app.post('/check/assessor', async (req, res) => {
  try {
    const { assessor_name, assessor_email } = req.body;
    const assessor = await pool.query(
      'SELECT * FROM assessor WHERE assessor_name = $1 AND assessor_email = $2',
      [assessor_name, assessor_email]
    );

    if (assessor.rows.length > 0) {
      res.status(200).json({ exists: true });
    } else {
      res.status(200).json({ exists: false });
    }
  } catch (error) {
    console.error('Error checking user existence:', error.message);
    res.status(500).json({ error: 'An error occurred while checking user existence' });
  }
});

// Endpoint to check if the toddler exists
app.post('/check/toddler', async (req, res) => {
  try {
    const { toddler_name, toddler_domicile, toddler_gender, toddler_age, assessor_id } = req.body;
    const toddler = await pool.query(
      'SELECT * FROM toddler WHERE toddler_name = $1 AND toddler_domicile = $2 AND toddler_gender = $3 AND toddler_age = $4 AND assessor_id = $5',
      [toddler_name, toddler_domicile, toddler_gender, toddler_age, assessor_id]
    );

    if (toddler.rows.length > 0) {
      res.status(200).json({ exists: true });
    } else {
      res.status(200).json({ exists: false });
    }
  } catch (error) {
    console.error('Error checking user existence:', error.message);
    res.status(500).json({ error: 'An error occurred while checking user existence' });
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

  const githubBaseUrl = 'https://raw.githubusercontent.com/falthackel/tiny-detector/main/front-end/assets/';

  const questionsWithImages = questions.map((question, index) => ({
    id: index + 1,
    text: question,
    imageUrl: `${githubBaseUrl}${images[index]}`
  }));

  res.status(200).json(questionsWithImages);
});

app.post("/login", async (req, res) => {
  try{
    const { assessor_email, assessor_password } = req.body;
    const assessor = await pool.query(
      'SELECT * FROM assessor WHERE assessor_email = $1 AND assessor_password = $2',
      [assessor_email, assessor_password]
    )
    if (assessor.rows.length > 0) {
      const userId = assessor.rows[0].assessor_id;
      const token = generateToken(userId);
      res.status(200).json({ token });
    } else {
      res.status(401).json({ error: 'Invalid credentials' });
    }
  } catch (error){
    console.error(error);
    res.status(500).json({ error: 'An error occurred while logging in' });
  }
})

app.post("/signup", async (req, res) => {
  try{
    const { assessor_name, assessor_age, assessor_profession, assessor_email, assessor_password } = req.body;
    const newAsessor = await pool.query(
      'INSERT INTO assessor (assessor_name, assessor_age, assessor_profession, assessor_email, assessor_password) VALUES ($1, $2, $3, $4, $5) RETURNING *',
      [assessor_name, assessor_age, assessor_profession, assessor_email, assessor_password]
    );
    res.status(201).json(newAsessor.rows[0]);
  } catch (error) {
    console.error('Error during signup:', error.message);
    res.status(400).json({ error: error.message });
  }
})

app.post("/unsubmitted", async (req, res) => {
  try {
    const { assessor_id } = req.body;
    const toddler = await pool.query('SELECT * FROM toddler WHERE result IS NULL AND assessor_id = $1 ORDER BY updated_at DESC',
      [assessor_id]
    );
    res.status(200).json(toddler.rows);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'An error occurred while fetching users' });
  }
})

app.post("/submitted", async (req, res) => {
  try {
    const { assessor_id } = req.body;
    const toddler = await pool.query('SELECT * FROM toddler WHERE result IS NOT NULL AND assessor_id = $1 ORDER BY updated_at DESC',
      [assessor_id]
    );
    res.status(200).json(toddler.rows);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'An error occurred while fetching users' });
  }
})

app.post('/form', async (req, res) => {
  try {
    const { toddler_name, toddler_domicile, toddler_gender, toddler_age, assessor_id } = req.body;
    const newToddler = await pool.query(
      'INSERT INTO toddler (toddler_name, toddler_domicile, toddler_gender, toddler_age, assessor_id) VALUES ($1, $2, $3, $4, $5) RETURNING *',
      [toddler_name, toddler_domicile, toddler_gender, toddler_age, assessor_id]
    );
    res.status(201).json(newToddler.rows[0]);
  } catch (error) {
    console.error('Error during toddler creation:', error.message);  // Add console log
    res.status(400).json({ error: error.message });
  }
});

app.put('/form', async (req, res) => {
  try {
    const { toddler_id, qid, answer } = req.body;
    const updated = await pool.query(
      `UPDATE toddler SET q${qid} = $1 WHERE toddler_id = $2 RETURNING *`,
      [answer, toddler_id]
    )
    res.status(200).json(updated.rows[0]);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
})

app.post('/submit', async (req, res) => {
  try {
    const { toddler_id } = req.body;
    const toddlers = await pool.query("SELECT * FROM toddler WHERE toddler_id = $1", [toddler_id])
    const toddler = toddlers.rows[0];

    let sum = 0;

    for (let i = 0; i < 20; i++) {
      if (i == 1 || i == 4 || i == 11) {
        sum += parseInt(toddler[`q${i+1}`])
      } else {
        sum += 1 - parseInt(toddler[`q${i+1}`])
      }
    }

    const total_score = sum;
    let result = -1
    if (total_score >= 0 && total_score <= 2) {
      result = 1;
    } else if (total_score >= 3 && total_score <= 7) {
      result = 2;
    } else if (total_score >= 8 && total_score <= 20) {
      result = 3;
    }
    console.log(toddler_id, total_score, result)
    
    const updated = await pool.query(
      `UPDATE toddler SET total_score = $1, result = $2 WHERE toddler_id = $3 RETURNING *`,
      [total_score, result, toddler_id]
    )
    res.status(200).json(updated.rows[0]);
  } catch (error) {
    console.error(error)
    res.status(400).json({ error: error.message });
  }
})

app.get('/toddler/:toddler_id', async (req, res) => {
  try {
    const { toddler_id } = req.params;

    const toddler = await pool.query('SELECT * FROM toddler WHERE toddler_id = $1', [toddler_id]);
    if (toddler.rows.length > 0) {
      res.status(200).json(toddler.rows[0]);
    } else {
      res.status(404).json({ error: 'Toddler not found' });
    }
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'An error occurred while fetching users' });
  }
})

// Start the server
app.listen(port, () => {
  console.log(`Server running at http://localhost:${port}`);
});