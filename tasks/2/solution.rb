class Hash
  def fetch_deep(key_path)
    key, nested_key_path = key_path.split('.', 2)
    value = self[key.to_sym] || self[key.to_s]

    return value unless nested_key_path
    
    value.fetch_deep(nested_key_path) if value
  end

  def reshape(shape)
    shape.map do |key, value|
      if value.is_a? String
        [key, fetch_deep(shape[key])]
      else
        [key, reshape(shape[key])]
      end
    end.to_h
  end
end

class Array
  def reshape(shape)
    map { |element| element.reshape(shape) }
  end

  def fetch_deep(key_path)
    key, nested_key_path = key_path.split('.', 2)
    element = self[key.to_i]

    element.fetch_deep(nested_key_path) if element
  end
end