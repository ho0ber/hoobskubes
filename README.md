# hoobskubes
Kubernetes configuration deployment

https://rubygems.org/gems/hoobskubes

### [📺 See it in action!](http://h8s.io/hoobskubes.m4v)

## About
This is a clunky and ill-advised gem designed to make it easy to apply your kubernetes yaml files.

Essentially, this replaces my bash file that had a bunch of garbage like this:
```bash
#!/bin/bash
echo "Applying apps:"
for f in apps/*.yaml; do
    kubectl apply -f "$f"
done

echo "Applying ingresses:"
for f in ingresses/*.yaml; do
    kubectl apply -f "$f"
done

CURRENT_CONTEXT=$(kubectl config current-context)

echo "$CURRENT_CONTEXT Cluster Status:"
echo -e "\n--- Pods ---" && kubectl get pods
echo -e "\n--- Deployments ---" && kubectl get deployments
echo -e "\n--- Services ---" && kubectl get services
echo -e "\n--- Ingresses ---" && kubectl get ingresses
```

with something like this:
```ruby
#!/usr/bin/env ruby
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
    pretty_print_table "pods"
    pretty_print_table "deployments"
    pretty_print_table "services"
    pretty_print_table "ingresses"
  end
end

if __FILE__ == $0
  HoobsKubes.run(__dir__)
end
```

**So not terribly different, but it adds a few features:**
* Color-coded output (unchanged = green, configured = brown)
* Context-safety and switching (don't apply a bunch of config to the wrong cluster!)
* Command-line options to just show status or change context
* Extensibility! There's a lot of stuff we could do to make this more useful.

See [examples](examples/) for a more complete example
