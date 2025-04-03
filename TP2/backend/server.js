const express = require('express');
const multer = require('multer');
const cors = require('cors');
const path = require('path');

const app = express();
const storage = multer.diskStorage({
  destination: 'uploads/',
  filename: (req, file, cb) => {
    cb(null, Date.now() + path.extname(file.originalname));
  }
});

const upload = multer({ storage });
let shows = [];
let users = [{ id: 1, email: 'test@test.com', password: 'password' }];

app.use(cors());
app.use(express.json());
app.use('/uploads', express.static('uploads'));

// Authentification
app.post('/login', (req, res) => {
  const { email, password } = req.body;
  const user = users.find(u => u.email === email && u.password === password);
  
  if (user) {
    res.json({ token: 'fake-jwt-token', userId: user.id });
  } else {
    res.status(401).json({ error: 'Identifiants incorrects' });
  }
});

// Routes protégées
app.use((req, res, next) => {
  const authHeader = req.headers.authorization;
  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    return res.status(401).json({ error: 'Non autorisé' });
  }
  next();
});

// CRUD Shows
app.get('/shows', (req, res) => res.json(shows));

app.post('/shows', upload.single('image'), (req, res) => {
  const newShow = {
    id: shows.length + 1,
    ...req.body,
    image: req.file ? '/uploads/' + req.file.filename : null
  };
  shows.push(newShow);
  res.status(201).json(newShow);
});

app.put('/shows/:id', upload.single('image'), (req, res) => {
  const id = parseInt(req.params.id);
  const show = shows.find(s => s.id === id);
  
  if (!show) return res.status(404).json({ error: 'Show non trouvé' });
  
  Object.assign(show, req.body);
  if (req.file) show.image = '/uploads/' + req.file.filename;
  
  res.json(show);
});

app.delete('/shows/:id', (req, res) => {
  const id = parseInt(req.params.id);
  shows = shows.filter(s => s.id !== id);
  res.json({ message: 'Show supprimé' });
});

const PORT = 5000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
