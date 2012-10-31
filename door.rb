require 'bundler/setup'
require './stemcell'

class Door
  include Celluloid

  def initialize
    @status = :closed
  end

  def status
    @status
  end

  def status=(status)
    @status = status
  end

  def open?
    @status == :open
  end

  def closed?
    !open?
  end
end


Door.supervise_as :door_actor

stemcell "door.tomair.local", "127.0.0.1", 9883

sleep

