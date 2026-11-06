# Archive abbreviations — compress, extract, and list archives.
# Pattern: [action][format]. Action: c compress, x extract, l list. Format: z gz, j bz2, x xz, s zst, zip, r rar, 7 7z.

# Compress: create an archive. Add the file or directory name after the abbreviation.
abbr -a cz   'tar -czvf'        # Compress .tar.gz (Standard)
abbr -a cx   'tar -cJvf'        # Compress .tar.xz (High compression)
abbr -a cj   'tar -cjvf'        # Compress .tar.bz2
abbr -a cs   'tar --zstd -cvf'  # Compress .tar.zst (Fast/Modern)
abbr -a ct   'tar -cvf'         # Compress raw .tar
abbr -a czip 'zip -r'           # Compress directory to .zip
abbr -a c7   '7z a'             # Compress/Create .7z archive

# Extract: unpack an archive. `xt` handles any tar variant automatically.
abbr -a xt   'tar -xvf'         # Extract ANY tar archive (auto-detects gz, xz, etc.)
abbr -a xzip 'unzip'            # Extract .zip
abbr -a xr   'unar'             # Extract .rar (using unar for robust support)
abbr -a x7   '7z x'             # Extract .7z archive (preserving paths)

# Single files: decompress one compressed file.
abbr -a xzst 'zstd -d'          # Extract standalone .zst
abbr -a xgz  'gunzip -k'        # Extract standalone .gz
abbr -a xxz  'xz -dk'           # Extract standalone .xz

# List: show archive contents without extracting.
abbr -a ltar 'tar -tvf'         # List contents of ANY tar archive
abbr -a lzip 'unzip -l'         # List contents of .zip archive
abbr -a lr   'lsar'             # List contents of .rar archive
abbr -a l7   '7z l'             # List contents of .7z archive
