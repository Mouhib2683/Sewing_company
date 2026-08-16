const authService = require("../services/auth.service");

const signUp = async (req, res) => {
  try {
    const { name, email, password } = req.body;

    if (!name || !email || !password) {
      return res.status(400).json({
        success: false,
        message: "Name, email and password are required",
      });
    }

    const data = await authService.signUp(name, email, password);

    return res.status(201).json({
      success: true,
      message: data.session
        ? "Account created successfully"
        : "Account created. Please check your email to confirm before signing in.",
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
