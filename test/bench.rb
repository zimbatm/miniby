require 'markaby'
require 'miniby'
require 'benchmark'

pad = 20

document = lambda do |*a|
  head do
    title "Some title"
    link :rel=>:stylesheet, :href=>"theme.css"
    script :src=>"jquery.js"
  end
  body do
    h1 "Some title"
    ul :class=>:nav do
      li "one"
      li "two"
      li "three"
      li "four"
    end
  end
end

res1 = res2 = res3 = ""
Benchmark.bm pad do |r|
  r.report('markaby') do
    2_000.times do
      b = Markaby::Builder.new
      b.html(&document)
      res1 = b.to_s
    end
  end
  r.report('miniby') do
    2_000.times do
      b = Miniby::SaneHtml.new
      b.html(&document)
      res2 = b.to_s
    end
  end
  r.report('miniby fast') do
    2_000.times do
      b = Miniby::FastHtml.new
      b.html(&document)
      res3 = b.to_s
    end
  end
end

attrib = 'http://en.wikipedia.com/wiki/GreatArticle"wikipediaspecialchar'
Benchmark.bm pad do |x|
  x.report('gsub str str') do
    1_000.times do
      attrib.gsub('"', '&quot;')
    end
  end
  x.report('gsub reg str') do
    1_000.times do
      attrib.gsub(%r{"}, '&quot;')
    end
  end
end

res1 = res2 = res3 = ""
Benchmark.bm pad do |x|
  key = :type
  val = 'text'
  x.report('join2') do
    1_000.times do
      res1 = [key, val].join('=')
    end
  end
  x.report('concat2') do
    1_000.times do
      res2 = key.to_s + '=' + val.to_s
    end
  end
  x.report('interpolate2') do
    1_000.times do
      res3 = "#{key}=#{val}"
    end
  end
end

res1 = res2 = false
Benchmark.bm pad do |x|
  key = :type
  x.report("ary(#{Miniby::BOOLEAN_ATTRIBUTES.size}) lookup") do
    1_000.times do
      res1 = Miniby::BOOLEAN_ATTRIBUTES.include? key.to_s
    end
  end
  x.report('hash lookup') do
    1_000.times do
      res2 = Miniby::BOOLEAN_ATTRIBUTES_HASH[key]
    end
  end
end
