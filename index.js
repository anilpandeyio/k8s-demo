const express = require("express");

const app = express();
const port = process.env.PORT || 3000;
const logLevel = process.env.LOG_LEVEL || "EMPTYYY";
const nodeEnv = process.env.NODE_ENV || "EMPTYYYYYY";

app.get("/", (req, res) => {
    res.json({
        message: "Hello from Node.js running inside Kubernetes!",
        hostname: process.env.HOSTNAME,
        logLevel: logLevel,
        nodeEnv: nodeEnv
    });
});

app.get("/health", (req, res) => {
    res.status(200).json({
        status: "healthy"
    });
});

app.listen(port, "0.0.0.0", () => {
    console.log(`Server listening on port ${port}`);
});
