const supabase = require("../config/supabase");
const { supabaseAdmin } = require("../config/supabase");

// Every public sign-up becomes a "technicien". Admin accounts are never
// created through this endpoint — they're promoted manually by flipping
// the `role` column to 'admin' in the `profiles` table (Supabase Table
// Editor, or a SQL update).
const DEFAULT_ROLE = "technicien";

const signUp = async (name, email, password) => {
  const { data, error } = await supabase.auth.signUp({
    email,
    password,
  });

  if (error) {
    throw error;
  }

  const user = data.user;

  if (!user) {
    // Shouldn't normally happen if there was no error, but guard anyway.
    throw new Error("Sign up did not return a user");
  }

  // Create the matching profile row (full name + role) using the
  // service-role client, since the anon client has no authenticated
  // session to satisfy RLS with at this point.
  const { error: profileError } = await supabaseAdmin
    .from("profiles")
    .insert({
      id: user.id,
      full_name: name,
      role: DEFAULT_ROLE,
    });

  if (profileError) {
    throw profileError;
  }

  return {
    user,
    session: data.session, // null if email confirmation is required
    profile: {
      full_name: name,
      role: DEFAULT_ROLE,
    },
  };
};

const signIn = async (email, password) => {
  const { data, error } = await supabase.auth.signInWithPassword({
    email,
    password,
  });

  if (error) {
    throw error;
  }

  const { data: profile, error: profileError } = await supabaseAdmin
    .from("profiles")
    .select("full_name, role")
    .eq("id", data.user.id)
    .single();

  if (profileError) {
    throw profileError;
  }

  return {
    user: data.user,
    session: data.session,
    profile,
  };
};

module.exports = {
  signUp,
  signIn,
};
