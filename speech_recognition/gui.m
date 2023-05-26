function varargout = gui(varargin)
% GUI MATLAB code for gui.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI.M with the given input arguments.
%
%      GUI('Property','Value',...) creates a new GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui

% Last Modified by GUIDE v2.5 25-May-2023 23:23:58

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% --- Executes just before gui is made visible.
function gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui (see VARARGIN)

% Choose default command line output for gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.plotAxes);
cla;

% --------------------------------------------------------------------
function FileMenu_Callback(hObject, eventdata, handles)
% hObject    handle to FileMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function OpenMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to OpenMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
file = uigetfile('*.fig');
if ~isequal(file, 0)
    open(file);
end

% --------------------------------------------------------------------
function PrintMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to PrintMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
printdlg(handles.figure1)

% --------------------------------------------------------------------
function CloseMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to CloseMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selection = questdlg(['Close ' get(handles.figure1,'Name') '?'],...
                     ['Close ' get(handles.figure1,'Name') '...'],...
                     'Yes','No','Yes');
if strcmp(selection,'No')
    return;
end

delete(handles.figure1)


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
     set(hObject,'BackgroundColor','white');
end

set(hObject, 'String', {'plot(rand(5))', 'plot(sin(1:0.01:25))', 'bar(1:.5:10)', 'plot(membrane)', 'surf(peaks)'});



function wavFilename_Callback(hObject, eventdata, handles)
% hObject    handle to wavFilename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of wavFilename as text
%        str2double(get(hObject,'String')) returns contents of wavFilename as a double


% --- Executes during object creation, after setting all properties.
function wavFilename_CreateFcn(hObject, eventdata, handles)
% hObject    handle to wavFilename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in recordButton.
function recordButton_Callback(hObject, eventdata, handles)
% hObject    handle to recordButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global isRunning signal
global mfcc_win_len mfcc_shift_len n_mfcc n_mel template_num mfcc_templates pre_len frame_time frame_shift_time snr Fs start_len
if isRunning == 0
    isRunning = 1;
    try
        set(handles.regResult, 'String', '');
        Fs = 16000;
        nBits = 16;
        nChannel = 1;
        time = str2double(handles.timeEditText.String);
        if isnan(time) || time <= 0
            set(handles.logText, 'String', 'Invalid recording time');
            isRunning = 0;
            return
        elseif time > 10
            set(handles.logText, 'String', 'Too long recording time');
            isRunning = 0;
            return
        end
        set(handles.logText, 'String', 'Preparing for recording ...');
        recObj = audiorecorder(Fs, nBits, nChannel);
        pause(1);
        set(handles.logText, 'String', 'Start speaking ...');
        recordblocking(recObj, time);
        set(handles.logText, 'String', 'End of recording');
        signal = getaudiodata(recObj);
        signal = signal(start_len + 1: end);
        set(handles.logText, 'String', 'Waiting for recording ...');
        axes(handles.plotAxes);
        plot(signal);
        set(gca,'XTickLabel',[]); 
        set(gca,'YTickLabel',[]);

        noise = signal(1: pre_len);
        noise_power = sum(noise .^ 2) / length(noise);
        wav = signal(pre_len + 1: end);

        [recog_idx, start_time_num, end_time_num] = Recognize(wav, frame_time, frame_shift_time, Fs, noise_power, ...
                                            mfcc_win_len, mfcc_shift_len, n_mfcc, n_mel, mfcc_templates, snr);
        recog_idx = recog_idx - 1;
        axes(handles.plotAxes);
        for k = 1: 1: min(length(end_time_num), length(start_time_num))
            hold on
            scatter([start_time_num(k), end_time_num(k)] + pre_len, [wav(start_time_num(k)), wav(end_time_num(k))], "filled");
            hold off
        end
        recog_res = "";
        for i = recog_idx
            recog_res = strcat(recog_res, num2str(i));
        end
        set(handles.regResult, 'String', recog_res);
    catch
        set(handles.logText, 'String', 'Error when processing speech.');
    end
    isRunning = 0;
end


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over recordButton.
function recordButton_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to recordButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.

function plotAxes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plotAxes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate plotAxes
addpath("../functions");
global mfcc_win_len mfcc_shift_len n_mfcc n_mel template_num mfcc_templates pre_len frame_time frame_shift_time snr Fs start_len
mfcc_win_len = 320;
mfcc_shift_len = 160;
n_mfcc = 23;
n_mel = 30;
template_num = 5;
mfcc_templates = zeros(10, n_mfcc, template_num);
pre_len = round(0.2 * Fs);
frame_time = 20; % ms
frame_shift_time = 10; % ms
snr = 5;
Fs = 16000;
start_len = round(0.3 * Fs);
pre_len = round(0.5 * Fs);
rec_time = 2.5;
signals = zeros(10, round(rec_time * Fs) - start_len);
path = "E:\清华\大三春\语音信号处理\SpeechAnalysis\resource\";
for i = 0: 1: 9 
    [wav, Fs] = audioread(strcat(path, num2str(i), ".wav"));
    signals(i + 1, :) = wav(start_len + 1: end);
end
for i = 0: 1: 9
    noise = signals(i + 1, 1: pre_len);
    noise_power = sum(noise .^ 2) / length(noise);
    wav = signals(i + 1, pre_len + 1: end); 
    mfcc_templates(i + 1, :, :) = TrainMFCCTemplate(wav, frame_time, frame_shift_time, Fs, noise_power, ...
                                        mfcc_win_len, mfcc_shift_len, n_mfcc, n_mel, template_num, snr);
end


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over logText.
function logText_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to logText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%myRecording = getaudiodata(recObj);


% --- Executes during object creation, after setting all properties.
function recordButton_CreateFcn(hObject, eventdata, handles)
% hObject    handle to recordButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global isRunning
isRunning = 0;


% --- Executes on button press in readWavButton.
function readWavButton_Callback(hObject, eventdata, handles)
% hObject    handle to readWavButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global isRunning signal
global mfcc_win_len mfcc_shift_len n_mfcc n_mel template_num mfcc_templates pre_len frame_time frame_shift_time snr Fs start_len

if isRunning == 0
    isRunning = 1;
    try
        set(handles.regResult, 'String', '');
        [signal, Fs] = audioread(handles.wavFilename.String);
        signal = signal(start_len + 1: end);
        set(handles.logText, 'String', 'Succesfully read audio.');
        axes(handles.plotAxes);
        plot(signal);
        set(gca,'XTickLabel',[]); 
        set(gca,'YTickLabel',[]);
        noise = signal(1: pre_len);
        noise_power = sum(noise .^ 2) / length(noise);
        wav = signal(pre_len + 1: end);

        [recog_idx, start_time_num, end_time_num] = Recognize(wav, frame_time, frame_shift_time, Fs, noise_power, ...
                                            mfcc_win_len, mfcc_shift_len, n_mfcc, n_mel, mfcc_templates, snr);
        axes(handles.plotAxes);
        for k = 1: 1: min(length(end_time_num), length(start_time_num))
            hold on
            scatter([start_time_num(k), end_time_num(k)] + pre_len, [wav(start_time_num(k)), wav(end_time_num(k))], "filled");
            hold off
        end
        recog_idx = recog_idx - 1;
        recog_res = "";
        for i = recog_idx
            recog_res = strcat(recog_res, num2str(i));
        end
        set(handles.regResult, 'String', recog_res);
    catch
        set(handles.logText, 'String', 'Failed to read audio.');
    end
    isRunning = 0;
end


function timeEditText_Callback(hObject, eventdata, handles)
% hObject    handle to timeEditText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of timeEditText as text
%        str2double(get(hObject,'String')) returns contents of timeEditText as a double


% --- Executes during object creation, after setting all properties.
function timeEditText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to timeEditText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over readWavButton.
function readWavButton_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to readWavButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in togglebutton2.
function togglebutton2_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton2


% --- Executes on button press in logNote.
function logNote_Callback(hObject, eventdata, handles)
% hObject    handle to logNote (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of logNote


% --- Executes on button press in togglebutton4.
function togglebutton4_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton4
