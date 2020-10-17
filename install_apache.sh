#! /bin/bash
sudo yum update -y
sudo yum install httpd -y
sudo systemctl start httpd
sudo systemctl enable httpd
sudo mkdir -p /var/www/html/
echo "<h1>Welcome! Server 1 from EC2-01</h1>" | sudo tee /var/www/html/index.html
