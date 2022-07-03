#!/bin/bash

mongo <<EOF
    var cfg = {
        _id: 'vision-set',
        "version": 1,
        "members": [
            {
                "_id": 0,
                host: '192.168.50.62:30011',
                "priority": 2
            },
            {
                "_id": 1,
                host: '192.168.50.62:30012',
                "priority": 1
            },
            {
                "_id": 2,
                host: '192.168.50.62:30013',
                "priority": 0
            }
        ]
    };
    rs.initiate(cfg, { force: true });
    //rs.reconfig(cfg, { force: true });
    rs.status();
EOF
