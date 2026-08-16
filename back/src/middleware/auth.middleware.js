const supabase = require("../config/supabase");
const { supabaseAdmin } = require("../config/supabase");

// Verifies the `Authorization: Bearer <access_token>` header against
// Supabase, then loads that user's profile (full_name, role) and attaches
// both to req.user / req.profile for downstream handlers.
const requireAuth = async (req, res, next) => {
  try {
    const authHeader = req.headers.authorization || "";
    const token = authHeader.startsWith("Bearer ")
      ? authHeader.slice("Bearer ".length)
      : null;

    if (!token) {
      return res.status(401).json({
        success: false,
        message: "Missing or invalid Authorization header",
      });
    }

    const { data, error } = await supabase.auth.getUser(token);

    if (error || !data.user) {
      return res.status(401).json({
        success: false,
        message: "Invalid or expired session",
      });
    }

    const { data: profile, error: profileError } = await supabaseAdmin
      .from("profiles")
      .select("full_name, role")
      .eq("id", data.user.id)
      .single();

    if (profileError || !profile) {
      return res.status(401).json({
        success: false,
        message: "No profile found for this account",
      });
    }

    req.user = data.user;
    req.profile = profile;

    return next();
  } catch (error) {
    console.error("Auth middleware error:", error);
    return res.status(500).json({
      success: false,
      message: "Failed to verify authentication",
    });
  }
};

// Must be used after requireAuth.
const requireAdmin = (req, res, next) => {
  if (!req.profile || req.profile.role !== "admin") {
    return res.status(403).json({
      success: false,
      message: "Admin access required",
    });
  }
  return next();
};

module.exports = {
  requireAuth,
  requireAdmin,
};
