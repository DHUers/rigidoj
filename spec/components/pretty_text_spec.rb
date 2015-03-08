require 'spec_helper'
require 'pretty_text'

describe PrettyText do
  skip do

    let(:wrapped_image) { "<div class=\"lightbox-wrapper\"><a href=\"//localhost:3000/uploads/default/4399/33691397e78b4d75.png\" class=\"lightbox\" title=\"Screen Shot 2014-04-14 at 9.47.10 PM.png\"><img src=\"//localhost:3000/uploads/default/_optimized/bd9/b20/bbbcd6a0c0_655x500.png\" width=\"655\" height=\"500\"><div class=\"meta\">\n<span class=\"filename\">Screen Shot 2014-04-14 at 9.47.10 PM.png</span><span class=\"informations\">966x737 1.47 MB</span><span class=\"expand\"></span>\n</div></a></div>" }
    let(:wrapped_image_excerpt) {  }

    describe "Cooking" do

      it "should sanitize the html" do
        expect(PrettyText.cook("<script>alert(42)</script>")).to match_html "<p></p>"
      end

      # see: https://github.com/sparklemotion/nokogiri/issues/1173
      skip 'allows html entities correctly' do
        expect(PrettyText.cook("&aleph;&pound;&#162;")).to eq("<p>&aleph;&pound;&#162;</p>")
      end

    end

    describe "rel nofollow" do
      before do
        SiteSetting.stubs(:add_rel_nofollow_to_user_content).returns(true)
        SiteSetting.stubs(:exclude_rel_nofollow_domains).returns("foo.com|bar.com")
      end

      it "should inject nofollow in all user provided links" do
        expect(PrettyText.cook('<a href="http://cnn.com">cnn</a>')).to match(/nofollow/)
      end

      it "should not inject nofollow in all local links" do
        expect(PrettyText.cook("<a href='#{Rigidoj.base_url}/test.html'>cnn</a>") !~ /nofollow/).to eq(true)
      end

      it "should not inject nofollow in all subdomain links" do
        expect(PrettyText.cook("<a href='#{Rigidoj.base_url.sub('http://', 'http://bla.')}/test.html'>cnn</a>") !~ /nofollow/).to eq(true)
      end

      it "should not inject nofollow for foo.com" do
        expect(PrettyText.cook("<a href='http://foo.com/test.html'>cnn</a>") !~ /nofollow/).to eq(true)
      end

      it "should not inject nofollow for bar.foo.com" do
        expect(PrettyText.cook("<a href='http://bar.foo.com/test.html'>cnn</a>") !~ /nofollow/).to eq(true)
      end

      it "should not inject nofollow if omit_nofollow option is given" do
        expect(PrettyText.cook('<a href="http://cnn.com">cnn</a>', omit_nofollow: true) !~ /nofollow/).to eq(true)
      end
    end

    describe "strip links" do
      it "returns blank for blank input" do
        expect(PrettyText.strip_links("")).to be_blank
      end

      it "does nothing to a string without links" do
        expect(PrettyText.strip_links("I'm the <b>batman</b>")).to eq("I'm the <b>batman</b>")
      end

      it "strips links but leaves the text content" do
        expect(PrettyText.strip_links("I'm the linked <a href='http://en.wikipedia.org/wiki/Batman'>batman</a>")).to eq("I'm the linked batman")
      end

      it "escapes the text content" do
        expect(PrettyText.strip_links("I'm the linked <a href='http://en.wikipedia.org/wiki/Batman'>&lt;batman&gt;</a>")).to eq("I'm the linked &lt;batman&gt;")
      end
    end

    describe "make_all_links_absolute" do
      let(:base_url) { "http://baseurl.net" }

      def make_abs_string(html)
        doc = Nokogiri::HTML.fragment(html)
        described_class.make_all_links_absolute(doc)
        doc.to_html
      end

      before do
        Discourse.stubs(:base_url).returns(base_url)
      end

      it "adds base url to relative links" do
        html = "<p><a class=\"mention\" href=\"/users/wiseguy\">@wiseguy</a>, <a class=\"mention\" href=\"/users/trollol\">@trollol</a> what do you guys think? </p>"
        output = make_abs_string(html)
        expect(output).to eq("<p><a class=\"mention\" href=\"#{base_url}/users/wiseguy\">@wiseguy</a>, <a class=\"mention\" href=\"#{base_url}/users/trollol\">@trollol</a> what do you guys think? </p>")
      end

      it "doesn't change external absolute links" do
        html = "<p>Check out <a href=\"http://mywebsite.com/users/boss\">this guy</a>.</p>"
        expect(make_abs_string(html)).to eq(html)
      end

      it "doesn't change internal absolute links" do
        html = "<p>Check out <a href=\"#{base_url}/users/boss\">this guy</a>.</p>"
        expect(make_abs_string(html)).to eq(html)
      end

      it "can tolerate invalid URLs" do
        html = "<p>Check out <a href=\"not a real url\">this guy</a>.</p>"
        expect { make_abs_string(html) }.to_not raise_error
      end
    end

    describe "strip_image_wrapping" do
      def strip_image_wrapping(html)
        doc = Nokogiri::HTML.fragment(html)
        described_class.strip_image_wrapping(doc)
        doc.to_html
      end

      it "doesn't change HTML when there's no wrapped image" do
        html = "<img src=\"wat.png\">"
        expect(strip_image_wrapping(html)).to eq(html)
      end

      it "strips the metadata" do
        expect(strip_image_wrapping(wrapped_image)).to match_html "<div class=\"lightbox-wrapper\"><a href=\"//localhost:3000/uploads/default/4399/33691397e78b4d75.png\" class=\"lightbox\" title=\"Screen Shot 2014-04-14 at 9.47.10 PM.png\"><img src=\"//localhost:3000/uploads/default/_optimized/bd9/b20/bbbcd6a0c0_655x500.png\" width=\"655\" height=\"500\"></a></div>"
      end
    end

    describe 'format_for_email' do
      it 'does not crash' do
        PrettyText.format_for_email('<a href="mailto:michael.brown@discourse.org?subject=Your%20post%20at%20http://try.discourse.org/t/discussion-happens-so-much/127/1000?u=supermathie">test</a>')
      end
    end

    it 'can escape *' do
      expect(PrettyText.cook("***a***a")).to match_html("<p><strong><em>a</em></strong>a</p>")
      expect(PrettyText.cook("***\\****a")).to match_html("<p><strong><em>*</em></strong>a</p>")
    end
  end
end
