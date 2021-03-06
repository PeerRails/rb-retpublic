require "pg"

class DB

  def initialize
    @db_url = ENV["DB_URL"]
    @tablename = self.class.name.downcase
  end

  def self.before(*names)
    names.each do |name|
      m = instance_method(name)
      define_method(name) do |*args, &block|  
        yield
        m.bind(self).(*args, &block)
      end
    end
  end

  def run_query
    @conn = PG.connect(@db_url)
  	unless @query.nil?
	    @rows = []
	    @conn.exec(@query).each do |res|
	      @rows.push res
	    end
      @conn.finish
      @clean
	end
  end

  def query_builder(args)
    @query = args
    @query += " WHERE " unless conditions[:conditions] == {}
    count = conditions[:conditions].nil? ? 1 : conditions[:conditions].count
    conditions[:conditions].each do |k,v|
      @query += "#{k} = #{v}"
      @query += " AND " if count > 1
      count -= 1
    end
    @query += " LIMIT #{conditions[:limit]}" unless conditions[:limit].nil?
    p @query
    run_query
  end

  def get
    query_builder("SELECT * FROM #{@tablename}")
    self
  end

  def each(&block)
  	@rows.each(&block)
  end

  def clean
  	@query = ""
  	@conditions = {}
  	@limit = {}
  end


  def create(options)
    columns = ""
    values = ""
    count ||= options.count
    options.each do |k,v|
      columns += "#{k}"
      values += "#{v}"
      if count >1
        columns += "," if count > 1
        values += "," if count > 1
        count -= 1
      end
    end
    query_builder("INSERT INTO #{@tablename} (#{columns}) VALUES(#{values})")
  end

  def update(id, args)
    count = args.nil? ? 1 : args.count
    q = ""
    args.each do |k, v|
      q += " #{k}=#{v} " if count > 0
      q += "," if count > 1
      count -= 1
    end
    conditions[:conditions] = {id: id}
    query_builder "UPDATE #{@tablename} SET #{q}"
  end

  def rows
    @rows
  end

  def conditions
    @conditions ||= {conditions: {}}
  end

  def where(args)
    conditions[:conditions].merge! args
    self
  end

  def limit(limit)
    conditions[:limit] = limit
    self
  end

  def last
  	if @rows.nil? || @rows.empty?
  	  self.limit(1).get.rows
  	else
  	  @rows.last
  	end
  end

  def first
  	if @rows.nil? || @rows.empty?
  	  self.limit(1).get.rows
  	else
  	  @rows.first
  	end
  end

  def all
  	@rows
  end

  def count
  	@rows.count
  end

  #protected :clean, :query_builder, :query, :exec
  #before("where", "create", "update") { @clean }
end
