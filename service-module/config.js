const config = {}

config.web = {}
config.auth = {}
config.db = {}

config.web.port = process.env.PORT || 3000

config.auth.salt = 12
config.auth.secret = 'rrG9g1E2pX7u7YTwwcCOAJtL3ZYOPdFxvbqGOHGv'
config.auth.tokenLife = '1d'
config.auth.secretRefresh = 'Bigp9RC6Zb6RO3oN82tz9ynCc8cR9zM0FIS7wLpg'
config.auth.refreshTokenLife = '365d'

config.db.uri = 'mongodb+srv://admin:admin@cluster0.fm4xh.mongodb.net/shop-db'

module.exports = config