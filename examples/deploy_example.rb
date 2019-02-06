#!/usr/bin/env ruby

# gem install hoobskubes to use
require 'hoobskubes'

class HoobsKubes
  def self.context
    "my-cool-cluster"
  end

  def self.deploy
    change_context 
    apply_dir "apps"
    apply_dir "ingresses"
  end

  def self.status
    log "#{current_context} Cluster Status:".bold.cyan
    pretty_print_table "nodes"
    pretty_print_table "pods"
    pretty_print_table "deployments"
    pretty_print_table "services"
    pretty_print_table "ingresses"
  end
end

if __FILE__ == $0
  HoobsKubes.run(__dir__)
end
