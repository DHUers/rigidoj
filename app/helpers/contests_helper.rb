module ContestsHelper
  def alphabet_offset(offset)
    ('A'.ord + offset).chr
  end

  def contest_problem_select_options(problems)
    @problem_options ||= problems.each_with_index.map do |p,i|
      ["#{alphabet_offset(i)}: #{p.title}", i]
    end
  end
end
