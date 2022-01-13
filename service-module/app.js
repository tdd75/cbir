const express = require('express')

const mongoConnect = require('./util/database')
const authRoutes = require('./routes/auth')
const shopRoutes = require('./routes/shop')
const config = require('./config')

const app = express()

app.use(express.json())
app.use(authRoutes)
app.use(shopRoutes)

app.listen(config.web.port, () => {
    mongoConnect()
})