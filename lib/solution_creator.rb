class SolutionCreator

  attr_reader :errors, :opts

  # Acceptable options:
  #
  def initialize(user, opts)
    @user = user
    @opts = opts || {}
  end

  def create
    @solution = Solution.new(opts)

    if @solution.save
      publish_to_judger
    else
      @errors = @solution.errors
    end
  end

  def publish_to_judger
  end
end
