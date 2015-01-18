require 'base64'

module Detect
  class << self
    COMMON_LETTERS = %w(e t a o i n s h r d l)

    def scorefreq(plaintext)
      score = 0
      COMMON_LETTERS.reverse.each_with_index do |letter, idx|
        count = plaintext.count(letter)
        score += count * idx
      end
      score
    end
  end
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

    def xorbarr(byte_arr1, byte_arr2)
      byte_arr1.zip(byte_arr2).map { |l, r| l ^ r }
    end

    def xorh(hex1, hex2)
      barr2h( xorbarr(h2barr(hex1), h2barr(hex2)) )
    end
  end
end
