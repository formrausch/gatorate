require 'celluloid'
require 'celluloid/io'

module Artoo
  module Adaptors
    module IO
      class DigitalPin
        attr_reader :pin_num, :mode, :pin_file, :status

        GPIO_PATH = "/sys/class/gpio"
        GPIO_DIRECTION_READ = "in"
        GPIO_DIRECTION_WRITE = "out"
        HIGH = 1
        LOW = 0

        def initialize(pin_num, mode, path=GPIO_PATH)
          @pin_num = pin_num
          @path = path

          File.open("#{ @path }/export", "w") { |f| f.write("#{ pin_num }") }

          # Sets the pin for read or write
          set_mode(mode)
        end

        # Writes to the specified pin Digitally
        # accepts values :high or :low, 1 or 0, "1" or "0"
        def digital_write(value)
          set_mode('w') unless @mode == 'w'

          if value.is_a? Symbol
            value = (value == :high) ? 1 : 0
          end

          value = value.to_i

          raise StandardError unless ([HIGH, LOW].include? value)

          @status = (value == 1) ? 'high' : 'low'

          @pin_file.write(value)
          @pin_file.flush
        end

        # Reads digitally from the specified pin on initialize
        def digital_read
          set_mode('r') unless @mode == 'r'

          @pin_file.read
        end

        # Sets the pin in GPIO for read or write.
        def set_mode(mode)
          @mode = mode

          if mode == 'w'
            File.open("#{ @path }/gpio#{ pin_num }/direction", "w") { |f| f.write(GPIO_DIRECTION_WRITE) }
            @pin_file = File.open("#{ @path }/gpio#{ pin_num }/value", "w")
          elsif mode =='r'
            File.open("#{ @path }/gpio#{ pin_num }/direction", "w") { |f| f.write(GPIO_DIRECTION_READ) }
            @pin_file = File.open("#{ @path }/gpio#{pin_num}/value", "r")
          end
        end

        def on?
          (@status == 'high') ? true : false
        end

        def off?
          !self.on?
        end

        # Sets digital write for the pin to HIGH
        def on!
          digital_write(:high)
        end

        # Sets digital write for the pin to LOW
        def off!
          digital_write(:off)
        end

        # Unexports the pin in GPIO to leave it free
        def close
          File.open("#{ @path }/unexport", "w") { |f| f.write("#{pin_num}") }
        end
      end
    end
  end
end

module Artoo
  module Adaptors
    module IO
      class VirtalPin < DigitalPin
        def initialize(pin_num, mode)
          puts "!" * 100
        end

        def digital_write(value)
        end

        def digital_read
          Random.rand(10) <= 2 ? 'high' : 'low'
        end

        def close
        end

        def set_mode(mode)
        end
      end
    end
  end
end

