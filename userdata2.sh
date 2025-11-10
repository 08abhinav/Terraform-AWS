#!/bin/bash
# ==============================================
# User Data Script for AWS EC2 (Terraform Demo #2)
# ==============================================

# Update packages and install Apache
sudo apt update -y
sudo apt install -y apache2

# Enable and start Apache service
sudo systemctl enable apache2
sudo systemctl start apache2

# Create a new futuristic neon-style HTML page
sudo bash -c 'cat > /var/www/html/index.html <<EOF
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>AWS + Terraform Demo 2</title>
<style>
  body {
    margin: 0;
    padding: 0;
    height: 100vh;
    background: radial-gradient(circle at top left, #0f0c29, #302b63, #24243e);
    display: flex;
    justify-content: center;
    align-items: center;
    color: #00fff7;
    font-family: "Orbitron", sans-serif;
    text-transform: uppercase;
    text-align: center;
  }
  h1 {
    font-size: 2.8em;
    text-shadow: 0 0 10px #00fff7, 0 0 20px #00e0ff, 0 0 40px #00bcd4;
    animation: pulse 2s infinite alternate;
  }
  p {
    margin-top: 10px;
    font-size: 1.1em;
    opacity: 0.8;
  }
  @keyframes pulse {
    from { text-shadow: 0 0 10px #00fff7; }
    to { text-shadow: 0 0 25px #00e0ff; }
  }
  footer {
    position: absolute;
    bottom: 20px;
    color: #aaa;
    font-size: 0.9em;
  }
</style>
</head>
<body>
  <div>
    <h1>Deployed with Terraform ⚙️</h1>
    <p>This EC2 instance runs automatically using Infrastructure as Code.</p>
    <footer>Experiment #2 - AWS EC2 + Terraform Automation</footer>
  </div>
</body>
</html>
EOF'

# Restart Apache service
sudo systemctl restart apache2

