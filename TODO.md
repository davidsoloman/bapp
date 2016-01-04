- npm module
- project generator

#### What is contained

- simple generators
- express app
- sample data storage contract


#### Directory structure

- bin        - contains binaries to launch the app
- config     - configuration files, app and blockchain related
- contracts  - your .sol contracts
- models     - js models that map
- routes     - express server routes
- public     - public directory, your static assets live here
- tmp        - temporary files


- bin
  - ui          - starts the application's UI
  - blockchain  - starts the ethereum blockchain geth server
  - deploy      - deploys the app to an external server via ssh or to dockerhub
  - contracts   - deploys and manages the contracts to the blockchain




#### Deployment

- add blockchain instances command
- ssh deployment (similar to capistrano)
- docker deployment (ready for open source apps via Dockerfile build + push to docker hub)

#### Advanced

- redis caching layer

#### Directory Structure

- contracts
- tmp
- public


#### Commands

bapp

Welcome to BApp, the blockchain app microframework.
Here's the list of available commands:

bapp help   - displays this message
bapp init   - initializes the directory structure and a SimpleStorage contract
bapp ui     - launches the BApp ui
bapp chain  - launches the blockchain via geth
bapp run    - runs all the UIs and Blockchain instances you set up
bapp deploy - deploys the app via SSH or on docker hub


#### Notes

using registrars and admin functions example: https://github.com/ethereum/go-ethereum/wiki/Contracts-and-Transactions#example-script
