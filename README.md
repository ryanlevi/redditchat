# Reddit Chat
### First time use
````
bundle install
rake db:migrate
bundle exec thin start -p 3000 --ssl --ssl-key-file .ssl/localhost.key --ssl-cert-file .ssl/localhost.crt
````
Then head to https://localhost:3000/ from web browser
### All other times
````
rake db:migrate
bundle exec thin start -p 3000 --ssl --ssl-key-file .ssl/localhost.key --ssl-cert-file .ssl/localhost.crt
````
Then head to https://localhost:3000/ from web browser