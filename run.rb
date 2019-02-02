require_relative 'twitter_util.rb'

LIST_FILE = "list.txt"
IMG_DIR = "img"

def collect()
  util = MyUtil.new()
  list = util.collect(LIST_FILE)
end

def dl()

end

dl()
