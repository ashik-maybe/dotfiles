# ~/.config/fish/conf.d/podman.fish

# ============================================================================
# 1. DAILY WORKFLOW (Abbreviations)
# ============================================================================
abbr -a psa 'podman ps -a'                                # List all containers
abbr -a ps 'podman ps'                                    # List running containers
abbr -a plog 'podman logs -f --tail 100'                  # Tail container logs
abbr -a pex 'podman exec -it'                             # Shell into container
abbr -a pstop 'podman stop'                               # Stop container(s)
abbr -a pstart 'podman start'                             # Start container(s)
abbr -a prm 'podman rm'                                   # Remove container(s)
abbr -a prestart 'podman restart'                         # Restart container(s)
abbr -a prun 'podman run -d -P --name'                    # Run new container (specify name)

# ============================================================================
# 2. HELPERS (Abbreviations)
# ============================================================================
abbr -a pdip 'podman inspect --format "{{.NetworkSettings.IPAddress}}"' # Container IP
abbr -a pports 'podman ps --format "table {{.Names}}\t{{.Ports}}"'        # Port mappings
abbr -a ptop 'podman stats --no-stream'                   # CPU/Mem stats
abbr -a pclean 'podman system prune -af'                  # Nuke unused data/images
abbr -a pinspect 'podman inspect'                         # Inspect container details
abbr -a pimages 'podman images'                           # List local images
abbr -a prmi 'podman rmi'                                 # Remove image(s)

# ============================================================================
# 3. COMPOSE WORKFLOW (Abbreviations)
# ============================================================================
abbr -a pcu 'podman-compose up -d'                        # Start stack in background
abbr -a pcd 'podman-compose down'                         # Stop and remove stack
abbr -a pcl 'podman-compose logs -f --tail 100'           # Tail stack logs
abbr -a pcbuild 'podman-compose build'                    # Build compose images
abbr -a pcps 'podman-compose ps'                          # List compose services
abbr -a pcrestart 'podman-compose restart'                # Restart stack

# ============================================================================
# 4. SMART FUNCTIONS
# ============================================================================
function psh --description "Run command in running container"
    if test (count $argv) -lt 2
        echo "Usage: psh <container> <command>"
        echo "Example: psh myapp npm test"
        return 1
    end
    podman exec $argv[1] $argv[2..]
end

function pshell --description "Interactive shell in new container"
    if test (count $argv) -lt 1
        echo "Usage: pshell <image> [container-name]"
        echo "Example: pshell node my-node-app"
        return 1
    end
    set -l name $argv[2]
    test -z "$name"; and set name (date +%s)
    podman run -it --name $name $argv[1] sh
end

function pcopy --description "Copy file from container to local path"
    if test (count $argv) -lt 2
        echo "Usage: pcopy <container>:/path/to/file ./local-path"
        echo "Example: pcopy myapp:/app/package.json ./package.json"
        return 1
    end
    podman cp $argv[1] $argv[2]
end

function pvols --description "List all volumes"
    podman volume ls
end

function pacc --description "Attach to a running container"
    if test (count $argv) -lt 1
        echo "Usage: pacc <container>"
        return 1
    end
    podman attach $argv[1]
end

# ============================================================================
# 5. WIZARDS
# ============================================================================
function pwiz-run --description "Interactive container run wizard"
    echo "=== Podman Run Wizard ==="
    echo ""

    read -P "Image (e.g., nginx, postgres, node) [nginx]: " -l image
    test -z "$image"; and set image "nginx"

    read -P "Container name (optional): " -l name
    read -P "Ports (e.g., 8080:80, or Enter for auto): " -l ports
    read -P "Volume mount (e.g., ./data:/data, or Enter for none): " -l volume

    set -l cmd "podman run -d"
    test -n "$name"; and set cmd "$cmd --name $name"
    test -n "$ports"; and set cmd "$cmd -p $ports"; or set cmd "$cmd -P"
    test -n "$volume"; and set cmd "$cmd -v $volume"
    set cmd "$cmd $image"

    echo -e "\nRunning: $cmd\n"
    eval $cmd

    echo -e "\nDone! Use 'psa' to list, 'plog' to view logs, 'pex $name /bin/sh' to shell in"
end

function pwiz-postgres --description "Quick Postgres container setup with volume"
    echo "=== Postgres Wizard ==="
    echo ""

    read -P "Container name [postgres-dev]: " -l name
    test -z "$name"; and set name "postgres-dev"

    read -P "Database name [mydb]: " -l dbname
    test -z "$dbname"; and set dbname "mydb"

    read -P "Database user [admin]: " -l user
    test -z "$user"; and set user "admin"

    read -P "Password [secret]: " -l password
    test -z "$password"; and set password "secret"

    read -P "Host port [5432]: " -l port
    test -z "$port"; and set port "5432"

    echo -e "\nStarting postgres container..."
    podman run -d \
        --name $name \
        -e POSTGRES_DB=$dbname \
        -e POSTGRES_USER=$user \
        -e POSTGRES_PASSWORD=$password \
        -p $port:5432 \
        -v "$name-data:/var/lib/postgresql/data" \
        postgres:latest

    echo "
=== Connection Info ===
Host: localhost
Port: $port
Database: $dbname
User: $user
Password: $password

Connection string:
postgresql://$user:$password@localhost:$port/$dbname

Use 'plog $name' to view logs, 'pex $name psql -U $user -d $dbname' to connect"
end

function pwiz-redis --description "Quick Redis container setup"
    echo "=== Redis Wizard ==="
    echo ""

    read -P "Container name [redis-dev]: " -l name
    test -z "$name"; and set name "redis-dev"

    read -P "Host port [6379]: " -l port
    test -z "$port"; and set port "6379"

    echo -e "\nStarting redis container..."
    podman run -d \
        --name $name \
        -p $port:6379 \
        redis:latest

    echo "
=== Connection Info ===
Host: localhost
Port: $port

Use 'plog $name' to view logs, 'pex $name redis-cli' to connect"
end

function pwiz-nginx --description "Quick Nginx static file server"
    echo "=== Nginx Wizard ==="
    echo ""

    read -P "Container name [nginx-static]: " -l name
    test -z "$name"; and set name "nginx-static"

    read -P "Host port [8080]: " -l port
    test -z "$port"; and set port "8080"

    read -P "Directory to serve (absolute path) [(pwd)]: " -l path
    test -z "$path"; and set path (pwd)

    echo -e "\nStarting nginx container..."
    podman run -d \
        --name $name \
        -p $port:80 \
        -v "$path:/usr/share/nginx/html:ro" \
        nginx:latest

    echo "
=== Info ===
URL: http://localhost:$port
Serving: $path

Use 'plog $name' to view logs, 'pstop $name' to stop"
end

function pwiz-node --description "Node.js container sandbox"
    echo "=== Node.js Wizard ==="
    echo ""

    read -P "Container name [node-dev]: " -l name
    test -z "$name"; and set name "node-dev"

    read -P "Working directory (default: current): " -l workdir
    test -z "$workdir"; and set workdir (pwd)

    read -P "Expose port (e.g., 3000:3000, Enter for none): " -l port

    echo -e "\nStarting node container..."
    if test -n "$port"
        podman run -it --name $name -p $port -v "$workdir:/app" -w /app node:latest sh
    else
        podman run -it --name $name -v "$workdir:/app" -w /app node:latest sh
    end

    echo -e "\nContainer stopped. Use 'pstart $name' to restart, 'pex $name npm run dev' to run your app"
end

function pwiz-compose --description "Quick compose file generator"
    echo "=== Compose Wizard ==="
    echo ""

    read -P "Project name: " -l name
    test -z "$name"; and echo "Name required" && return 1

    echo "Select services:"
    echo "1. Node.js + Postgres"
    echo "2. Node.js + Redis"
    echo "3. Node.js + Postgres + Redis"
    echo "4. Custom"

    read -P "Choice [1]: " -l choice
    test -z "$choice"; and set choice 1

    set -l services
    switch $choice
        case 1
            set services "app:
    image: node:latest
    ports:
      - '3000:3000'
    depends_on:
      - db

db:
    image: postgres:latest
    environment:
      POSTGRES_DB: mydb
      POSTGRES_USER: admin
      POSTGRES_PASSWORD: secret
    volumes:
      - db-data:/var/lib/postgresql/data

volumes:
  db-data:"
        case 2
            set services "app:
    image: node:latest
    ports:
      - '3000:3000'
    depends_on:
      - redis

redis:
    image: redis:latest"
        case 3
            set services "app:
    image: node:latest
    ports:
      - '3000:3000'
    depends_on:
      - db
      - redis

db:
    image: postgres:latest
    environment:
      POSTGRES_DB: mydb
      POSTGRES_USER: admin
      POSTGRES_PASSWORD: secret
    volumes:
      - db-data:/var/lib/postgresql/data

redis:
    image: redis:latest

volumes:
  db-data:"
        case "*"
            echo "Custom compose coming soon..."
            return 0
    end

    echo "name: $name
services:
  $services" > docker-compose.yml

    echo -e "\nCreated docker-compose.yml"
    echo "Run 'pcu' to start, 'pcd' to stop"
end

# ============================================================================
# 6. HELP
# ============================================================================
function pwiz-help --description "List all Podman abbreviations & functions"
    echo "
podman.fish - Container helpers for SWE

=== DAILY (90% of work) ===
  psa           List all containers
  ps            List running containers
  plog          Tail container logs
  pex           Shell into container
  pstop         Stop container(s)
  pstart        Start container(s)
  prm           Remove container(s)
  prestart      Restart container(s)
  prun          Run new container (-d -P --name)

=== HELPERS ===
  pdip          Get container IP
  pports        Show port mappings
  ptop          CPU/Mem stats
  pclean        Prune everything
  pimages       List images
  prmi          Remove image(s)

=== COMPOSE ===
  pcu           Start stack (podman-compose up -d)
  pcd           Stop stack
  pcl           Stack logs
  pcbuild       Build images
  pcps          List compose services
  pcrestart     Restart stack

=== SMART FUNCTIONS ===
  psh           Run command in container
  pshell        Interactive shell in NEW container
  pcopy         Copy file from container
  pvols         List volumes
  pacc          Attach to container

=== WIZARDS ===
  pwiz-run      Interactive container run
  pwiz-postgres Quick postgres + volume
  pwiz-redis    Quick redis
  pwiz-nginx    Static file server
  pwiz-node     Node.js sandbox
  pwiz-compose  Generate compose file
  pwiz-help     Show this help
"
end
