class Tado::Wrapper < OpenStruct
  def initialize(client, hash)
    @client = client
    @table = {}

    append_hash(hash)
  end

  def append_hash(hash)
    return unless hash

    for key, value in hash
      key = key.to_sym

      if value.is_a?(Array)
        # value = value.map { |entry| wrap(Tado::Wrapper, entry) }
      end

      @table[key] = value
      new_ostruct_member(key)
    end
  end

  def attribute_with_details
    ensure_details!
    @table[__callee__.to_sym]
  end

  def wrap(klass, entry)
    klass.new(@client, entry)
  end
end
