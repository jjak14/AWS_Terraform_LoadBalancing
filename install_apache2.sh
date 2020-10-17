#! /bin/bash
sudo yum update -y
sudo yum install httpd -y
sudo systemctl start httpd
sudo systemctl enable httpd
sudo mkdir -p /var/www/html/
echo "<h1>Welcome! Server 2 from EC2-02</h1>" | sudo tee /var/www/html/index.html
