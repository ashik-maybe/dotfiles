# ~/.config/fish/conf.d/abbr-archives.fish

# ==============================================================================
# ARCHIVE & COMPRESSION ABBREVIATIONS
# Pattern: [Action][Format]
# Action: c = Compress, x = Extract, l = List
# Format: z = gz, j = bz2, x = xz, s = zst, zip = zip
# ==============================================================================

# ------------------------------------------------------------------------------
# COMPRESSION (c + format)
# ------------------------------------------------------------------------------
abbr -a cz   'tar -czvf'        # Compress .tar.gz (Standard)
abbr -a cx   'tar -cJvf'        # Compress .tar.xz (High compression)
abbr -a cj   'tar -cjvf'        # Compress .tar.bz2
abbr -a cs   'tar --zstd -cvf'  # Compress .tar.zst (Fast)
abbr -a ct   'tar -cvf'         # Compress raw .tar
abbr -a czip 'zip -r'           # Compress .zip

# ------------------------------------------------------------------------------
# EXTRACTION (x + format / x for any tar)
# ------------------------------------------------------------------------------
abbr -a xt   'tar -xvf'         # Extract ANY tar archive (.tar.gz, .tar.xz, .tar.zst, etc.)
abbr -a xzip 'unzip'            # Extract .zip
abbr -a xs   'zstd -d'          # Extract standalone .zst
abbr -a xgz  'gunzip -k'        # Extract standalone .gz
abbr -a xxz  'xz -dk'           # Extract standalone .xz

# ------------------------------------------------------------------------------
# LIST CONTENTS (l + format)
# ------------------------------------------------------------------------------
abbr -a lt   'tar -tvf'         # List contents of ANY tar archive
abbr -a lzip 'unzip -l'         # List contents of .zip archive
