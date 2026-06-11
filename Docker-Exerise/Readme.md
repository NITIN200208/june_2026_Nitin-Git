COMPLETE DOCKER SETUP (CORRECT WAY)

📁 Step 1: Project folder
cd ~
mkdir docker-app
cd docker-app


🧾 Step 2: Create Node.js file
nano app_v1.js

Paste this correct code:
const http = require("http");

const server = http.createServer((req, res) => {
  res.end("🚀 Welcome to Docker on AWS EC2");
});

server.listen(3000, () => {
  console.log("Server running on port 3000");
});

Save:

CTRL + X
Y
ENTER


🐳 Step 3: Create Dockerfile
nano docker-file
Paste:
FROM node:18

WORKDIR /app

COPY app_v1.js .

EXPOSE 3000

CMD ["node", "app_v1.js"]
🔨 Step 4: Build Docker Image
sudo docker build -t app_v1 -f docker-file .


📦 Step 5: Check image
sudo docker images

You should see:

app_v1   latest
▶️ Step 6: Run container
sudo docker run -d -p 80:3000 --name app-container-v1 app_v1


📊 Step 7: Check running container
sudo docker ps


📜 Step 8: Logs check
sudo docker logs app-container-v1

Expected:

Server running on port 3000
🌐 Step 9: Open browser
http://<EC2-PUBLIC-IP>


🧹 If something breaks (RESET)
sudo docker rm -f app-container-v1
sudo docker rmi -f app_v1
⚠️ IMPORTANT CHECKLIST

✔ Docker installed
✔ Port 80 open in Security Group
✔ File name exactly app_v1.js
✔ Dockerfile name docker-file
✔ Node app listening on 3000
