build redis sentinel cluster for practice.

1. modify the host IP in `.env`
2. run `docker-compose up -d`
3. run `docker exec -it sentinel-2 redis-cli -p 26379 sentinel get-master-addr-by-name mymaster` to check the master node
4. run `docker compose stop redis-master` to check the failover process
5. run `docker exec -it sentinel-2 redis-cli -p 26379 sentinel get-master-addr-by-name mymaster` to check the new master node

Thanks for the posts:
- [Setting Up Redis Sentinel with Docker Compose](https://medium.com/@mohsenmahoski/setting-up-sentinel-with-docker-compose-5cad962c7643)