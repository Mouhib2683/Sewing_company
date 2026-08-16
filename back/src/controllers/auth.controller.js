const authService = require("../services/auth.service");

const signUp = async (req, res) => {
  try {
    const { email, password } = req.body;

    if (!email || !password) {
      return res.status(400).json({
        success: false,
        message: "Email and password are required",
      });
    }

    const data = await authService.signUp(email, password);

    return res.status(201).json({
      success: true,
      message: "Account created successfully",
      data,
    });
  } catch (error) {
    console.error("Signup error:", error);

    return res.status(400).json({
      success: false,
      message: error.message,
    });
  }
};

const signIn = async (req, res) => {
  try {
    const { email, password } = req.body;

    if (!email || !password) {
      return res.status(400).json({
        success: false,
        message: "Email and password are required",
      });
    }

    const data = await authService.signIn(email, password);

    return res.status(200).json({
      success: true,
      message: "Login successful",
      data,
    });
  } catch (error) {
    console.error("Signin error:", error);

    return res.status(401).json({
      success: false,
      message: error.message,
    });
  }
};

module.exports = {
  signUp,
  signIn,
};