
# TODO: OK Use a supervision group
#       Move webhook registration to seperate process, backed by redis/webinterface
#       OK Start DCell in ./bin/gatorate?
#       Trap INT/SIGINT an exit gracefully
#       OK DEBUG mode in gatorate so we dont leak any exceptions by we can with DEBUG=1 bundle exec ./bin/gatorate


module Gatorate
  class Observer < Celluloid::SupervisionGroup
    supervise Webhook::Channel, as: :channel_actor

    supervise Gatorate::Door, as: :door, args: [{pin: 0, frequency: 0.1}]
    supervise Gatorate::Heartbeat, as: :heartbeat, args: [{pin: 17, frequency: 10}]

    trap_exit :hello

    def hello
      puts "*" * 100
    end

   end
end


