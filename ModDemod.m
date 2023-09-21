% Eb/No in dB
EbNo = 2:2:14;
% Maximum number of bit errors simulated at each Eb/No point
maxNumErrs = 100;
% Maximum number of bits accumulated at each Eb/No point
maxNumBits = 1e6;
% Maximum number of packets considered at each Eb/No point
maxNumPkts = 1000;
phyMode = 'BR'; % PHY transmission mode
bluetoothPacket = 'FHS'; % Type of Bluetooth packet, this value can be: {'ID',
% 'NULL','POLL','FHS','HV1','HV2','HV3','DV','EV3',
% 'EV4','EV5','AUX1','DM3','DM1','DH1','DM5','DH3',
% 'DH5','2-DH1','2-DH3','2-DH5','2-DH1','2-DH3',
% '2-DH5','2-EV3','2-EV5','3-EV3','3-EV5'}
sps = 8; % Samples per symbol, must be greater than 1
frequencyOffset = 6000;% In Hz
timingOffset = 0.5; % In samples, less than 1 microsecond
timingDrift = 2; % In parts per million
dcOffset = 2; % Percentage w.r.t maximum amplitude value
symbolRate = 1e6; % Symbol Rate
% Create timing offset object
timingDelayObj = dsp.VariableFractionalDelay;
% Create frequency offset object
frequencyDelay = comm.PhaseFrequencyOffset('SampleRate',symbolRate*sps);
ber = zeros(1,length(EbNo)); % BER results
per = zeros(1,length(EbNo)); % PER results
bitsPerByte = 8; % Number of bits per byte
% Set code rate based on packet
if any(strcmp(bluetoothPacket,{'FHS','DM1','DM3','DM5','HV2','DV','EV4'}))
codeRate = 2/3;
elseif strcmp(bluetoothPacket,'HV1')
codeRate = 1/3;
else
codeRate = 1;
end
% Set number of bits per symbol based on the PHY transmission mode
bitsPerSymbol = 1+ (strcmp(phyMode,'EDR2M'))*1 +(strcmp(phyMode,'EDR3M'))*2;
% Get SNR from EbNo values
snr = EbNo + 10*log10(codeRate) + 10*log10(bitsPerSymbol) - 10*log10(sps);
% Create a Bluetooth BR/EDR waveform configuration object
txCfg = bluetoothWaveformConfig('Mode',phyMode,'PacketType',bluetoothPacket,...
'SamplesPerSymbol',sps);
if strcmp(bluetoothPacket,'DM1')
txCfg.PayloadLength = 17; % Maximum length of DM1 packets in bytes
end
dataLen = getPayloadLength(txCfg); % Length of the payload
% Get PHY properties
rxCfg = getPhyConfigProperties(txCfg);
for iSnr = 1:length(snr)
rng default
% Initialize error computation parameters
errorCalc = comm.ErrorRate;
berVec = zeros(3,1);
pktCount = 0; % Counter for number of detected Bluetooth packets
loopCount = 0; % Counter for number of packets at each SNR value
pktErr = 0;
while((berVec(2) < maxNumErrs) && (berVec(3) < maxNumBits) && (loopCount < maxNumPkts))
txBits = randi([0 1],dataLen*bitsPerByte,1); % Data bits generation
txWaveform = bluetoothWaveformGenerator(txBits,txCfg);
% Add Frequency Offset
frequencyDelay.FrequencyOffset = frequencyOffset;
transWaveformCFO = frequencyDelay(txWaveform);
% Add Timing Delay
timingDriftRate = (timingDrift*1e-6)/(length(txWaveform)*sps);% Timing drift rate
timingDriftVal = timingDriftRate*(0:1:(length(txWaveform)-1))';% Timing drift
timingDelay = (timingOffset*sps)+timingDriftVal; % Static timing offset and timing drift
transWaveformTimingCFO = timingDelayObj(transWaveformCFO,timingDelay);
% Add DC Offset
dcValue = (dcOffset/100)*max(transWaveformTimingCFO);
txImpairedWaveform = transWaveformTimingCFO + dcValue;
% Add AWGN
txNoisyWaveform = awgn(txImpairedWaveform,snr(iSnr),'measured');
% Receiver Module
[rxBits,decodedInfo,pktStatus]...
= helperBluetoothPracticalReceiver(txNoisyWaveform,rxCfg);
numOfSignals = length(pktStatus);
pktCount = pktCount+numOfSignals;
loopCount = loopCount+1;
% BER and PER Calculations
L1 = length(txBits);
L2 = length(rxBits);
L = min(L1,L2);
if(~isempty(L))
berVec = errorCalc(txBits(1:L),rxBits(1:L));
end
pktErr = pktErr+sum(~pktStatus);
end
% Average of BER and PER
per(iSnr) = pktErr/pktCount;
ber(iSnr) = berVec(1);
if ((ber(iSnr) == 0) && (per(iSnr) == 1))
ber(iSnr) = 0.5; % If packet error rate is 1, consider average BER of 0.5
end
if ~any(strcmp(bluetoothPacket,{'ID','NULL','POLL'}))
disp(['Mode ' phyMode ', '...
'Simulated for Eb/No = ', num2str(EbNo(iSnr)), ' dB' ', '...
'obtained BER:',num2str(ber(iSnr)),' obtained PER: ',...
num2str(per(iSnr))]);
else
disp(['Mode ' phyMode ', '...
'Simulated for Eb/No = ', num2str(EbNo(iSnr)), ' dB' ', '...
'obtained PER: ',num2str(per(iSnr))]);
end
end
figure,
if any(strcmp(bluetoothPacket,{'ID','NULL','POLL'}))
numOfPlots = 1; % Plot only PER
else
numOfPlots = 2; % Plot both BER and PER
subplot(numOfPlots,1,1),semilogy(EbNo,ber.','-r*');
xlabel('Eb/No (dB)');
ylabel('BER');
legend(phyMode);
title('BER of Bluetooth with RF impairments');
hold on;
grid on;
end
subplot(numOfPlots,1,numOfPlots),semilogy(EbNo,per.','-k*');
xlabel('Eb/No (dB)');
ylabel('PER');
legend(phyMode);
title('PER of Bluetooth with RF impairments');
hold on;
grid on;
