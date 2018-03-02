function [out, cloud, cloud_toplot] = GenerateToneCloudDual(pHigh, StimSettings)
%{ 
GENERATETONECLOUD: Generates Cloud of tones

This function is based on MakeToneCloud (written by P.Z.) which can be found in SoundSection.m
Not all features have been imported to this version. 

%}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%r is as defined by PZ (0 to 1), 0 meaning that the probability of target and non target freq is the same
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global BpodSystem

nTones = StimSettings.nTones;
ToneOverlap = StimSettings.ToneOverlap;
ToneDuration = StimSettings.ToneDuration;
minFreq = StimSettings.minFreq;
maxFreq = StimSettings.maxFreq;
SamplingRate = StimSettings.SamplingRate;
nTones_noEvidence = StimSettings.Noevidence;
Volume = StimSettings.Volume;
 
nFreq = StimSettings.nFreq; % Number of different frequencies to sample from
toneFreq = logspace(log10(minFreq),log10(maxFreq),nFreq); % Nfreq logly distributed
SoundCal = BpodSystem.CalibrationTables.SoundCal;

if(isempty(SoundCal))
    disp('Error: no sound calibration file specified');
    return
end

%My sound file is for single speaker.
%I need a double speaker program.
% SoundCal(1,2).Table = SoundCal(1,1).Table;
% SoundCal(1,2).CalibrationTargetRange = SoundCal(1,1).CalibrationTargetRange;
% SoundCal(1,2).TargetSPL = SoundCal(1,1).TargetSPL;
% SoundCal(1,2).LastDateModified = SoundCal(1,1).LastDateModified;
% SoundCal(1,2).Coefficient = SoundCal(1,1).Coefficient;
% SoundCal(1,2).Frequencies = SoundCal(1,1).Frequencies;
% SoundCal(1,2).Attenuations = SoundCal(1,1).Attenuations;
% SoundCal(1,2).MinBandLimit = SoundCal(1,1).MinBandLimit;
% SoundCal(1,2).MaxBandLimit = SoundCal(1,1).MaxBandLimit;
% SoundCal(1,2).FsOut = SoundCal(1,1).FsOut;
% 
if size(SoundCal,2)<2
    SoundCal(1,2)=SoundCal(1,1);
end
toneAtt = [polyval(SoundCal(1,1).Coefficient,toneFreq)' polyval(SoundCal(1,2).Coefficient,toneFreq)'];
diffSPL = Volume - [SoundCal(1,1).TargetSPL SoundCal(1,2).TargetSPL];
attFactor = sqrt(10.^(diffSPL./10));
att = toneAtt.*repmat(attFactor,nFreq,1);


nTones_Evidence = nTones - nTones_noEvidence; % Number of tones with controlled evidence
ramp = StimSettings.ramp; % Fraction of tone duration that is used for the envelope

% seed = 1;
% if ~isnan(seed) 
%     rand('twister',seed);
% end
        
noEvidence_ind = randi(nFreq,1,nTones_noEvidence); % Frequency indices of no evidence tones

    
%boundy = [nFreq/3 2/3*nFreq]; % debugging purposes


        Evidence_ind = randi(nFreq/3,1,nTones_Evidence); % Fill everything with low
        
        %this gives exactly the number of tones according to the pTarget
        %nTarget = round(nTones_Evidence*pTarget); % Number of tones with target frequencies
        %ind_replace = randperm(nTones_Evidence); % Indices to replace with target frequencies
        %Evidence_ind(ind_replace(1:nTarget))=randi(nFreq/3,1,nTarget)+2/3*nFreq; % Replace with target freqs (high)
        
        %this draws a independent random numbers for each slot
        %note that the amount of slots with target freq will vary from
        %trial to trial, even when the same pTarget
        ind_replace = find(rand(1,nTones_Evidence)<pHigh);
        nTarget = size(ind_replace,2); % Number of tones with target frequencies
        Evidence_ind(ind_replace)=randi(nFreq/3,1,nTarget)+2/3*nFreq; % Replace with target freqs (high)


cloud = [noEvidence_ind Evidence_ind]; % Complete stream of tones
freqs = toneFreq(cloud); % Frequencies
Amps = att(cloud,:); % Tone amplitudes
toneVec = 1/SamplingRate:1/SamplingRate:ToneDuration; % Here go the tones

omega=(acos(sqrt(0.1))-acos(sqrt(0.9)))/ramp; % This is for the envelope
t=0 : (1/SamplingRate) : pi/2/omega;
t=t(1:(end-1));
RaiseVec= (cos(omega*t)).^2;

Envelope = ones(length(toneVec),1); % This is the envelope
Envelope(1:length(RaiseVec)) = fliplr(RaiseVec);
Envelope(end-length(RaiseVec)+1:end) = (RaiseVec);
Envelope = repmat(Envelope,1,length(freqs));

tones = (sin(toneVec'*freqs*2*pi)).*Envelope; % Here are the enveloped tones as a matrix
% size(tones)
% figure
% plot(tones(:,1))
% hoge
% Create the stream

out = zeros(1,round(length(freqs)*length(toneVec)-(length(freqs)-1)*ToneOverlap*length(toneVec)));
%two channels:
% out = zeros(2, round(length(freqs)*length(toneVec)-(length(freqs)-1)*ToneOverlap*length(toneVec)));

cloud_toplot = nan(nFreq,round(length(freqs)*length(toneVec)-(length(freqs)-1)*ToneOverlap*length(toneVec)));
for ind = 1:length(cloud)
    tonePos = round((ind-1)*length(toneVec)*(1-ToneOverlap))+1:round((ind-1)*(1-ToneOverlap)*length(toneVec))+length(toneVec);

    out(1,tonePos) = out(1,tonePos) + tones(:,ind)'*Amps(ind,1)';
    
    %uncomment for using two channels
    %out(2,tonePos) = out(2,tonePos) + tones(:,ind)'*Amps(ind,2)';
    %two channels:
    
    cloud_toplot(cloud(ind),tonePos) = cloud(1,ind); 
end



