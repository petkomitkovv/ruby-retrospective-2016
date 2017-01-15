class DataModel
  attr_reader :id
  
  def initialize(kwargz = {})
    kwargz.each do |k, v|
      if self.class.method_defined?(k)
        var_name = "@#{k}"
        instance_variable_set(var_name, v)
      end
    end
  end

  def self.attributes(*attrs)
    if attrs.empty?
      @attributes
    else
      attrs.each do |attr|
        define_singleton_method("find_by_#{attr}") { |value| where([[attr, value]].to_h) }
        attr_accessor attr
      end
      @attributes = attrs
      @ids = {}
    end
  end

  def self.data_store(store = nil)
    store.nil? ? @data_store : @data_store = store
  end

  def self.where(kwargz)
    found = @data_store.find(kwargz)
    found.map { |k| @ids[k] }.map { |s| ObjectSpace._id2ref(s) }
  end
  
  def ==(other)
    res = (other.instance_of?(self.class) && @id == other.id) ? true : false
    res || (object_id == other.object_id) ? true : false
  end

  def save
    @id = @id.nil? ? self.class.data_store.next_id : @id
    hash = self.class.attributes
               .map { |attr| [attr, instance_variable_get("@#{attr}")] }.to_h
    self.class.data_store.create(hash)
    self.class.ids[hash] = object_id
    self
  end

  def delete
    raise DeleteUnsavedRecordError if @id.nil?
    self.class.data_store.delete_by_id(@id)
    @id = nil

  end

  def self.ids
    @ids.nil? ? nil : @ids
  end

  class DeleteUnsavedRecordError < StandardError
  end
end

class ArrayStore
  attr_reader :storage

  def initialize
    @storage = []
  end

  def create(kwargz)
    @storage[@storage.size] = kwargz
  end

  def find(kwargz)
    @storage.map do |val|
      if val != nil
        kwargz.all? { |k, v| val[k] == v } ? val : nil
      end
    end.compact
  end

  def update(id, attrs)
    @storage[id - 1] == attrs
  end

  def delete(kwargz)
    @storage.each_with_index do |value, index|
      if value != nil
        kwargz.all? { |k, v| value[k] == v } ? @storage[index] = nil : nil
      end
    end
  end

  def delete_by_id(id)
    @storage[id - 1] = nil
  end

  def next_id
    @storage.size + 1
  end
end

class HashStore
  attr_reader :storage

  def initialize
    @storage = {}
  end

  def find(kwargz)
    @storage.map do |_, entry|
      if entry != nil
        kwargz.all? { |k, v| entry[k] == v } ? entry : nil
      end
    end.compact
  end

  def create(kwargz)
    @storage[@storage.size] = kwargz
  end

  def update(id, attrs)
    @storage[id - 1] = attrs
  end

  def delete(kwargz)
    @storage.each do |key, value|
      if value != nil
        kwargz.all? { |k, v| value[k] == v } ? @storage[key] = nil : nil
      end
    end
  end

  def delete_by_id(id)
    @storage[id - 1] = nil
  end

  def next_id
    @storage.size + 1
  end
end