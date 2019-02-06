class HoobsKubes
  def self.current_context
    %x{kubectl config current-context}.strip
  end

  def self.change_context
    %x{kubectx #{context}}
    check_correct_context
  end

  def self.check_correct_context
    Kernel.abort("Context mismatch: expected is `#{context}` but current is `#{current_context}`") unless context == current_context
    log "Context is #{current_context.bold.green}"
  end

  def self.pretty_print_table(resource, namespace=nil)
    extra = resource == "nodes" ? " -Lbeta.kubernetes.io/instance-type -Lfailure-domain.beta.kubernetes.io/zone" : ""

    if namespace.nil?
      out = %x{kubectl get #{resource}#{extra}}
      label = resource.capitalize
    else
      out = %x{kubectl get #{resource} --namespace=#{namespace}#{extra}}
      label = "#{resource.capitalize} in #{namespace}"
    end

    first = true
    out.each_line do |line|
      if first
        first = false
        padlen = line.strip.length - label.length - 2
        lpad = "=" * (padlen / 2)
        rpad = lpad + ("=" * (padlen % 2))
        puts "#{lpad} #{label} #{rpad}".bold.cyan
        puts line.strip.bold
      else
        puts line.strip
      end
    end
    puts "\n"
  end

  def self.apply_dir(dirname)
    log "Applying #{dirname}:".bold.cyan
    path = "#{@@dir}/#{dirname}"
    Dir.foreach(path) do |item|
      next if item == '.' or item == '..'
      log "  #{item}"
      result = %x{kubectl apply -f #{path}/#{item}}.strip
      result.each_line do |line|
        if line.include? "unchanged"
          line = line.strip.bold.green
        elsif line.include? "configured"
          line = line.strip.bold.brown
        else
          line = line.strip.bold.red
        end
        log "    #{line}"
      end
    end
  end

  def self.log(str)
    str.lines do |line|
      puts line.strip.empty? ? "" : "[#{Time.now.to_s.gray}] #{line}"
    end
  end

  def self.do_status
    log "#{current_context} Cluster Status:".bold.cyan
    status
  end

  def self.do_deploy
    begin
      log "Starting deploy".bold.cyan
      deploy
      log "Done!".bold.green
    rescue
      log "Error!".bold.red
      raise
    end

    do_status
  end

  def self.run(dir)
    @@dir = dir

    if ARGV.length == 0
      do_deploy
    elsif ARGV.include? "-s" or ARGV.include? "--status"
      do_status
    elsif ARGV.include? "-c" or ARGV.include? "--change-context"
      change_context
    elsif ARGV.include? "--help"
      log "Usage: ./deploy.rb [options]"
      log "  With no options, this will apply yamls and display status"
      log ""
      log "Options:"
      log "  --help      : This message"
      log "  -s --status : Display only status"
    else
      log "Unknown usage: deploy.rb #{ARGV.join " "}"
    end
  end
end

class String
  def black;          "\e[30m#{self}\e[0m" end
  def red;            "\e[31m#{self}\e[0m" end
  def green;          "\e[32m#{self}\e[0m" end
  def brown;          "\e[33m#{self}\e[0m" end
  def blue;           "\e[34m#{self}\e[0m" end
  def magenta;        "\e[35m#{self}\e[0m" end
  def cyan;           "\e[36m#{self}\e[0m" end
  def gray;           "\e[37m#{self}\e[0m" end

  def bg_black;       "\e[40m#{self}\e[0m" end
  def bg_red;         "\e[41m#{self}\e[0m" end
  def bg_green;       "\e[42m#{self}\e[0m" end
  def bg_brown;       "\e[43m#{self}\e[0m" end
  def bg_blue;        "\e[44m#{self}\e[0m" end
  def bg_magenta;     "\e[45m#{self}\e[0m" end
  def bg_cyan;        "\e[46m#{self}\e[0m" end
  def bg_gray;        "\e[47m#{self}\e[0m" end

  def bold;           "\e[1m#{self}\e[22m" end
  def italic;         "\e[3m#{self}\e[23m" end
  def underline;      "\e[4m#{self}\e[24m" end
  def blink;          "\e[5m#{self}\e[25m" end
  def reverse_color;  "\e[7m#{self}\e[27m" end
end
