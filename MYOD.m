function varargout = MYOD(varargin)
% MYOD M-file for MYOD.fig
%      MYOD, by itself, creates a new MYOD or raises the existing
%      singleton*.
%
%      H = MYOD returns the handle to a new MYOD or the handle to
%      the existing singleton*.
%
%      MYOD('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MYOD.M with the given input arguments.
%
%      MYOD('Property','Value',...) creates a new MYOD or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MYOD_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MYOD_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MYOD

% Last Modified by GUIDE v2.5 03-Feb-2013 19:57:23

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MYOD_OpeningFcn, ...
                   'gui_OutputFcn',  @MYOD_OutputFcn, ...
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

% function: MYOD_OpeningFcn
% last modified: 20/10/12
% description: Executes just before MYOD is made visible
% inputs: hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MYOD (see VARARGIN)
function MYOD_OpeningFcn(hObject, eventdata, handles, varargin)

% Choose default command line output for MYOD
handles.output = hObject;

% update scheduled payments if need be
reschedule();

% display summary
summarise(handles);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes MYOD wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = MYOD_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% function: add_entry_Callback
% last modified: 20/10/12
% description: executes on button press in add_entry
% inputs: hObject - handle to add_entry (see GCBO)
%         eventdata - to be defined in a future version of MATLAB
%         handles - structure with handles and user data (see GUIDATA)
% NOTE: modifies handles
function add_entry_Callback(hObject, eventdata, handles)

% check if handle to add_data gui already exists and still active
if isfield(handles,'add_data_open') && ishandle(handles.add_data_open) 
    figure(handles.add_data_open); %make it the active window
else
    handles.add_data_open = add_data('UserData',hObject);
end

guidata(hObject, handles); % update handles


% function: trans_hist_Callback
% last modified: 20/10/12
% description: Executes on button press in trans_hist
% inputs: hObject - handle to trans_hist (see GCBO)
%         eventdata - to be defined in a future version of MATLAB
%         handles - structure with handles and user data (see GUIDATA)
% NOTE: modifies handles
function trans_hist_Callback(hObject, eventdata, handles)

% check if handle to trans_hist gui already exists and still active
if isfield(handles,'trans_hist_open') && ishandle(handles.trans_hist_open) 
    figure(handles.trans_hist_open); %make it the active window
else
    handles.trans_hist_open = trans_hist('UserData',hObject);
end

guidata(hObject, handles); % update handles


% function: about_Callback
% last modified: 03/02/13
% description: Executes on button press in about
% inputs: hObject - handle to about (see GCBO)
%         eventdata - to be defined in a future version of MATLAB
%         handles - structure with handles and user data (see GUIDATA)
% NOTE: modifies handles
function about_Callback(hObject, eventdata, handles)

% check if handle to about msgbox already exists and still active
if isfield(handles,'about_open') && ishandle(handles.about_open) 
    figure(handles.about_open); %make it the active window
else
    about_msg = sprintf(['MYOD - Mind Your Own Dollars\n'...
        'Author: Peter Aquilina\n'...
        'Version 1.1.0\n'...
        'Developed: Sept 2012 - Feb 2013']);
    handles.about_open = msgbox(about_msg,'About');
end

guidata(hObject, handles); % update handles


% function: figure1_CloseRequestFcn
% last modified: 18/01/13
% description: code executes when MYOD is closed
% inputs: hObject - handle to figure1 (see GCBO)
%         eventdata - to be defined in a future version of MATLAB
%         handles - structure with handles and user data (see GUIDATA)
% NOTE: Please note that figure1_CloseRequestFcn is not general as 
%       behaviour is unique to my requirements
% NOTE: figure1_CloseRequestFcn has a dependency on git being installed on the machine
%       and in the path.
function figure1_CloseRequestFcn(hObject, eventdata, handles)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   WARNING CODE IN HERE IS NOT GENERAL AND INTENDED FOR MY PC ONLY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
curr_dir = pwd();
if strcmp(curr_dir,data_num('rel_path'))
    use_git = true; % boolean true if automatically update stuff in git
else
    use_git = false;
end

if use_git
    set(handles.summary,'string',...
        sprintf('PLEASE WAIT!\nMYOD data being uploaded to web'));
    %for the silencing of system commands
    if ispc
        oblivion = 'NUL';
    else
        oblivion = '/dev/null';
    end
    data_path = fullfile(data_num('rel_path'),data_num('path'));
    r = cd(data_path);
    system(['git push origin master > ' oblivion]);
    cd(r);
end
% closes the figure
delete(hObject);




















