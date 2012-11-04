class Door
  include Celluloid  
  
  def initialize
    @status = :open
  end
  
  def open?
    puts status
    status == :open
  end

  def closed?
    !open?
  end  
  
  def status
    @status
  end

  def status=(state)
    @status = state
  end
end


begin
  require './door_on_raspberrypi'    
rescue LoadError
  puts 'This is running on a desktop machine'
end  
