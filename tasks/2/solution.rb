class Hash
  def fetch_deep(path)
    k = path.split('.')
    cur = self
    while cur && k.any?
      return nil unless cur.respond_to?(:fetch)
      cur = cur.class == Array ? cur[k[0].to_i] : cur[k[0]] || cur[k[0].to_sym]
      k.shift
    end
    cur
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
end