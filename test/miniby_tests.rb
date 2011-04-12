require 'minitest/autorun'
require 'miniby'

class MinibyTest < MiniTest::Unit::TestCase
  include Miniby
  def new_doc(&block)
    Miniby::SaneHtml.new(&block)
  end

  def test_we_have_all_elements
    all_elements = (MetadataContent + StyleContent + SectioningContent + HeadingContent + PhrasingContent + EmbeddedContent + InteractiveContent).uniq.sort.map(&:to_sym)
    assert_equal [], all_elements - ElementAttributes.keys
  end

  def test_simple_h1_tag
    doc = new_doc do
      h1 "Test"
    end
    assert_equal "<h1>Test</h1>", doc.to_s
  end

  def test_self_closing_tag
    doc = new_doc do
      input :type=>:text
    end
    assert_equal "<input type=text>", doc.to_s
  end

  def test_simple_sub_elem
    doc = new_doc do
      p do
        span "Foo"
      end
    end
    assert_equal "<p><span>Foo</span></p>", doc.to_s
  end

  def test_simple_attr_serialization
    doc = new_doc do
      h1 "Test", :class => "foo"
    end
    assert_equal "<h1 class=foo>Test</h1>", doc.to_s
  end

  def test_attr_fail
    assert_raises(BuildError) do
      new_doc do
        h1 "Test", :does_not_exist => true
      end
    end
  end

  def test_boolean_attr_serialization
    doc = new_doc do
      input :disabled => true
    end
    assert_equal "<input disabled>", doc.to_s
  end

  def test_data_attribute
    doc = new_doc do
      input :type => :text, :data_range=>3
    end
    assert_equal "<input data-range=3 type=text>", doc.to_s
  end

  def test_attribute_escaping
    db_attr = "in<je\"ct".taint
    doc = new_doc do
      input :type=>:text, :value=>db_attr
    end
    assert_equal "<input type=text value=\"in&lt;je&quot;ct\">", doc.to_s
  end

  def test_html_escaping
    db_text = "<script type=\"text\">alert('hohoho');</script>".taint
    doc = new_doc do
      span db_text
    end
    assert_equal "<span>&lt;script type=\"text\"&gt;alert('hohoho');&lt;/script&gt;</span>", doc.to_s
  end

  def test_arbitrary_text_node_insertion
    doc = new_doc do
      span do
        text! "Show"
        b "ME"
        text! "what you want"
      end
    end
    assert_equal "<span>Show<b>ME</b>what you want</span>", doc.to_s
  end

end
class RubyTest < MiniTest::Unit::TestCase
  def test_recusive_join
    x = [:a, [:b, :c], :d]
    assert_equal "a,b,c,d", x.join(',')
  end
end
