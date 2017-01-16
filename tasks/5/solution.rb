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
    return @attributes if attrs.empty?

    @attributes = attrs + [:id]

     @attributes.each do |attr|
       define_singleton_method("find_by_#{attr}") { |value| where([[attr, value]].to_h) }
       attr_accessor attr
     end
  end

  def self.data_store(store = nil)
    store.nil? ? @data_store : @data_store = store
  end

  def self.where(kwargz)
    kwargz.keys.reject { |arg| @attributes.include? arg }.each do |arg|
      raise UnknownAttributeError.new("Unknown attribute #{arg}")
    end

    @data_store.find(kwargz).map { |found| new(found) }
  end
  
  def ==(other)
    return self.equal?(other) if id.nil?
    res = (other.instance_of?(self.class) && @id == other.id) ? true : false
    res || (object_id == other.object_id) ? true : false
  end

  def save
    @id = @id.nil? ? self.class.data_store.next_id : @id
    hash = self.class.attributes
               .map { |attr| [attr, instance_variable_get("@#{attr}")] }.to_h
    self.class.data_store.create(hash)
    self
  end

  def delete
    raise DeleteUnsavedRecordError if @id.nil?
    self.class.data_store.delete(id: id)
    @id = nil

  end

  class DeleteUnsavedRecordError < StandardError
  end

  class UnknownAttributeError < StandardError
  end
end

class HashStore
  attr_reader :storage

  def initialize
    @storage = {}
    @id_counter = 0
  end

  def next_id
    @id_counter += 1
  end

  def create(record)
    @storage[record[:id]] = record
  end

  def find(query)
    @storage.values.select do |record|
      query.all? { |key, value| record[key] == value }
    end
  end

  def delete(query)
    find(query).each { |record| @storage.delete(record[:id]) }
  end

  def update(id, record)
    return unless @storage.key? id

    @storage[id] = record
  end
end

class ArrayStore
  attr_reader :storage

  def initialize
    @storage = []
    @id_counter = 0
  end

  def next_id
    @id_counter += 1
  end

  def create(record)
    @storage << record
  end

  def find(query)
    @storage.select { |record| match_record? query, record }
  end

  def delete(query)
    @storage.reject! { |record| match_record? query, record }
  end

  def update(id, record)
    index = @storage.find_index { |record| record[:id] == id }
    return unless index

    @storage[index] = record
  end

  private

  def match_record?(query, record)
    query.all? { |key, value| record[key] == value }
  end
end