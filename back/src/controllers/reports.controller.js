const reportsService = require("../services/reports.service");

const REQUIRED_FIELDS = [
  "machineCode",
  "failureType",
  "acceptedAt",
  "repairStartedAt",
  "repairEndedAt",
  "problemDescription",
  "solutionApplied",
];

// Any authenticated user can submit a report (in practice: technicien
// accounts, since public sign-up never creates admins). technician_id and
// technician_name come from the verified session/profile, never the body,
// so a technician can't submit a report as someone else.
const createReport = async (req, res) => {
  try {
    const missing = REQUIRED_FIELDS.filter((field) => !req.body[field]);

    if (missing.length > 0) {
      return res.status(400).json({
        success: false,
        message: `Missing required field(s): ${missing.join(", ")}`,
      });
    }

    const report = await reportsService.createReport({
      technicianId: req.user.id,
      technicianName: req.profile.full_name,
      machineCode: req.body.machineCode,
      failureType: req.body.failureType,
      acceptedAt: req.body.acceptedAt,
      repairStartedAt: req.body.repairStartedAt,
      repairEndedAt: req.body.repairEndedAt,
      problemDescription: req.body.problemDescription,
      solutionApplied: req.body.solutionApplied,
      notes: req.body.notes,
    });

    return res.status(201).json({
      success: true,
      message: "Report saved",
      data: report,
    });
  } catch (error) {
    console.error("Create report error:", error);
    return res.status(400).json({
      success: false,
      message: error.message,
    });
  }
};

// Admin only — powers the admin dashboard's report list.
const listReports = async (req, res) => {
  try {
    const reports = await reportsService.listReports();

    return res.status(200).json({
      success: true,
      data: reports,
    });
  } catch (error) {
    console.error("List reports error:", error);
    return res.status(400).json({
      success: false,
      message: error.message,
    });
  }
};

// Admin only — single report detail view.
const getReportById = async (req, res) => {
  try {
    const report = await reportsService.getReportById(req.params.id);

    return res.status(200).json({
      success: true,
      data: report,
    });
  } catch (error) {
    console.error("Get report error:", error);
    return res.status(404).json({
      success: false,
      message: "Report not found",
    });
  }
};

module.exports = {
  createReport,
  listReports,
  getReportById,
};
