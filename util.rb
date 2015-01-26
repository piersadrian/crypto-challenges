require 'base64'

module Encrypt
  class << self
    def xorencrypt(plaintext, key)
      ::Convert.xorbarr(plaintext.bytes, key.bytes)
    end
  end
end

module Decrypt
  class << self
    COMMON_LETTERS = %w(\  e t a o i n s r h l d c u m f p g w y b v k x j q z)

    def scorefreq_string(plaintext)
      plaintext = plaintext.downcase
      COMMON_LETTERS.reverse.each_with_index.reduce(0) do |score, (letter, idx)|
        score + (plaintext.count(letter) * idx)
      end
    end

    def xordecrypt(cipherbytes, keybytes)
      xored_bytes = ::Convert.xorbarr(cipherbytes, keybytes)
      ::Convert.barr2s(xored_bytes)
    end

    def findsinglecharkey(cipherbytes)
      candidates = (0..255).map do |byte|
        plaintext = xordecrypt(cipherbytes, [byte])
        score     = scorefreq_string(plaintext)
        Candidate.new([byte], plaintext.strip, score)
      end

      candidates.max_by(&:score)
    end
  end

  Candidate = Struct.new(:key_bytes, :plaintext, :score)
end

module Convert
  class << self
    def barr2b64(byte_arr)
      [barr2s(byte_arr)].pack('m0')
    end

    def barr2s(byte_arr)
      byte_arr.map(&:chr).join
    end

    def barr2h(byte_arr)
      barr2s(byte_arr).unpack('H*').first
    end

    def h2b64(hex_str)
      barr2b64( h2barr(hex_str) )
    end

    def h2barr(hex_str)
      [hex_str].pack('H*').bytes
    end

    def s2barr(str)
      str.bytes
    end

    def xorbarr(byte_arr1, byte_arr2)
      byte_arr1, byte_arr2 = byte_arr2, byte_arr1 if byte_arr2.count > byte_arr1.count
      barr2len = byte_arr2.length
      byte_arr1.each_with_index.map { |b, i| b ^ byte_arr2[i % barr2len] }
    end

    def xorh(hex1, hex2)
      barr2h( xorbarr(h2barr(hex1), h2barr(hex2)) )
    end
  end
end
