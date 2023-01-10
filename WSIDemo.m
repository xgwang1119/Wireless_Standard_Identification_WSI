% 10.Jan.20230 @BJ
% This code only tells how to generate the waveform
% Reference:
% X. Wang, F. Wang, B. He and Y. Shan, "Wireless Standard Identification via Mel  Frequency Cepstrum,"
% in IEEE Communications Letters, vol. 26,  no. 11, pp. 2656-2660, Nov. 2022
% https://ww2.mathworks.cn/help/wlan/gs/waveform-generation.html

%% Configuration
nonHTcfg = wlanNonHTConfig;         
nonHTcfg.NumTransmitAntennas = 1;
nonHTcfg.ChannelBandwidth='CBW20';
if isa(nonHTcfg,'wlanNonHTConfig')||isa(nonHTcfg,'wlanHTConfig')
    nonHTcfg.PSDULength = 200;      % Add PSDULength in non-HT format
end
psdu = randi([0 1],1000,1);
numPkts = 10;
Waveform= wlanWaveformGenerator(psdu,nonHTcfg,'NumPackets', numPkts,'WindowTransitionTime',0);

% RF up-conversion, carrier frequency estimation and baseband processing are omitted here.

fs1 = 20e6;
fs2 = 80e6;
BandEsti = 20e6;

%% Resampling
WaveformUp=resample(Waveform,fs2,fs1);
WaveformBase=resample(WaveformUp,BandEsti*2,fs2);

% Calculate MFCC here

%%  PSD
specAn = dsp.SpectrumAnalyzer('SpectrumType','Power density');
specAn.SampleRate =20e6;
specAn.Name = ' Signal Spectrum ';
specAn.YLabel='PSD';
specAn.ReducePlotRate = false;
specAn.PlotMaxHoldTrace = false;
specAn.ShowGrid = true;
specAn.ShowLegend = true;
specAn.ChannelNames = {'WLAN Signal'};
rx=WaveformBase(:);
step(specAn, rx);
% release(specAn);
