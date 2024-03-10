#! /bin/bash
adduser webmaster

# Install Volta - node and npm manager
curl https://get.volta.sh | bash
. ~/.profile
volta install node@17

# Clone repository
git clone https://github.com/DivyaSaiPagidipally/sign-in-form-react.git
git pull

# Install dependencies and start server
npm install
npm start