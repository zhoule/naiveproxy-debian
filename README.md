1. 登录 Docker Hub：
   ```bash
   docker login
   ```

2. 为镜像打标签：
   ```bash
   docker tag naiveproxy-debian your-dockerhub-username/naiveproxy-debian:latest
   ```

3. 推送镜像到 Docker Hub：
   ```bash
   docker push your-dockerhub-username/naiveproxy-debian:latest
   ```

4. 验证上传是否成功：
   • 在 Docker Hub 上查看。
   • 从 Docker Hub 拉取镜像并运行。

5. 启动Docker
docker run -d \
    --name naiveproxy \
    -p 8088:80 \
    -p 8443:443 \
    -e DOMAIN="domain.com" \
    -e EMAIL="yourmail@gmail.com" \
    -e USERNAME="username" \
    -e PASSWORD="password" \
    -e REVERSE_PROXY_URL="demo.cloudreve.org" \
    naiveproxy-debian
