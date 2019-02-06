#!/usr/bin/env ruby

def context
  "my-cool-cluster"
end

def deploy
  change_context 
  apply_dir "apps"
  apply_dir "ingresses"
end

def status
  log "#{current_context} Cluster Status:".bold.cyan
  pretty_print_table "nodes"
  pretty_print_table "pods"
  pretty_print_table "deployments"
  pretty_print_table "services"
  pretty_print_table "ingresses"
end


if __FILE__ == $0
  %x{curl -s -o ~/.hoobskubes.rb "https://raw.githubusercontent.com/ho0ber/hoobskubes/master/hoobskubes.rb"}
  load '~/.hoobskubes.rb'
  run
end
