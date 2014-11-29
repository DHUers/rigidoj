require 'openssl'
require 'xor'

class Pbkdf2

  def self.hash_password(password, salt, iterations, algorithm = 'sha256')

    h = OpenSSL::Digest.new(algorithm)
    u = ret = prf(h, password, salt + [1].pack('N'))

    2.upto(iterations) do
      u = prf(h, password, u)
      ret.xor!(u)
    end

    ret.bytes.map{|b| ('0' + b.to_s(16))[-2..-1]}.join('')
  end

  protected

  # fallback xor in case we need it for jruby ... way slower
  def self.xor(x,y)
    x.bytes.zip(y.bytes).map{|x,y| x ^ y}.pack('c*')
  end

  def self.prf(hash_function, password, data)
    OpenSSL::HMAC.digest(hash_function, password, data)
  end

end
