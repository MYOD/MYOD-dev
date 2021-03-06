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

% Last Modified by GUIDE v2.5 27-Dec-2013 22:52:50

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

% include wedding summary
wedding(handles);

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

% function: wedding
% last modified: 27/12/13
% description: shows the number of days since a last major argument
%              and the % to making a wedding date
% inputs: handles - structure with handles and user data (see GUIDATA)
function wedding(handles)

last_arg = load_data('last_arg'); %last day with an argument dd/mm/yy 

if size(last_arg,1) == 0 %no last_arg available
    last_arg = datestr(today,'dd/mm/yy');
    warndlg('no argument date found', 'No argument data');
end
%convert date to number
n_gday = datenum(last_arg,'dd/mm/yy'); % first day as a number
n_today = datenum(date); %todays date as a number
days = n_today - n_gday; %number of days argument free!

txt = sprintf(['No bad argument for %d days.\n'...
    'Never Give Up!!'],days);

set(handles.wedding_msg,'String',txt);



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
% last modified: 16/02/13
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
        'Version 1.2.0\n'...
        'Developed: Sept 2012 - Aug 2013']);
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

selection = questdlg('Do you want to upload a copy of your data?',...
    'Upload Data?',...
    'Yes','No','Cancel','Yes');
switch selection,
    case 'Yes',
        
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
        else
            errordlg('Sorry use_git is false. Please tell Peter.');
        end
        
    case 'Cancel'
        %don't even quit
        return
end

% closes the figure
delete(hObject);



% function: spending_Callback
% last modified: 17/08/13
% description: Executes on button press in spending
% inputs: hObject - handle to about (see GCBO)
%         eventdata - to be defined in a future version of MATLAB
%         handles - structure with handles and user data (see GUIDATA)
% NOTE: modifies handles
function spending_Callback(hObject, eventdata, handles)
% hObject    handle to spending (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% check if handle to speding already exists and still active
if isfield(handles,'spending_open') && ishandle(handles.spending_open) 
    figure(handles.spending_open); %make it the active window
else
    handles.spending_open = spending;
end

guidata(hObject, handles); % update handles



% function: reset_Callback
% last modified: 27/12/13
% description: updates the date of last argument to be today
% inputs: hObject - handle to reset (see GCBO)
%         eventdata - to be defined in a future version of MATLAB
%         handles - structure with handles and user data (see GUIDATA)
function reset_Callback(hObject, eventdata, handles)

save_data(datestr(today,'dd/mm/yy'),'last_arg'); %today is most recent argument
wedding(handles); %reset display

