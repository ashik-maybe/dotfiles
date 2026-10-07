# ~/.config/fish/conf.d/podman.fish

# ============================================================================
# 1. DAILY WORKFLOW (The 20% you use 80% of the time)
# ============================================================================
abbr -a ps 'podman ps'                                    # List running containers
abbr -a psa 'podman ps -a'                                # List all containers
abbr -a plog 'podman logs -f --tail 100'                  # Tail container logs
abbr -a pex 'podman exec -it'                             # Shell into container
abbr -a pstop 'podman stop'                               # Stop container(s)
abbr -a pstart 'podman start'                             # Start container(s)
abbr -a prest 'podman restart'                           # Restart container(s)
abbr -a prm 'podman rm'                                   # Remove container(s)
abbr -a prun 'podman run -d -P --name'                    # Run new container (specify name)
abbr -a pbuild 'podman build -t'                          # Build own image (tag then context)

# ============================================================================
# 2. COMPOSE WORKFLOW
# ============================================================================
abbr -a pcu 'podman-compose up -d --build'                # Start stack (rebuilds changed images)
abbr -a pcd 'podman-compose down'                         # Stop and remove stack
abbr -a pcl 'podman-compose logs -f --tail 100'           # Tail stack logs
abbr -a pcps 'podman-compose ps'                          # List compose services

# ============================================================================
# 3. ESSENTIAL HELPERS
# ============================================================================
abbr -a pimages 'podman images'                           # List local images
abbr -a prmi 'podman rmi'                                 # Remove image(s)
abbr -a pclean 'podman system prune -af'                  # Nuke unused data/images
abbr -a pvols 'podman volume ls'                          # List volumes
abbr -a pdu 'podman system df'                            # Disk eaten by images/containers
abbr -a pstats 'podman stats'                             # Live CPU/RAM per container

# ============================================================================
# 4. HELP
# ============================================================================
function phelp --description "List all Podman abbreviations"
    echo "
Daily:   ps, psa, plog, pex, pstop, pstart, prest, prm, prun, pbuild
Compose: pcu, pcd, pcl, pcps
Helpers: pimages, prmi, pclean, pvols, pdu, pstats
"
end
