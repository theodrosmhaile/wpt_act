%This replicates the 3-back task wrriten by xyz

%Set up task
%Set up stimuli lists
NumList1 = round(rand(1,10)*10);

%Assign session type: list 1 or list 2
ThisList = NumList1;
%Save data


%Figure response inputs: report matches as well as non-matches: get actual
% keys
ListenChar(2); % prevent keys from writing to matlab
KbName('UnifyKeyNames');
SpaceKey = KbName('space'); %Advances between blocks, instructions etc
RShift = KbName('rightshift');
LShift = KbName('leftshift');
ESCKey = KbName('escape');
Match = KbName ('r');%Match Report
NonMatch  = KbName ('s');%Non-match report

%-resp_distribution(LShift)= 1; %Sun report
%-resp_distribution(RShift)= 0; %Rain Report

%Set up experiment window
Screen('Preference', 'SkipSyncTests',1);
%Screen('Preference', 'VisualDebugLevel', 3);
Screen('Preference', 'SuppressAllWarnings', 1);
Screen('Preference','TextRenderer', 1)
%Screen Size for debug
screenRect = [0,0,1200,700];

%Select screen
use_screen = max(Screen('screens'));
[window, rect] = Screen('OpenWindow', 0, use_screen,screenRect);% screenRect
%may not be necessary
wht = [255 255 255];
blk = [0 0 0];
Screen('FillRect',window,blk);
Screen('Flip',window);

%initial instructions
instruct_1 = 'These are your instructions. Press SPACE';
Screen('TextFont', window, 'Arial');
Screen('TextSize', window, 18);
DrawFormattedText( window,instruct_1,'center','center',[255 255 255],300);
Screen('Flip',window);

while KbCheck; end
while 1
    [ kk, ss, keyCode ] = KbCheck(max(GetKeyboardIndices));
    
    if kk
        if find(keyCode) == SpaceKey
            
            %DrawFormattedText( window,'SPACE SPACE','center','center',[255 255 255],300);
            Screen('Flip',window);
            %WaitSecs(.5)
            break
        end
        
        if find(keyCode) == ESCKey
            ListenChar(0); %Re-enable key access to matlab
            Screen('Flip',window);
            ShowCursor
            sca
             
            %Add an exit data save here
        end
    end
end
trials = 1;

WaitSecs(2);

NumPresentTime = [];
Screen('TextSize', window, 32);
%
Record.startTime = GetSecs;
while trials ~= length(NumList1) + 1
    
    %WaitSecs(.5);
    % KbWait;
    
    %Present numbers from list
  
    DrawFormattedText( window,num2str(ThisList(trials)),'center','center',[255 255 255],300);
      [ keyIsDown, seconds, keyCode ] = KbCheck(max(GetKeyboardIndices));
    %Get time stamp for presentation
    NumPresentTime = [NumPresentTime,GetSecs];
    Screen('Flip',window);
    
    
   %Display number for only one second
   
targDuration = 1
while (GetSecs - NumPresentTime) < (targDuration)
[keyIsDown,secs,keyCode] = KbCheck(max(GetKeyboardIndices));
    if keyIsDown
        keynum(trials) = find(keyCode);
        rt(trials) = secs - onsetTime;
        Screen('Flip',window);
    end
end
    %WaitSecs(1);
    
    %Flip screen to remove number after one second
    Screen('Flip',window);
    WaitSecs(3.5);
   % Record.RespTimeTEST(trials) = secs;
    %Record pressed key time
   if keyIsDown
    Record.RespTime(trials) = seconds;
    Record.Respkey(trials) = find(keyCode);
    Record.RespkeyName{trials}  = KbName(find(keyCode));
   else
    Record.RespTime(trials) = -1;
    Record.Respkey(trials)  = -1;
    Record.RespkeyName{trials} = 'missed';
   end
        if find(keyCode) == ESCKey
            sca
            ListenChar(0);
            break
            
        end
    %end
    
    %If statement for block with continue instead of break
    
    if trials == length(NumList1)+ 1
        Screen('DrawText',window,'You"re all done! Thank you for playing' ,50,350);
        Screen('Flip',window);
        WaitSecs(1);
        break
    end
    trials = trials+1;
    % WaitSecs(1);sca;

end

ShowCursor
ListenChar(0); %Re-enable key access to matlab
Screen('CloseAll');

































