const express = require("express");

const {
  createReport,
  listReports,
  getReportById,
} = require("../controllers/reports.controller");

const { requireAuth, requireAdmin } = require("../middleware/auth.middleware");

const router = express.Router();

// Technician submits a repair report.
router.post("/", requireAuth, createReport);

// Admin dashboard: list all reports / view one in detail.
router.get("/", requireAuth, requireAdmin, listReports);
router.get("/:id", requireAuth, requireAdmin, getReportById);

module.exports = router;
