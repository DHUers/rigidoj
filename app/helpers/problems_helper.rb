module ProblemsHelper
  class TextHelper
    extend ActionView::Helpers::TextHelper
  end

  def accepted_rate(problem)
    return '-' if problem.submission_count == 0

    "#{problem.accepted_count / problem.submission_count * 100}%"
  end

  def description_blurb(problem)
    fragment = Nokogiri::HTML.fragment(problem.baked)
    processed = ''
    fragment.css('.problem-section.description p').each do |node|
      processed << node.to_html
    end
    cooked = HtmlScrubber.scrub(processed).squish
    blurb = TextHelper.truncate(cooked, length: 200)
    Sanitize.clean(blurb)
  end

  def unique_anchor_id(problem)
    "#{problem.slug}-#{problem.id}"
  end
end
