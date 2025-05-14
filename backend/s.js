const express = require('express');
const bodyParser = require('body-parser');
const nodemailer = require('nodemailer');
const app = express();

// Middleware to parse form data
app.use(bodyParser.urlencoded({ extended: true }));

// Serve a simple HTML form
app.get('/', (req, res) => {
  res.send(`
    <h1>Contact Us</h1>
    <form method="POST" action="/send">
      <input type="text" name="name" placeholder="Your Name" required><br>
      <input type="email" name="email" placeholder="Your Email" required><br>
      <textarea name="message" placeholder="Your Message" required></textarea><br>
      <button type="submit">Send</button>
    </form>
  `);
});

// Handle form submission and send email
app.post('/send', async (req, res) => {
  const { name, email, message } = req.body;

  // Configure Nodemailer (using Gmail SMTP)
  const transporter = nodemailer.createTransport({
    service: 'gmail',
    auth: {
      user: 'f223616@cfd.nu.edu.pk', 
      pass: 'pynmcgrysuhqrins',   
    },
  });

  // Email content
  const mailOptions = {
    from: email,
    to: 'f223615@cfd.nu.edu.pk', // Where you want to receive emails
    subject: `Ne message from ${name}`,
    text: message,
  };

  try {
    await transporter.sendMail(mailOptions);
    res.send('Email sent successfully!');
  } catch (error) {
    console.error(error);
    res.status(500).send('Error sending email.');
  }
});

// Start the server
const PORT = 3000;
app.listen(PORT, () => {
  console.log(`Server running on http://localhost:${PORT}`);
});