# Podman abbreviations — daily workflow, compose, and helpers.

# Daily: containers you use most.
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

# Compose: manage multi-container stacks with podman-compose.
# Standalone podman-compose: `podman compose` delegates to it and prints a banner. Direct call avoids the banner.
abbr -a pcu 'podman-compose up -d --build'                # Start stack (rebuilds changed images)
abbr -a pcd 'podman-compose down'                         # Stop and remove stack
abbr -a pcl 'podman-compose logs -f --tail 100'           # Tail stack logs
abbr -a pcps 'podman-compose ps'                          # List compose services

# Helpers: inspect images, volumes, and disk use. `pclean` removes unused data — use with care.
abbr -a pimages 'podman images'                           # List local images
abbr -a prmi 'podman rmi'                                 # Remove image(s)
abbr -a pclean 'podman system prune -af'                  # Nuke unused data/images
abbr -a pvols 'podman volume ls'                          # List volumes
abbr -a pdu 'podman system df'                            # Disk eaten by images/containers
abbr -a pstats 'podman stats'                             # Live CPU/RAM per container

# Help: list all podman abbreviations.
function phelp --description "List all Podman abbreviations"
    echo "
Daily:   ps, psa, plog, pex, pstop, pstart, prest, prm, prun, pbuild
Compose: pcu, pcd, pcl, pcps
Helpers: pimages, prmi, pclean, pvols, pdu, pstats
"
end
