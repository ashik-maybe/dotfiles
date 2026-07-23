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
abbr -a prm 'podman rm'                                   # Remove container(s)
abbr -a prun 'podman run -d -P --name'                    # Run new container (specify name)

# ============================================================================
# 2. COMPOSE WORKFLOW
# ============================================================================
abbr -a pcu 'podman-compose up -d'                        # Start stack in background
abbr -a pcd 'podman-compose down'                         # Stop and remove stack
abbr -a pcl 'podman-compose logs -f --tail 100'           # Tail stack logs
abbr -a pcps 'podman-compose ps'                          # List compose services

# ============================================================================
# 3. ESSENTIAL HELPERS
# ============================================================================
abbr -a pimages 'podman images'                           # List local images
abbr -a prmi 'podman rmi'                                 # Remove image(s)
abbr -a pclean 'podman system prune -af'                  # Nuke unused data/images/volumes
abbr -a pvols 'podman volume ls'                          # List volumes

# ============================================================================
# 4. HELP
# ============================================================================
function phelp --description "List all Podman abbreviations"
    echo "
Daily:   ps, psa, plog, pex, pstop, pstart, prm, prun
Compose: pcu, pcd, pcl, pcps
Helpers: pimages, prmi, pclean, pvols
"
end
