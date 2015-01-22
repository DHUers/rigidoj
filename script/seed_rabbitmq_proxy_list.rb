require 'optparse'
require 'yaml'
require_relative '../lib/rigidoj'

Rigidoj.after_fork

solution_source_file = File.open(File.expand_path(File.dirname(__FILE__) + '/solution_source.yml'))
solution_source = YAML.load(solution_source_file)

opts = OptionParser.new do |o|
  o.banner = "Usage: ruby seed_rabbitmq_proxy_list.rb [options]"

  o.on("-o", "--with_online_judge", "Test certain online judge") do |o|
    @filter = o
  end
end
opts.parse!

def publish_to_proxy_queue(solution_json)
  proxy_queue = $rabbitmq_judger_proxy_queue
  puts solution_json
  proxy_queue.publish solution_json
end

publish_to_proxy_queue('{"solution":{"id":49,"platform":"c","source":"fake","revision":0,"problem_id":41},"problems":[{"id":41,"judge_type":"remote_proxy","judge_data":{"vendor":"HDU,5037"}}]}')
