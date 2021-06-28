require File.expand_path('../../config/environment', __dir__)

user = User.find_by(:name =>ARGV[0])

ActiveRecord::Base.logger = ActiveSupport::Logger.new("log/VN-4142.log")
ActiveRecord::Base.logger.level = 0

# Warm up the class names
Relationship.pluck(:resource_type).uniq.each { |c| c.constantize.descendants }

options = {}
time_options = Benchmark.realtime {
options = {
    :targets => Vm.all.to_a,
    :user => user,
    :skip_counts => true,
    :offset => 0,
    :limit => 1000
  }
}
res=[]
time_rbac = Benchmark.realtime {
  res = Rbac.search(options).first
}

ActiveRecord::Base.logger.info("User #{user.name}.")
ActiveRecord::Base.logger.info("options done in #{'%.2f' % time_options} sec.")
ActiveRecord::Base.logger.info("rbac done in #{'%.2f' % time_rbac} sec.")
