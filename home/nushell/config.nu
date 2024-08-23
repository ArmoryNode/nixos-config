let carapace_completer = {|spans|
carapace $spans.0 nushell $spans | from json
}

$env.config = {
  show_banner: false
  completions: {
    case_sensitive: false
    quick: true
    partial: true
    algorithm: "Fuzzy"
    external: {
        enable: true
        max_results: 100
        completer: $carapace_completer
    }
  }
}

$env.PATH = (
    $env.PATH |
    split row (char esep) |
    prepend /home/armorynode/.apps |
    append /usr/bin/env
)
