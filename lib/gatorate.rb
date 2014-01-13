require_relative 'gatorate/version'
require_relative 'gatorate/support/ip'
require_relative 'gatorate/support/irb'

require_relative 'gatorate/network'
require_relative 'gatorate/webhook'
require_relative 'gatorate/pin_actor'

require_relative 'gatorate/door'
require_relative 'gatorate/heartbeat'

require_relative 'gatorate/console'
require_relative 'gatorate/web'


# TODO:
# Trap INT/SIGINT an exit gracefully

module Gatorate
  class Observer < Celluloid::SupervisionGroup
    supervise Webhook::Channel, as: :channel_actor

    supervise Gatorate::Door, as: :door, args: [{pin: 0, frequency: 0.1}]
    supervise Gatorate::Heartbeat, as: :heartbeat, args: [{pin: 17, frequency: 10}]
  end
end

