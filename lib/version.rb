module Rigidoj
  unless defined? ::Rigidoj::VERSION
    module VERSION #:nodoc:
      MAJOR = 0
      MINOR = 0
      TINY  = 9

      STRING = [MAJOR, MINOR, TINY].compact.join('.')
    end
  end
end
