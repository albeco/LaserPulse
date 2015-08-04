function varargout = chirped_pulse_demo(varargin)
% CHIRPED_PULSE_DEMO visualize effect of chirp on a femtosecond pulse

% Edit the above text to modify the response to help chirped_pulse_demo

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @chirped_pulse_demo_OpeningFcn, ...
                   'gui_OutputFcn',  @chirped_pulse_demo_OutputFcn, ...
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


% --- Executes just before chirped_pulse_demo is made visible.
function chirped_pulse_demo_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to chirped_pulse_demo (see VARARGIN)

% Choose default command line output for chirped_pulse_demo
handles.output = hObject;

defaultWavelength = 800; % nm
defaultPulseDuration = 10; % fs

handles.nPoints = 2^12;

handles.centralWavelength = defaultWavelength;
set(handles.edit_centralWavelength,'String', num2str(defaultWavelength));
handles.initialPulseDuration = defaultPulseDuration;
set(handles.edit_initialPulseDuration,'String', num2str(defaultPulseDuration));

% set spectral phase to zero
handles.GDD = 0;
set(handles.edit_GDD,'String', '0');
handles.TOD = 0;
set(handles.edit_TOD,'String', '0');
handles.FOD = 0;
set(handles.edit_FOD,'String', '0');

% Update handles structure
guidata(hObject, handles);
% initialize laser pulse
updatePulse(hObject, [], handles);

% UIWAIT makes chirped_pulse_demo wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = chirped_pulse_demo_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function edit_GDD_Callback(hObject, eventdata, handles)
% hObject    handle to edit_GDD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.GDD = str2double(get(hObject,'String'));
% Update handles structure
guidata(hObject, handles);
updatePhase(hObject, [], handles)
updateGraph(hObject, [], handles)

% --- Executes during object creation, after setting all properties.
function edit_GDD_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_GDD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_TOD_Callback(hObject, eventdata, handles)
% hObject    handle to edit_TOD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.TOD = str2double(get(hObject,'String'));
% Update handles structure
guidata(hObject, handles);
updatePhase(hObject, [], handles)
updateGraph(hObject, [], handles)

% --- Executes during object creation, after setting all properties.
function edit_TOD_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_TOD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_FOD_Callback(hObject, eventdata, handles)
% hObject    handle to edit_FOD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.FOD = str2double(get(hObject,'String'));
% Update handles structure
guidata(hObject, handles);
updatePhase(hObject, [], handles)
updateGraph(hObject, [], handles)

% --- Executes during object creation, after setting all properties.
function edit_FOD_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_FOD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_centralWavelength_Callback(hObject, eventdata, handles)
% hObject    handle to edit_centralWavelength (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.centralWavelength =  str2double(get(hObject,'String'));
% Update handles structure
guidata(hObject, handles);
% update laser pulse
updatePulse(hObject, [], handles)


% --- Executes during object creation, after setting all properties.
function edit_centralWavelength_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_centralWavelength (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'),...
    get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_initialPulseDuration_Callback(hObject, eventdata, handles)
% hObject    handle to edit_initialPulseDuration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


handles.initialPulseDuration = str2double(get(hObject,'String'));
% Update handles structure
guidata(hObject, handles);
updatePulse(hObject, [], handles)

% --- Executes during object creation, after setting all properties.
function edit_initialPulseDuration_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_initialPulseDuration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function updatePulse(hObject, ~, handles)
% initialize flat-phase pulse
pulse = gaussianPulse(...
  'units', 'fs', ...
  'f0', 300/handles.centralWavelength, ...
  'fwhm', handles.initialPulseDuration, ...
  'nPoints', handles.nPoints);
handles.pulse = pulse;
% Update handles structure
guidata(hObject, handles);
% set polynomial phas
updatePhase(hObject, [], handles)
updateGraph(hObject, [], handles)

function updatePhase(hObject, ~, handles)
handles.pulse.polynomialPhase([handles.FOD, handles.TOD, handles.GDD, 0, 0]);
guidata(hObject, handles);

function updateGraph(hObject, ~, handles)
p = handles.pulse;
axes(handles.axes_timeDomain)
plot(p.timeArray, real(p.temporalField));
xlabel(sprintf('time (%s)',p.timeUnits));
ylabel('E(t)');
xlim([-4,4]*p.duration);
ylim([-1, 1])

axes(handles.axes_frequencyDomain)
plot(p.frequencyArray, real(p.spectralField));
xlabel(sprintf('frequency (%s)',p.frequencyUnits));
ylabel('E(f)');
xlim([-4,4]*p.bandwidth+p.centralFrequency);
