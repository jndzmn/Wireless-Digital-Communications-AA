ber_array_qpsk = [];
ber_array_qam = [];
snr_array = [];

bitstream = round(rand(1,60000));
qpsk_modulated_bitstream = modulate_qpsk(bitstream);
qam_modulated_bitstream = modulate_qam(bitstream);

%Aquí hacer un for, pero para pruebas vale solo con un valor de ruido
for n = 0 : 0.2 : 25
    snr_array(end + 1) = n;
    
    noisy_bitstream = awgn(qpsk_modulated_bitstream,n,'measured');
    demodulated_bitstream = demodulate_qpsk(noisy_bitstream);
    failing_bits = xor(bitstream, demodulated_bitstream);
    number_errors = sum(failing_bits(:) == 1);
    ber = number_errors / length(bitstream);

    ber_array_qpsk(end + 1) = ber;
end

%Aquí hacer un for, pero para pruebas vale solo con un valor de ruido
for n = 0 : 0.2 : 25
    
    noisy_bitstream = awgn(qam_modulated_bitstream,n,'measured');
    demodulated_bitstream = demodulate_qam(noisy_bitstream);
    failing_bits = xor(bitstream, demodulated_bitstream);
    number_errors = sum(failing_bits(:) == 1);
    ber = number_errors / length(bitstream);

    ber_array_qam(end + 1) = ber;
end

semilogy(snr_array,ber_array_qpsk);
hold on;
grid on;
semilogy(snr_array,ber_array_qam);


%Function taht modulates the bitstream for qpsk
function outstream = modulate_qpsk(bitstream)
    
    outstream = [];
    element = 0;
    real = 0;
    imaginary = 0;
    
    for n = 1 : length(bitstream)
        if bitstream(n) == 0
            element = -1;
        else
            element = 1;
        end

        if mod(n, 2) == 1
            real = element;
            if(n == length(bitstream))
                outstream(end+1) = real;
            end
        else
            imaginary = element * 1i;
            outstream(end+1) = real + imaginary;
        end
    end
end


%Function that demodulates
function outstream = demodulate_qpsk(bitstream)
    
    outstream = [];
    
    for n = 1 : length(bitstream)
        if real(bitstream(n)) > 0
            bit = 1;
        else
            bit = 0;
        end
        outstream(end+1) = bit;

        if imag(bitstream(n)) > 0
            bit = 1;
        else
            bit = 0;
        end
        outstream(end+1) = bit;

    end
end


%Function taht modulates the bitstream for qam
function outstream = modulate_qam(bitstream)
    
    outstream = [];
    imaginary_flag = 0;
    element = 0;
    element_0 = 0;
    element_1 = 0;
    real = 0;
    imaginary = 0;
    
    for n = 1 : length(bitstream)
        if mod(n, 2) == 1
            element_0 = bitstream(n);                       
        else
            element_1 = bitstream(n);
        end

        element_0 = num2str(element_0);
        element_1 = num2str(element_1);
        
        if mod(n, 2) == 0
        
            tuple = strcat(element_0,element_1);       
        
            if tuple == "00"
                element = -3;
            elseif tuple == "01"
                element = -1;
            elseif tuple == "11"
                element = 1;
            elseif tuple == "10"
                element = 3;        
            end

            if imaginary_flag == 0
                real = element;
                imaginary_flag = 1;
            else
                imaginary = element * 1i; 
                imaginary_flag = 0;
                outstream(end + 1) = real + imaginary;
            end
        end
    end
end

%Function that demodulates qam
function outstream = demodulate_qam(bitstream)
    
    outstream = [];
    
    for n = 1 : length(bitstream)
        if real(bitstream(n)) >= 1.5
            bits = [1 0];
        elseif real(bitstream(n)) >= 0 && real(bitstream(n)) < 1.5
            bits = [1 1];
        elseif real(bitstream(n)) >= -1.5 && real(bitstream(n)) < 0
            bits = [0 1];
        else
            bits = [0 0];
        end
        outstream = [outstream bits];

        if imag(bitstream(n)) >= 1.5
            bits = [1 0];
        elseif imag(bitstream(n)) >= 0 && imag(bitstream(n)) < 1.5
            bits = [1 1];
        elseif imag(bitstream(n)) >= -1.5 && imag(bitstream(n)) < 0
            bits = [0 1];
        else
            bits = [0 0];
        end
        outstream = [outstream bits];

    end
end

