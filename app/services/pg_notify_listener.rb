class PgNotifyListener
  def initialize(channel)
    @channel = channel
    @conn = pg_connect
    @conn.exec("LISTEN #{@channel}")
  end

  def wait(timeout = 5, &)
    @conn.wait_for_notify(timeout, &)
  end

  def close
    return if @conn.finished?
    @conn.exec("UNLISTEN #{@channel}")
    @conn.close
  end

  private

  def pg_connect
    config = ActiveRecord::Base.connection_db_config.configuration_hash
    PG.connect(
      host:     config[:host],
      port:     config[:port],
      dbname:   config[:database],
      user:     config[:username],
      password: config[:password]
    )
  end
end