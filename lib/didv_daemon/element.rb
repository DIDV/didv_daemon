class Element < String
  def is_upcase_word?
    size > 1 and self =~ /\A[A-ZÀ-ÖØ-Ý]+\z/
  end
  def is_numeric_word?
    self =~ /\A[0-9\u20AC$=+-]+\z/
  end
end

def string_element(string)
  string_chars = string.chars
  elements=[]
  element = Element.new
  while string_chars.any?
    element_char = Element.new
    element_char << string_chars.shift
    if element_char =~ /([[:alpha:]]|[0-9])/
      element << element_char
    else
      elements << element unless element.empty?
      element = Element.new
      elements << element_char
    end
  end
  elements << element unless element.empty?
  elements
end
