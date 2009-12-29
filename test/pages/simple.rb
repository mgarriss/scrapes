class LocalSimple < Scrapes::Page

  rule :div, 'div', 'xml()'

  rule :content_one, '#one', 'content()'
  rule :content_two, '#two', 'content()'
  rule :content_three, '#three', 'content()'

  rule :contents_one, '#one', 'contents()'
  rule :contents_two, '#two', 'contents()'
  rule :contents_three, '#three', 'contents()'

  rule :text_one, '#one', 'text()'
  rule :text_two, '#two', 'text()'
  rule :text_three, '#three', 'text()'

  rule :texts_one, '#one', 'texts()'
  rule :texts_two, '#two', 'texts()'
  rule :texts_three, '#three', 'texts()'

end
