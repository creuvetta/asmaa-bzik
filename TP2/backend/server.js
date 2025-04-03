const express = require('express');
const multer = require('multer');
const cors = require('cors');
const path = require('path');

const app = express();
const upload = multer({ dest: 'uploads/' });

// Stockage temporaire en mémoire (simule une base de données)
let shows = [
  {
    id: 1,
    title: "Mon premier film",
    description: "Une super description",
    category: "movie",
    image: null
  }
];

app.use(cors());
app.use(express.json());
app.use('/uploads', express.static('uploads'));

// Routes
app.get('/shows', (req, res) => {
  res.json(shows);
});

app.post('/shows', upload.single('image'), (req, res) => {
  const newShow = {
    id: shows.length + 1,
    title: req.body.title,
    description: req.body.description,
    category: req.body.category,
    image: req.file ? '/uploads/' + req.file.filename : null
  };
  
  shows.push(newShow);
  res.status(201).json(newShow);
});

app.delete('/shows/:id', (req, res) => {
  const id = parseInt(req.params.id);
  shows = shows.filter(show => show.id !== id);
  res.json({ message: 'Show deleted' });
});

const PORT = 5000;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
  console.log(`Test with: http://localhost:${PORT}/shows`);
});