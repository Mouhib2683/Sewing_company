const { supabaseAdmin } = require("../config/supabase");

const createReport = async (report) => {
  const { data, error } = await supabaseAdmin
    .from("reports")
    .insert({
      technician_id: report.technicianId,
      technician_name: report.technicianName,
      machine_code: report.machineCode,
      failure_type: report.failureType,
      accepted_at: report.acceptedAt,
      repair_started_at: report.repairStartedAt,
      repair_ended_at: report.repairEndedAt,
      problem_description: report.problemDescription,
      solution_applied: report.solutionApplied,
      notes: report.notes || null,
    })
    .select()
    .single();

  if (error) {
    throw error;
  }

  return data;
};

// Admin-only: every report, most recent first.
const listReports = async () => {
  const { data, error } = await supabaseAdmin
    .from("reports")
    .select("*")
    .order("created_at", { ascending: false });

  if (error) {
    throw error;
  }

  return data;
};

const getReportById = async (id) => {
  const { data, error } = await supabaseAdmin
    .from("reports")
    .select("*")
    .eq("id", id)
    .single();

  if (error) {
    throw error;
  }

  return data;
};

module.exports = {
  createReport,
  listReports,
  getReportById,
};
