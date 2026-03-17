# ============================================================================
# podman.fish - Container Helper (Industry Standard)
# ============================================================================

# ------------------------------
# Daily (90% of work)
# ------------------------------
alias psa 'podman ps -a'                              # List all containers
alias ps 'podman ps'                                  # List running containers
alias plog 'podman logs -f --tail 100'                # Tail container logs
alias pex 'podman exec -it'                           # Shell into container
alias pstop 'podman stop'                             # Stop container(s)
alias pstart 'podman start'                          # Start container(s)
alias prm 'podman rm'                                  # Remove container(s)
alias prestart 'podman restart'                      # Restart container(s)
alias prun 'podman run -d -P --name'                  # Run new container (specify name)

# ------------------------------
# Helpers
# ------------------------------
alias pdip 'podman inspect --format "{{.NetworkSettings.IPAddress}}"'  # Container IP
alias pports 'podman ps --format "table {{.Names}}\t{{.Ports}}"'         # Port mappings
alias ptop 'podman stats --no-stream'                                      # CPU/Mem stats
alias pclean 'podman system prune -af'                                    # Nuke everything
alias pinspect 'podman inspect'                                             # Inspect container
alias pimages 'podman images'                                              # List images
alias prmi 'podman rmi'                                                     # Remove image

# ------------------------------
# Compose (Industry Standard)
# ------------------------------
alias pcu 'podman-compose up -d'                     # Start stack
alias pcd 'podman-compose down'                       # Stop stack
alias pcl 'podman-compose logs -f --tail 100'         # Stack logs
alias pcbuild 'podman-compose build'                  # Build images
alias pcps 'podman-compose ps'                        # List compose services
alias pcrestart 'podman-compose restart'             # Restart stack

# ------------------------------
# Smart Functions
# ------------------------------
function psh
    # Run command in running container
    if test (count $argv) -lt 2
        echo "Usage: psh <container> <command>"
        echo "Example: psh myapp npm test"
        return 1
    end
    podman exec $argv[1] $argv[2..]
end

function pshell
    # Interactive shell in NEW container
    # Usage: pshell <image> [container-name]
    if test (count $argv) -lt 1
        echo "Usage: pshell <image> [container-name]"
        echo "Example: pshell node my-node-app"
        echo "         pshell nginx"
        return 1
    end
    set -l name $argv[2]
    if test -z "$name"
        set name (date +%s)
    end
    podman run -it --name $name $argv[1] sh
end

function pcopy
    # Copy file from container to local
    # Usage: pcopy <container>:/path/file ./local-path
    if test (count $argv) -lt 2
        echo "Usage: pcopy <container>:/path/to/file ./local-path"
        echo "Example: pcopy myapp:/app/package.json ./package.json"
        return 1
    end
    podman cp $argv[1] $argv[2]
end

function pvols
    # List all volumes
    podman volume ls
end

function pacc
    # Attach to running container (for detached -it)
    if test (count $argv) -lt 1
        echo "Usage: pacc <container>"
        echo "Example: pacc myapp"
        return 1
    end
    podman attach $argv[1]
end

# ------------------------------
# Wizards (Guided - Learn by doing)
# ------------------------------
function pwiz-run
    # Interactive container run wizard
    echo "=== Podman Run Wizard ==="
    echo ""
    
    set -l image (read -p "Image (e.g., nginx, postgres, node): ")
    test -z "$image" && set image "nginx"
    
    set -l name (read -p "Container name (optional): ")
    
    set -l ports (read -p "Ports (e.g., 8080:80, or Enter for auto): ")
    
    set -l volume (read -p "Volume mount (e.g., ./data:/data, or Enter for none): ")
    
    set -l cmd "podman run -d"
    
    test -n "$name" && set cmd "$cmd --name $name"
    test -n "$ports" && set cmd "$cmd -p $ports" || set cmd "$cmd -P"
    test -n "$volume" && set cmd "$cmd -v $volume"
    
    set cmd "$cmd $image"
    
    echo ""
    echo "Running: $cmd"
    eval $cmd
    
    echo ""
    echo "Done! Use 'psa' to list, 'plog' to view logs, 'pex $name /bin/sh' to shell in"
end

function pwiz-postgres
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
    podman run -d \
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
    echo "Use 'plog $name' to view logs, 'pex $name psql -U $user -d $dbname' to connect"
end

function pwiz-redis
    # Quick redis
    echo "=== Redis Wizard ==="
    echo ""
    
    set -l name (read -p "Container name [redis-dev]: ")
    test -z "$name" && set name "redis-dev"
    
    set -l port (read -p "Host port [6379]: ")
    test -z "$port" && set port "6379"
    
    echo ""
    echo "Starting redis container..."
    podman run -d \
        --name $name \
        -p $port:6379 \
        redis:latest
    
    echo ""
    echo "=== Connection Info ==="
    echo "Host: localhost"
    echo "Port: $port"
    echo ""
    echo "Use 'plog $name' to view logs, 'pex $name redis-cli' to connect"
end

function pwiz-nginx
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
    podman run -d \
        --name $name \
        -p $port:80 \
        -v "$path:/usr/share/nginx/html:ro" \
        nginx:latest
    
    echo ""
    echo "=== Info ==="
    echo "URL: http://localhost:$port"
    echo "Serving: $path"
    echo ""
    echo "Use 'plog $name' to view logs, 'pstop $name' to stop"
end

function pwiz-node
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
        podman run -it --name $name -p $port -v "$workdir:/app" -w /app node:latest sh
    else
        podman run -it --name $name -v "$workdir:/app" -w /app node:latest sh
    end
    
    echo ""
    echo "Container stopped. Use 'pstart $name' to restart, 'pex $name npm run dev' to run your app"
end

function pwiz-compose
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
    echo "Run 'pcu' to start, 'pcd' to stop"
end

# ------------------------------
# Help
# ------------------------------
function pwiz-help
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

=== COMPOSE (Industry Standard) ===
  pcu           Start stack (podman-compose up -d)
  pcd           Stop stack
  pcl           Stack logs
  pcbuild       Build images
  pcps          List compose services

=== SMART FUNCTIONS ===
  psh           Run command in container
  pshell        Interactive shell in NEW container
  pcopy         Copy file from container
  pvols         List volumes
  pacc          Attach to container

=== WIZARDS (Guided) ===
  pwiz-run          Interactive container run
  pwiz-postgres     Quick postgres + volume
  pwiz-redis        Quick redis
  pwiz-nginx        Static file server
  pwiz-node         Node.js sandbox
  pwiz-compose      Generate compose file
  pwiz-help         Show this help

=== EXAMPLES ===
  # Run postgres
  pwiz-postgres
  
  # View logs
  plog mycontainer
  
  # Shell into running container
  pex mycontainer /bin/sh
  
  # Stop and remove all
  pstop (podman ps -q) && prm (podman ps -aq)
  
  # Start compose project
  pcu
  
  # Clean up everything
  pclean
"
end
