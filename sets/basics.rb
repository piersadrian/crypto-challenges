set("Basics") do
  challenge("Convert hex to base64") do
    hex_str = "49276d206b696c6c696e6720796f757220627261696e206c696b65206120706f69736f6e6f7573206d757368726f6f6d"
    b64_str = "SSdtIGtpbGxpbmcgeW91ciBicmFpbiBsaWtlIGEgcG9pc29ub3VzIG11c2hyb29t"
    ::Convert.h2b64(hex_str) == b64_str
  end

  challenge("Fixed XOR") do
    hex_str1 = "1c0111001f010100061a024b53535009181c"
    hex_str2 = "686974207468652062756c6c277320657965"
    hex_res  = "746865206b696420646f6e277420706c6179"
    ::Convert.xorh(hex_str1, hex_str2) == hex_res
  end

  challenge("Single-byte XOR cipher") do
    cipherhex   = "1b37373331363f78151b7f2b783431333d78397828372d363c78373e783a393b3736"
    cipherbytes = ::Convert.h2barr(cipherhex)

    key_byte_options = ("A".."z")
    scores = key_byte_options.map do |byte|
      xored_arr = ::Convert.xorbarr(cipherbytes, [byte.ord] * cipherbytes.count)
      plaintext = ::Convert.barr2s(xored_arr)
      score     = ::Detect.scorefreq(plaintext)

      [byte, score]
    end

    key = scores.max { |a, b| a[1] <=> b[1] }[0]
    plaintext = ::Convert.barr2s( ::Convert.xorbarr(cipherbytes, [key.ord] * cipherbytes.count) )
    plaintext == "Cooking MC's like a pound of bacon"
  end
end
