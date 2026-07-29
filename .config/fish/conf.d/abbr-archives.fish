# ~/.config/fish/conf.d/abbr-archives.fish

# ==============================================================================
# ARCHIVE & COMPRESSION ABBREVIATIONS
# Pattern: [Action][Format]
# Action: c = Compress, x = Extract, l = List
# Format: z = gz, j = bz2, x = xz, s = zst, zip = zip, r = rar, 7 = 7z
# ==============================================================================

# ------------------------------------------------------------------------------
# COMPRESSION (c + format)
# ------------------------------------------------------------------------------
abbr -a cz   'tar -czvf'        # Compress .tar.gz (Standard)
abbr -a cx   'tar -cJvf'        # Compress .tar.xz (High compression)
abbr -a cj   'tar -cjvf'        # Compress .tar.bz2
abbr -a cs   'tar --zstd -cvf'  # Compress .tar.zst (Fast/Modern)
abbr -a ct   'tar -cvf'         # Compress raw .tar
abbr -a czip 'zip -r'           # Compress directory to .zip
abbr -a c7   '7z a'             # Compress/Create .7z archive

# ------------------------------------------------------------------------------
# EXTRACTION (x + format)
# ------------------------------------------------------------------------------
abbr -a xt   'tar -xvf'         # Extract ANY tar archive (auto-detects gz, xz, etc.)
abbr -a xzip 'unzip'            # Extract .zip
abbr -a xr   'unar'             # Extract .rar (using unar for robust support)
abbr -a x7   '7z x'             # Extract .7z archive (preserving paths)

# Standalone single-file compression/decompression
abbr -a xzst 'zstd -d'          # Extract standalone .zst
abbr -a xgz  'gunzip -k'        # Extract standalone .gz
abbr -a xxz  'xz -dk'           # Extract standalone .xz

# ------------------------------------------------------------------------------
# LIST CONTENTS (l + format)
# ------------------------------------------------------------------------------
abbr -a ltar 'tar -tvf'         # List contents of ANY tar archive
abbr -a lzip 'unzip -l'         # List contents of .zip archive
abbr -a lr   'unar -t'          # List contents of .rar archive
abbr -a l7   '7z l'             # List contents of .7z archive
