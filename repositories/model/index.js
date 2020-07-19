const repoConfig = require("../config.js");
const Sequelize = require("sequelize").Sequelize;

const sequelize = new Sequelize(repoConfig.DB, repoConfig.USER, repoConfig.PASSWORD, {
  host: repoConfig.HOST,
  dialect: repoConfig.dialect,
  pool: {
    max: repoConfig.pool.max,
    min: repoConfig.pool.min,
    acquire: repoConfig.pool.acquire,
    idle: repoConfig.pool.idle
  }
});

const db = {};

db.Sequelize = Sequelize;
db.sequelize = sequelize;

// db.tutorials = require("./tutorial.model.js")(sequelize, Sequelize);

module.exports = db;