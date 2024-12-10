#!/bin/sh

curl -s https://raw.githubusercontent.com/ZotyaNET/build/refs/heads/master/debian-docker.sh | bash

docker run --name guacd -d guacamole/guacd

docker run --rm guacamole/guacamole /opt/guacamole/bin/initdb.sh --postgresql > initdb.sql
cat >> initdb.sql << EOT
CREATE USER guacamole_user WITH PASSWORD 'some_password';
GRANT SELECT,INSERT,UPDATE,DELETE ON ALL TABLES IN SCHEMA public TO guacamole_user;
GRANT SELECT,USAGE ON ALL SEQUENCES IN SCHEMA public TO guacamole_user;
EOT

docker run -d -e POSTGRES_HOST_AUTH_METHOD=trust --name guacdb library/postgres:10-alpine

docker cp initdb.sql guacdb:/guac_db.sql
sleep 3  # give it time to spin up
docker exec guacdb su postgres -c "createdb guacamole_db"
sleep 3  # give it time to create the DB
docker exec guacdb su postgres -c "psql -d guacamole_db -f /guac_db.sql"

docker run --name guacamole \
         -e POSTGRES_DATABASE=guacamole_db \
         -e POSTGRES_USER=guacamole_user \
         -e POSTGRES_PASSWORD=some_password \
         --link guacd:guacd \
         --link guacdb:postgres \
         -d \
         -p 443:443 \
         -p 8080:8080 \
         -p 8443:8443 \
         guacamole/guacamole
