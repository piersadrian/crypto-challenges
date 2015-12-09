require 'base64'

module Encrypt
  class << self
    def xor_strings(plaintext, key)
      ::Convert.xor_byte_arrays(plaintext.bytes, key.bytes)
    end
  end
end

module Decrypt
  class << self
    COMMON_LETTERS = %w(\  e t a o i n s r h l d c u m f p g w y b v k x j q z)

    def string_frequency_score(plaintext)
      plaintext = plaintext.downcase
      COMMON_LETTERS.reverse.each_with_index.reduce(0) do |score, (letter, idx)|
        score + (plaintext.count(letter) * idx)
      end
    end

    def find_single_char_key_and_decrypt(cipherbytes)
      candidates = (0..255).map do |byte|
        xored_bytes = ::Convert.xor_byte_arrays(cipherbytes, [byte])
        plaintext   = ::Convert.byte_array_to_string(xored_bytes)
        score       = string_frequency_score(plaintext)

        Candidate.new([byte], plaintext.strip, score)
      end

      candidates.max_by(&:score)
    end
  end

  Candidate = Struct.new(:key_bytes, :plaintext, :score)
end

module Convert
  class << self
    def byte_array_to_base64(byte_arr)
      [byte_array_to_string(byte_arr)].pack('m0')
    end

    def byte_array_to_string(byte_arr)
      byte_arr.map(&:chr).join
    end

    def byte_array_to_hex(byte_arr)
      byte_array_to_string(byte_arr).unpack('H*').first
    end

    def hash_to_base64(hex_str)
      byte_array_to_base64( hash_to_byte_array(hex_str) )
    end

    def hash_to_byte_array(hex_str)
      [hex_str].pack('H*').bytes
    end

    def string_to_byte_array(str)
      str.bytes
    end

    def xor_byte_arrays(byte_arr1, byte_arr2)
      byte_arr1, byte_arr2 = byte_arr2, byte_arr1 if byte_arr2.count > byte_arr1.count
      barr2len = byte_arr2.length
      byte_arr1.each_with_index.map { |b, i| b ^ byte_arr2[i % barr2len] }
    end

    def xor_hexes(hex1, hex2)
      byte_array_to_hex( xor_byte_arrays(hash_to_byte_array(hex1), hash_to_byte_array(hex2)) )
    end
  end
end
