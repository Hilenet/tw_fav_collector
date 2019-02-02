require 'yaml'
require 'json'
require 'twitter'

class MyUtil
  attr_accessor :client

  def initialize()
    @client = genClient()
  end

  def collect(f, max_id=nil)
    options = {
      count: 200
    }
    options[:max_id] = max_id if max_id

    tw_list = []
    loop do
      puts "collect #{tw_list.size}"

      list = @client.favorites(options)

      url_list = parse(list)
      writeFile(f, url_list)

      tw_list += list

      options[:max_id] = list[-1].id
      puts "done ~#{options[:max_id]}"

      break until list.size > 1
      # break if list.size < options[:count]
    end
  end

  private

  # inner (recursive)
  def _collect(tw_list, f, options)
    puts "collect #{tw_list.size}"

    list = @client.favorites(options)

    url_list = parse(list)
    writeFile(f, url_list)

    tw_list += list

    options[:max_id] = list[-1].id
    puts "done ~#{options[:max_id]}"

    return tw_list if list.size < options[:count]

    _collect(tw_list, f, options)
  end

  def writeFile(filename, list)
    File.open(filename, "a") do |f|
      f.write(list.join("\n"))
    end
  end

  # gen REST Client
  def genClient()
    yaml = YAML.load_file('cred.yml')['cred']

    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = yaml['consumer']['key']
      config.consumer_secret     = yaml['consumer']['secret']
      config.access_token        = yaml['access_token']['key']
      config.access_token_secret = yaml['access_token']['secret']
    end
  end

  # tweet list -> url list
  def parse(tw_list)
    url_list = []

    tw_list.each do |tw|

      tw.media.each do |m|
        next unless m.is_a? Twitter::Media::Photo
        url_list << m.media_uri.to_s
      end
    end
    puts ""

    return url_list
  end



end

