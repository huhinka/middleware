#!/bin/bash

mongo --port 30011 <<EOF
    var cfg = {
        _id: 'vision-set',
        "version": 1,
        "members": [
            {
                "_id": 0,
                host: 'mongo1:30011',
                "priority": 2
            },
            {
                "_id": 1,
                host: 'mongo2:30012',
                "priority": 1
            },
            {
                "_id": 2,
                host: 'mongo3:30013',
                "priority": 0
            }
        ]
    };
    rs.initiate(cfg, { force: true });
    //rs.reconfig(cfg, { force: true });
    rs.status();
EOF
