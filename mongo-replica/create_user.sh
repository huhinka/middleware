#!/bin/bash

mongo --port 30011 <<EOF
   use admin;
   admin = db.getSiblingDB("admin");
   admin.createUser(
     {
	      user: "admin",
         pwd: "admin",
         roles: [ { role: "root", db: "admin" } ]
   });
   db.getSiblingDB("admin").auth("admin", "admin");
   rs.status();
EOF

