n = 30;

bitstream = round(rand(1,253));
bitstream_galois = gf(bitstream, 8);

% Here we encode the bitsream and then we modulate it
rs_encoded_bitstream    = rsenc(bitstream_galois, 255, size(bitstream,2));
qam_modulated_bitstream = qammod(rs_encoded_bitstream.x, 256);

% We add the noisy channel, demodulate, decode, count the errors
% and calculate the BER for both scenarios
 noisy_bitstream = awgn(qam_modulated_bitstream,n,'measured');
 
 demodulated_bitstream = qamdemod(noisy_bitstream, 256); 
 decoded_bitstream     = rsdec(gf(demodulated_bitstream, 8), 255, size(bitstream,2));
 
 failing_bits_uncoded = xor(rs_encoded_bitstream.x, demodulated_bitstream);
 failing_bits_coded   = xor(bitstream, decoded_bitstream.x);
 
 number_errors_coded   = sum(failing_bits_coded(:) == 1);
 number_errors_uncoded = sum(failing_bits_uncoded(:) == 1);
 
 ber_uncoded = number_errors_uncoded / length(rs_encoded_bitstream);
 ber_coded   = number_errors_coded / length(bitstream);

 % Here we calculate the effective bitrate, the energy per bit
 % and the code gain
 code_rate = 187/255;
 
 effective_bitrate_coded   = 8 * code_rate;
 effective_bitrate_uncoded = 8 * 1;
 
 energy_per_bit_coded   = n / effective_bitrate_coded;
 energy_per_bit_uncoded = n / effective_bitrate_uncoded; 
 
 code_gain = energy_per_bit_uncoded / energy_per_bit_coded
