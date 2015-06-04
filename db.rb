require "pg"

class Jobs
  attr_accessor :rows

  def initialize(con)
    @conn = PG.connect(con)
    @tablename = "jobs"
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

  def exec(q)
    @rows = []
    @conn.exec(q).each do |res|
      @rows.push res
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
    return @query
  end

  def get
    query_builder("SELECT * FROM #{@tablename}")
    exec @query
    self
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
    exec @query
  end

  def update(id, args)
    count = args.nil? ? 1 : args.count
    q = ""
    args.each do |k, v|
      q += " #{k} = #{v} "
      q += "," if count > 1
      count -= 1
    end
    query_builder = "UPDATE #{@tablename} SET (#{q})"
    exec @query
  end

  def update_job(id)
    @conn.exec("UPDATE jobs SET done = true WHERE id = #{id}")
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
    @rows.last
  end

  def all
  	@rows
  end

  before("where", "create", "update") { @clean }
end
