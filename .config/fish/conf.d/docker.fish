# ============================================================================
# docker.fish - Container Helper (Industry Standard)
# ============================================================================

# ------------------------------
# Daily (90% of work)
# ------------------------------
alias dpsa 'docker ps -a'                              # List all containers
alias dps 'docker ps'                                  # List running containers
alias dlog 'docker logs -f --tail 100'                # Tail container logs
alias dex 'docker exec -it'                           # Shell into container
alias dstop 'docker stop'                             # Stop container(s)
alias dstart 'docker start'                          # Start container(s)
alias drm 'docker rm'                                  # Remove container(s)
alias drestart 'docker restart'                      # Restart container(s)
alias drun 'docker run -d -P --name'                  # Run new container (specify name)

# ------------------------------
# Helpers
# ------------------------------
alias ddip 'docker inspect --format "{{.NetworkSettings.IPAddress}}"'  # Container IP
alias dports 'docker ps --format "table {{.Names}}\t{{.Ports}}"'         # Port mappings
alias dtop 'docker stats --no-stream'                                      # CPU/Mem stats
alias dclean 'docker system prune -af'                                    # Nuke everything
alias inspect 'docker inspect'                                             # Inspect container
alias dimages 'docker images'                                              # List images
alias drmi 'docker rmi'                                                     # Remove image

# ------------------------------
# Compose (Industry Standard)
# ------------------------------
alias dcu 'docker compose up -d'                     # Start stack
alias dcd 'docker compose down'                       # Stop stack
alias dcl 'docker compose logs -f --tail 100'         # Stack logs
alias dcbuild 'docker compose build'                  # Build images
alias dcps 'docker compose ps'                        # List compose services
alias dcrestart 'docker compose restart'             # Restart stack

# ------------------------------
# Smart Functions
# ------------------------------
function dsh
    # Run command in running container
    if test (count $argv) -lt 2
        echo "Usage: dsh <container> <command>"
        echo "Example: dsh myapp npm test"
        return 1
    end
    docker exec $argv[1] $argv[2..]
end

function dshell
    # Interactive shell in NEW container
    # Usage: dshell <image> [container-name]
    if test (count $argv) -lt 1
        echo "Usage: dshell <image> [container-name]"
        echo "Example: dshell node my-node-app"
        echo "         dshell nginx"
        return 1
    end
    set -l name $argv[2]
    if test -z "$name"
        set name (date +%s)
    end
    docker run -it --name $name $argv[1] sh
end

function dcopy
    # Copy file from container to local
    # Usage: dcopy <container>:/path/file ./local-path
    if test (count $argv) -lt 2
        echo "Usage: dcopy <container>:/path/to/file ./local-path"
        echo "Example: dcopy myapp:/app/package.json ./package.json"
        return 1
    end
    docker cp $argv[1] $argv[2]
end

function dvols
    # List all volumes
    docker volume ls
end

function dacc
    # Attach to running container (for detached -it)
    if test (count $argv) -lt 1
        echo "Usage: dacc <container>"
        echo "Example: dacc myapp"
        return 1
    end
    docker attach $argv[1]
end

# ------------------------------
# Wizards (Guided - Learn by doing)
# ------------------------------
function dwiz-run
    # Interactive container run wizard
    echo "=== Docker Run Wizard ==="
    echo ""
    
    set -l image (read -p "Image (e.g., nginx, postgres, node): ")
    test -z "$image" && set image "nginx"
    
    set -l name (read -p "Container name (optional): ")
    
    set -l ports (read -p "Ports (e.g., 8080:80, or Enter for auto): ")
    
    set -l volume (read -p "Volume mount (e.g., ./data:/data, or Enter for none): ")
    
    set -l cmd "docker run -d"
    
    test -n "$name" && set cmd "$cmd --name $name"
    test -n "$ports" && set cmd "$cmd -p $ports" || set cmd "$cmd -P"
    test -n "$volume" && set cmd "$cmd -v $volume"
    
    set cmd "$cmd $image"
    
    echo ""
    echo "Running: $cmd"
    eval $cmd
    
    echo ""
    echo "Done! Use 'dpsa' to list, 'dlog' to view logs, 'dex $name /bin/sh' to shell in"
end

function dwiz-postgres
    # Quick postgres with persistent volume
    echo "=== Postgres Wizard ==="
    echo ""
    
    set -l name (read -p "Container name [postgres-dev]: ")
    test -z "$name" && set name "postgres-dev"
    
    set -l dbname (read -p "Database name [mydb]: ")
    test -z "$dbname" && set dbname "mydb"
    
    set -l user (read -p "Database user [admin]: ")
    test -z "$user" && set user "admin"
    
    set -l password (read -p "Password [secret]: ")
    test -z "$password" && set password "secret"
    
    set -l port (read -p "Host port [5432]: ")
    test -z "$port" && set port "5432"
    
    echo ""
    echo "Starting postgres container..."
    docker run -d \
        --name $name \
        -e POSTGRES_DB=$dbname \
        -e POSTGRES_USER=$user \
        -e POSTGRES_PASSWORD=$password \
        -p $port:5432 \
        -v "$name-data:/var/lib/postgresql/data" \
        postgres:latest
    
    echo ""
    echo "=== Connection Info ==="
    echo "Host: localhost"
    echo "Port: $port"
    echo "Database: $dbname"
    echo "User: $user"
    echo "Password: $password"
    echo ""
    echo "Connection string:"
    echo "postgresql://$user:$password@localhost:$port/$dbname"
    echo ""
    echo "Use 'dlog $name' to view logs, 'dex $name psql -U $user -d $dbname' to connect"
end

function dwiz-redis
    # Quick redis
    echo "=== Redis Wizard ==="
    echo ""
    
    set -l name (read -p "Container name [redis-dev]: ")
    test -z "$name" && set name "redis-dev"
    
    set -l port (read -p "Host port [6379]: ")
    test -z "$port" && set port "6379"
    
    echo ""
    echo "Starting redis container..."
    docker run -d \
        --name $name \
        -p $port:6379 \
        redis:latest
    
    echo ""
    echo "=== Connection Info ==="
    echo "Host: localhost"
    echo "Port: $port"
    echo ""
    echo "Use 'dlog $name' to view logs, 'dex $name redis-cli' to connect"
end

function dwiz-nginx
    # Quick static file server
    echo "=== Nginx Wizard ==="
    echo ""
    
    set -l name (read -p "Container name [nginx-static]: ")
    test -z "$name" && set name "nginx-static"
    
    set -l port (read -p "Host port [8080]: ")
    test -z "$port" && set port "8080"
    
    set -l path (read -p "Directory to serve (absolute path) [./]: ")
    test -z "$path" && set path (pwd)
    
    echo ""
    echo "Starting nginx container..."
    docker run -d \
        --name $name \
        -p $port:80 \
        -v "$path:/usr/share/nginx/html:ro" \
        nginx:latest
    
    echo ""
    echo "=== Info ==="
    echo "URL: http://localhost:$port"
    echo "Serving: $path"
    echo ""
    echo "Use 'dlog $name' to view logs, 'dstop $name' to stop"
end

function dwiz-node
    # Node.js sandbox
    echo "=== Node.js Wizard ==="
    echo ""
    
    set -l name (read -p "Container name [node-dev]: ")
    test -z "$name" && set name "node-dev"
    
    set -l workdir (read -p "Working directory (default: current): ")
    test -z "$workdir" && set workdir (pwd)
    
    set -l port (read -p "Expose port (e.g., 3000:3000, Enter for none): ")
    
    echo ""
    echo "Starting node container..."
    
    if test -n "$port"
        docker run -it --name $name -p $port -v "$workdir:/app" -w /app node:latest sh
    else
        docker run -it --name $name -v "$workdir:/app" -w /app node:latest sh
    end
    
    echo ""
    echo "Container stopped. Use 'dstart $name' to restart, 'dex $name npm run dev' to run your app"
end

function dwiz-compose
    # Quick compose file generator
    echo "=== Compose Wizard ==="
    echo ""
    
    set -l name (read -p "Project name: ")
    test -z "$name" && echo "Name required" && return 1
    
    echo "Select services:"
    echo "1. Node.js + Postgres"
    echo "2. Node.js + Redis"
    echo "3. Node.js + Postgres + Redis"
    echo "4. Custom"
    
    set -l choice (read -p "Choice [1]: ")
    test -z "$choice" && set choice 1
    
    switch $choice
        case 1
            set services "app:\n  image: node:latest\n  ports:\n    - '3000:3000'\n  depends_on:\n    - db\n\ndb:\n  image: postgres:latest\n  environment:\n    POSTGRES_DB: mydb\n    POSTGRES_USER: admin\n    POSTGRES_PASSWORD: secret\n  volumes:\n    - db-data:/var/lib/postgresql/data\n\nvolumes:\n  db-data:"
        case 2
            set services "app:\n  image: node:latest\n  ports:\n    - '3000:3000'\n  depends_on:\n    - redis\n\nredis:\n  image: redis:latest"
        case 3
            set services "app:\n  image: node:latest\n  ports:\n    - '3000:3000'\n  depends_on:\n    - db\n    - redis\n\ndb:\n  image: postgres:latest\n  environment:\n    POSTGRES_DB: mydb\n    POSTGRES_USER: admin\n    POSTGRES_PASSWORD: secret\n  volumes:\n    - db-data:/var/lib/postgresql/data\n\nredis:\n  image: redis:latest\n\nvolumes:\n  db-data:"
        case "*"
            echo "Custom compose coming soon..."
            return 0
    end
    
    echo ""
    echo "name: $name
services:
$services" > docker-compose.yml
    
    echo "Created docker-compose.yml"
    echo ""
    echo "Run 'dcu' to start, 'dcd' to stop"
end

# ------------------------------
# Help
# ------------------------------
function dwiz-help
    echo "
docker.fish - Container helpers for SWE

=== DAILY (90% of work) ===
  dpsa           List all containers
  dps            List running containers
  dlog           Tail container logs
  dex            Shell into container
  dstop          Stop container(s)
  dstart         Start container(s)
  drm            Remove container(s)
  drestart       Restart container(s)
  drun           Run new container (-d -P --name)

=== HELPERS ===
  ddip           Get container IP
  dports         Show port mappings
  dtop           CPU/Mem stats
  dclean         Prune everything
  dimages        List images

=== COMPOSE (Industry Standard) ===
  dcu            Start stack (docker compose up -d)
  dcd            Stop stack
  dcl            Stack logs
  dcbuild        Build images
  dcps           List compose services

=== SMART FUNCTIONS ===
  dsh            Run command in container
  dshell         Interactive shell in NEW container
  dcopy          Copy file from container
  dvols          List volumes
  dacc           Attach to container

=== WIZARDS (Guided) ===
  dwiz-run           Interactive container run
  dwiz-postgres      Quick postgres + volume
  dwiz-redis         Quick redis
  dwiz-nginx         Static file server
  dwiz-node          Node.js sandbox
  dwiz-compose       Generate compose file
  dwiz-help          Show this help

=== EXAMPLES ===
  # Run postgres
  dwiz-postgres
  
  # View logs
  dlog mycontainer
  
  # Shell into running container
  dex mycontainer /bin/sh
  
  # Stop and remove all
  dstop (docker ps -q) && drm (docker ps -aq)
  
  # Start compose project
  dcu
  
  # Clean up everything
  dclean
"
end
