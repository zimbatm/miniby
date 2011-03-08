require 'miniby'
require 'profile'

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

1_000.times do
  b = Miniby::FastHtml.new
  b.html(&document)
  b.to_s
end
