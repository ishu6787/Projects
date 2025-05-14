const User = require('../models/User');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const sendEmail = require('../utils/sendEmail');

exports.signup = async (req, res) => {
  const { email, password } = req.body;

  try {
    const existing = await User.findOne({ email });
    if (existing) return res.status(400).json({ message: 'User already exists' });

    const hashed = await bcrypt.hash(password, 10);
    const user = await User.create({ email, password: hashed });

    res.status(201).json({ message: 'User created' });
  } catch (err) {
    res.status(500).json({ message: 'Signup failed' });
  }
};

exports.login = async (req, res) => {
    const { email, password } = req.body;
    console.log("Login attempt for:", email);  // Debug log
  
    try {
      const user = await User.findOne({ email });
      if (!user) {
        console.log("User not found:", email);
        return res.status(400).json({ message: 'Invalid credentials' });
      }
  
      console.log("Found user:", user.email);  // Debug log
      const isMatch = await bcrypt.compare(password, user.password);
      console.log("Password match:", isMatch);  // Debug log
  
      if (!isMatch) {
        return res.status(400).json({ message: 'Invalid credentials' });
      }
  
      // Add this temporary debug response:
      res.status(200).json({ 
        message: 'Login successful',
        debug: {
          inputPassword: password,
          storedHash: user.password,
          matchResult: isMatch
        }
      });
      
    } catch (err) {
      console.error("Login error:", err);
      res.status(500).json({ message: 'Login error' });
    }
  };

exports.forgotPassword = async (req, res) => {
  const { email } = req.body;

  try {
    const user = await User.findOne({ email });
    if (!user) return res.status(400).json({ message: 'Email not found' });

    const token = jwt.sign({ id: user._id }, process.env.JWT_SECRET, { expiresIn: '15m' });

    user.resetToken = token;
    user.resetTokenExpiry = Date.now() + 15 * 60 * 1000;
    await user.save();

    
    const resetURL = `http://localhost:5000/signin.html?token=${token}`;
    await sendEmail(email, 'DEVSKILL Password Reset', `Click to reset: ${resetURL}`);

    res.status(200).json({ message: 'Password reset email sent' });
  } catch {
    res.status(500).json({ message: 'Failed to send reset email' });
  }
};

exports.resetPassword = async (req, res) => {
  const { token, newPassword } = req.body;

  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    const user = await User.findOne({
      _id: decoded.id,
      resetToken: token,
      resetTokenExpiry: { $gt: Date.now() },
    });

    if (!user) return res.status(400).json({ message: 'Invalid or expired token' });

    user.password = await bcrypt.hash(newPassword, 10);
    user.resetToken = undefined;
    user.resetTokenExpiry = undefined;
    await user.save();

    res.status(200).json({ message: 'Password successfully reset' });
  } catch {
    res.status(500).json({ message: 'Reset failed' });
  }
};
