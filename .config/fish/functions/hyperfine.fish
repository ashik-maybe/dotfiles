# hyperfine — benchmark shell commands properly: warmup, repeats, statistics.
#   hyperfine 'rg foo' 'grep -r foo'  # race two commands, see the winner
#   hyperfine -r 20 './script.sh'     # more runs = tighter error bars
#   hyperfine --warmup 3 './build'    # first run is usually an outlier
#   hyperfine --export-json out.json './a' './b'  # keep results for CI
function hyperfine --description "Command-line benchmarking tool"
    command hyperfine $argv
end
