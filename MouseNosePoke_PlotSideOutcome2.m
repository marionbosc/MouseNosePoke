function MouseNosePoke_PlotSideOutcome2(AxesHandles, Action, varargin)
global nTrialsToShow %this is for convenience
global BpodSystem
global TaskParameters

switch Action
    case 'init'
        %initialize pokes plot
        nTrialsToShow = 90; %default number of trials to display
        
        if nargin >= 3 %custom number of trials
            nTrialsToShow =varargin{1};
        end
%         axes(AxesHandle);
        axes(AxesHandles.HandleOutcome);
        %plot in specified axes
%         BpodSystem.GUIHandles.CurrentTrialCircle = line(-1,0.5, 'LineStyle','none','Marker','o','MarkerEdge','k','MarkerFace',[1 1 1], 'MarkerSize',6);
%         BpodSystem.GUIHandles.CurrentTrialCross = line(-1,0.5, 'LineStyle','none','Marker','+','MarkerEdge','k','MarkerFace',[1 1 1], 'MarkerSize',6);
%         BpodSystem.GUIHandles.RewardedL = line(-1,1, 'LineStyle','none','Marker','o','MarkerEdge','g','MarkerFace','g', 'MarkerSize',6);
%         BpodSystem.GUIHandles.RewardedR = line(-1,0, 'LineStyle','none','Marker','o','MarkerEdge','g','MarkerFace','g', 'MarkerSize',6);
%         BpodSystem.GUIHandles.EarlyWithdrawal = line(-1,0, 'LineStyle','none','Marker','d','MarkerEdge','none','MarkerFace','b', 'MarkerSize',6);
%         BpodSystem.GUIHandles.Jackpot = line(-1,0, 'LineStyle','none','Marker','x','MarkerEdge','r','MarkerFace','r', 'MarkerSize',7);
        BpodSystem.GUIHandles.OutcomePlot.CurrentTrialCircle = line(-1,0.5, 'LineStyle','none','Marker','o','MarkerEdge','k','MarkerFace',[1 1 1], 'MarkerSize',6);
        BpodSystem.GUIHandles.OutcomePlot.CurrentTrialCross = line(-1,0.5, 'LineStyle','none','Marker','+','MarkerEdge','k','MarkerFace',[1 1 1], 'MarkerSize',6);
        BpodSystem.GUIHandles.OutcomePlot.RewardedL = line(-1,1, 'LineStyle','none','Marker','o','MarkerEdge','g','MarkerFace','g', 'MarkerSize',6);
        BpodSystem.GUIHandles.OutcomePlot.RewardedR = line(-1,0, 'LineStyle','none','Marker','o','MarkerEdge','g','MarkerFace','g', 'MarkerSize',6);
        BpodSystem.GUIHandles.OutcomePlot.EarlyWithdrawal = line(-1,0, 'LineStyle','none','Marker','d','MarkerEdge','none','MarkerFace','b', 'MarkerSize',6);
        BpodSystem.GUIHandles.OutcomePlot.Jackpot = line(-1,0, 'LineStyle','none','Marker','x','MarkerEdge','r','MarkerFace','r', 'MarkerSize',7);
%         set(AxesHandle,'TickDir', 'out','YLim', [-1, 2],'XLim',[0,nTrialsToShow], 'YTick', [0 1],'YTickLabel', {'Right','Left'}, 'FontSize', 16);
%         xlabel(AxesHandle, 'Trial#', 'FontSize', 18);
%         hold(AxesHandle, 'on');
        set(AxesHandles.HandleOutcome,'TickDir', 'out','YLim', [-1, 2],'XLim',[0,nTrialsToShow], 'YTick', [0 1],'YTickLabel', {'Right','Left'}, 'FontSize', 16);
        xlabel(AxesHandles.HandleOutcome, 'Trial#', 'FontSize', 18);
        hold(AxesHandles.HandleOutcome, 'on');


        %% Trial rate
        hold(AxesHandles.HandleTrialRate,'on')
        BpodSystem.GUIHandles.OutcomePlot.TrialRate = line(AxesHandles.HandleTrialRate,[0],[0], 'LineStyle','-','Color','k','Visible','off'); %#ok<NBRAK>
        AxesHandles.HandleTrialRate.XLabel.String = 'Time (min)'; % FIGURE OUT UNIT
        AxesHandles.HandleTrialRate.YLabel.String = 'nTrials';
        AxesHandles.HandleTrialRate.Title.String = 'Trial rate';

        %% ST histogram
        hold(AxesHandles.HandleST,'on')
        AxesHandles.HandleST.XLabel.String = 'Time (ms)';
        AxesHandles.HandleST.YLabel.String = 'trial counts';
        AxesHandles.HandleST.Title.String = 'Stim sampling time';
        
    case 'update'
        
        CurrentTrial = varargin{1};
        ChoiceLeft = BpodSystem.Data.Custom.ChoiceLeft;
        
        % recompute xlim
%         [mn, ~] = rescaleX(AxesHandle,CurrentTrial,nTrialsToShow);
        [mn, ~] = rescaleX(AxesHandles.HandleOutcome,CurrentTrial,nTrialsToShow);
        
%         set(BpodSystem.GUIHandles.CurrentTrialCircle, 'xdata', CurrentTrial, 'ydata', .5);
%         set(BpodSystem.GUIHandles.CurrentTrialCross, 'xdata', CurrentTrial, 'ydata', .5);
        set(BpodSystem.GUIHandles.OutcomePlot.CurrentTrialCircle, 'xdata', CurrentTrial, 'ydata', .5);
        set(BpodSystem.GUIHandles.OutcomePlot.CurrentTrialCross, 'xdata', CurrentTrial, 'ydata', .5);
       
        %Plot past trials
        if ~isempty(ChoiceLeft)
            indxToPlot = mn:CurrentTrial-1;
            %Plot Rewarded Left
            ndxRwdL = ChoiceLeft(indxToPlot) == 1;
            Xdata = indxToPlot(ndxRwdL); Ydata = ones(1,sum(ndxRwdL));
%             set(BpodSystem.GUIHandles.RewardedL, 'xdata', Xdata, 'ydata', Ydata);
            set(BpodSystem.GUIHandles.OutcomePlot.RewardedL, 'xdata', Xdata, 'ydata', Ydata);
            %Plot Rewarded Right
            ndxRwdR = ChoiceLeft(indxToPlot) == 0;
            Xdata = indxToPlot(ndxRwdR); Ydata = zeros(1,sum(ndxRwdR));
%             set(BpodSystem.GUIHandles.RewardedR, 'xdata', Xdata, 'ydata', Ydata);
            set(BpodSystem.GUIHandles.OutcomePlot.RewardedR, 'xdata', Xdata, 'ydata', Ydata);
        end
        if ~isempty(BpodSystem.Data.Custom.EarlyWithdrawal)
            indxToPlot = mn:CurrentTrial-1;
            ndxEarly = BpodSystem.Data.Custom.EarlyWithdrawal(indxToPlot);
            XData = indxToPlot(ndxEarly);
            YData = 0.5*ones(1,sum(ndxEarly));
%             set(BpodSystem.GUIHandles.EarlyWithdrawal, 'xdata', XData, 'ydata', YData);
            set(BpodSystem.GUIHandles.OutcomePlot.EarlyWithdrawal, 'xdata', XData, 'ydata', YData);
        end
        if ~isempty(BpodSystem.Data.Custom.Jackpot)
            indxToPlot = mn:CurrentTrial-1;
            ndxJackpot = BpodSystem.Data.Custom.Jackpot(indxToPlot);
            XData = indxToPlot(ndxJackpot);
            YData = 0.5*ones(1,sum(ndxJackpot));
%             set(BpodSystem.GUIHandles.Jackpot, 'xdata', XData, 'ydata', YData);
            set(BpodSystem.GUIHandles.OutcomePlot.Jackpot, 'xdata', XData, 'ydata', YData);
        end
        
        % Trial rate
        BpodSystem.GUIHandles.OutcomePlot.TrialRate.XData = (BpodSystem.Data.TrialStartTimestamp-min(BpodSystem.Data.TrialStartTimestamp))/60;
        BpodSystem.GUIHandles.OutcomePlot.TrialRate.YData = 1:numel(BpodSystem.Data.Custom.ChoiceLeft);
        
        % SamplingTime
        cla(AxesHandles.HandleST)
        BpodSystem.GUIHandles.OutcomePlot.HistSTEarly = histogram(AxesHandles.HandleST,BpodSystem.Data.Custom.ST(BpodSystem.Data.Custom.EarlyWithdrawal)*1000);
        BpodSystem.GUIHandles.OutcomePlot.HistSTEarly.BinWidth = 50;
        BpodSystem.GUIHandles.OutcomePlot.HistSTEarly.FaceColor = 'r';
        BpodSystem.GUIHandles.OutcomePlot.HistSTEarly.EdgeColor = 'none';
        BpodSystem.GUIHandles.OutcomePlot.HistST = histogram(AxesHandles.HandleST,BpodSystem.Data.Custom.ST(~BpodSystem.Data.Custom.EarlyWithdrawal)*1000);
        BpodSystem.GUIHandles.OutcomePlot.HistST.BinWidth = 50;
        BpodSystem.GUIHandles.OutcomePlot.HistST.FaceColor = 'b';
        BpodSystem.GUIHandles.OutcomePlot.HistST.EdgeColor = 'none';
        EarlyP = sum(BpodSystem.Data.Custom.EarlyWithdrawal)/sum(~BpodSystem.Data.Custom.FixBroke);
        cornertext(AxesHandles.HandleST,sprintf('P=%1.2f',EarlyP))

end

end

function [mn,mx] = rescaleX(AxesHandle,CurrentTrial,nTrialsToShow)
FractionWindowStickpoint = .75; % After this fraction of visible trials, the trial position in the window "sticks" and the window begins to slide through trials.
mn = max(round(CurrentTrial - FractionWindowStickpoint*nTrialsToShow),1);
mx = mn + nTrialsToShow - 1;
set(AxesHandle,'XLim',[mn-1 mx+1]);
end

function cornertext(h,str)
unit = get(h,'Units');
set(h,'Units','char');
pos = get(h,'Position');
if ~iscell(str)
    str = {str};
end
for i = 1:length(str)
    x = pos(1)+1;y = pos(2)+pos(4)-i;
    uicontrol(h.Parent,'Units','char','Position',[x,y,length(str{i})+1,1],'string',str{i},'style','text','background',[1,1,1],'FontSize',8);
end
set(h,'Units',unit);
end

