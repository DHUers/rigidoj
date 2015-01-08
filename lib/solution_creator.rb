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
    solution_json = BasicSolutionSerializer.new(@solution).to_json
  end
end
