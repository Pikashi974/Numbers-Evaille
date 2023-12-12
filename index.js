// Import essential libraries
const express = require("express");
const app = express();
const path = require("path");
const router = express.Router();
// Setup essential routes
router.get("/Numbers-Evaille", function (req, res) {
  res.sendFile(path.join(__dirname + "/index.html")); //__dirname : It will resolve to your project folder.
});
router.get("/src/html/about", function (req, res) {
  res.sendFile(path.join(__dirname + "/src/html/about.html"));
});
router.get("/sitemap", function (req, res) {
  res.sendFile(path.join(__dirname + "/sitemap.html"));
});
router.get("/src/js/main.js", function (req, res) {
  res.sendFile(path.join(__dirname + "/src/js/main.js"));
});
router.get("/src/js/about.js", function (req, res) {
  res.sendFile(path.join(__dirname + "/src/js/about.js"));
});
router.get("/src/css/index.css", function (req, res) {
  res.sendFile(path.join(__dirname + "/src/css/index.css"));
});

//add the router
app.use("/Numbers-Evaille", router);
app.listen(process.env.port || 3000);
console.log("Running at Port 3000");
