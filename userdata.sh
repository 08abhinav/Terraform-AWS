
#!/bin/bash
# ==============================================
# User Data Script for AWS EC2 (Terraform Demo)
# ==============================================

# Update and install Apache
sudo apt update -y
sudo apt install -y apache2

# Enable and start Apache service
sudo systemctl enable apache2
sudo systemctl start apache2

# Create a cool HTML web page
sudo bash -c 'cat > /var/www/html/index.html <<EOF
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Terraform EC2 Demo</title>
<style>
  body {
    margin: 0;
    padding: 0;
    height: 100vh;
    background: linear-gradient(135deg, #141E30, #243B55);
    display: flex;
    justify-content: center;
    align-items: center;
    font-family: "Segoe UI", Tahoma, Geneva, Verdana, sans-serif;
    color: #fff;
    text-align: center;
  }
  h1 {
    font-size: 3em;
    background: linear-gradient(90deg, #00c6ff, #0072ff);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    animation: glow 2s ease-in-out infinite alternate;
  }
  @keyframes glow {
    from { text-shadow: 0 0 10px #00c6ff; }
    to { text-shadow: 0 0 25px #0072ff; }
  }
  footer {
    position: absolute;
    bottom: 15px;
    font-size: 0.9em;
    opacity: 0.7;
  }
</style>
</head>
<body>
  <div>
    <h1>Welcome to My First Terraform Project 🚀</h1>
    <footer>Powered by Terraform + AWS EC2 + Apache</footer>
  </div>
</body>
</html>
EOF'

# Restart Apache to ensure everything loads
sudo systemctl restart apache2

