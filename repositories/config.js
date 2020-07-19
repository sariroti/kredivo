module.exports = {
    HOST: "localhost",
    USER: "root",
    PASSWORD: "Bynes@160285",
    DB: "employees",
    dialect: "mysql",
    pool: {
      max: 5,
      min: 0,
      acquire: 30000,
      idle: 10000
    }
  };