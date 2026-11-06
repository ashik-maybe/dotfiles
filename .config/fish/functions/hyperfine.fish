# hyperfine — Benchmark commands with warmup, repeats, and statistics.
#   hyperfine 'rg foo' 'grep -r foo'  # compare two commands
#   hyperfine -r 20 './script.sh'     # 20 runs, tighter error bars
#   hyperfine --warmup 3 './build'    # discard 3 warmup runs
#   hyperfine --export-json out.json './a' './b'  # save results for CI
function hyperfine --description "Command-line benchmarking tool"
    command hyperfine $argv
end
