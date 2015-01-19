module HTMLSpecHelper
  def fake(uri, response, verb = :get)
    FakeWeb.register_uri(verb, uri, response: header(response))
  end

  def header(html)
    "HTTP/1.1 200 OK\n\n#{html}"
  end

  def external_oj_response(file)
    file = File.join("spec", "fixtures", "external_oj_problems", "#{file}.response")
    File.exists?(file) ? File.read(file) : ""
  end

  def parsed_markdown(file)
    file = File.join("spec", "fixtures", "external_oj_markdown", "#{file}.md")
    File.exists?(file) ? File.read(file) : ""
  end
end
