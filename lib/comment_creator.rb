class CommentCreator

  attr_reader :errors, :opts

  # Acceptable options:
  #
  #   raw                     - raw text of comment
  #   created_at              - Comment creation time (optional)
  #
  #   When replying to a comment:
  #     post_id                 - comment we're replying to
  #     reply_to_comment_number - comment number we're replying to
  #
  #   When creating a post:
  #     title                 - New post title
  #     created_at            - Post creation time (optional)
  #
  def initialize(user, opts)
    @user = user
    @opts = opts || {}
  end

  def skip_validations?
    @opts[:skip_validations]
  end

  def create
    @post = nil
    @comment = nil

    if @user.suspended? && !skip_validations?
      @errors = Post.new.errors
      @errors.add(:base, I18n.t(:user_is_suspended))
      return
    end

    transaction do
      setup_post
      setup_comment
      save_comment
    end

    @comment
  end

  def self.create(user, opts)
    CommentCreator.new(user, opts).create
  end

  protected

  def transaction(&blk)
    Comment.transaction do
      blk.call
    end
  end

  private

  def setup_post
    if new_post?
      begin
        post = Post.create(title: @opts[:title], published: @opts[:published])
        @errors = post.errors
      rescue ActiveRecord::Rollback => ex
        # In the event of a rollback, grab the errors from the topic
        @errors = post.errors
        raise ex
      end
    else
      post = Post.find_by(id: @opts[:post_id])
      return unless policy(@user, post).create?
    end
    @post = post
  end

  def setup_comment
    comment = @post.comments.new(raw: @opts[:raw],
                                 user: @user,
                                 comment_number: @post.comments.count + 1)

    post.created_at = Time.zone.parse(@opts[:created_at].to_s) if @opts[:created_at].present?

    @comment = comment
  end

  def save_comment
    unless @comment.save(validate: !skip_validations?)
      @errors = @comment.errors
      raise ActiveRecord::Rollback.new
    end
  end

  def new_post?
    @opts[:post_id].blank?
  end

end
