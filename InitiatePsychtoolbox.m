function InitiatePsychtoolbox()
global BpodSystem
global TaskParameters
if TaskParameters.GUI.PlayStimulus==3 && ~BpodSystem.Data.Custom.PsychtoolboxStartup
    PsychToolboxSoundServer('init');
    BpodSystem.Data.Custom.PsychtoolboxStartup=true;
end