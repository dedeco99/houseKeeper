const Pool = require("pg").Pool;

const pool = new Pool({ user: "dedeco99", database: "housekeeper" });

module.exports = pool;
