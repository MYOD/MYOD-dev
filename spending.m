function varargout = spending(varargin)
% SPENDING MATLAB code for spending.fig
%      SPENDING, by itself, creates a new SPENDING or raises the existing
%      singleton*.
%
%      H = SPENDING returns the handle to a new SPENDING or the handle to
%      the existing singleton*.
%
%      SPENDING('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SPENDING.M with the given input arguments.
%
%      SPENDING('Property','Value',...) creates a new SPENDING or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before spending_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to spending_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help spending

% Last Modified by GUIDE v2.5 17-Aug-2013 23:11:51

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @spending_OpeningFcn, ...
                   'gui_OutputFcn',  @spending_OutputFcn, ...
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


% function: spending_OpeningFcn
% last modified: 17/08/13
% description: Executes just before spending is made visible
% inputs: hObject - handle to figure
%         eventdata - to be defined in a future version of MATLAB
%         handles - structure with handles and user data (see GUIDATA)
%         varargin - command line arguments to add_data (see VARARGIN)
% NOTE: This function has no output args, see OutputFcn.
function spending_OpeningFcn(hObject, eventdata, handles, varargin)

% Choose default command line output for spending
handles.output = hObject;

%initialise main_cat
set(handles.main_cat,'value',1)
set(handles.main_cat,'string',get_main_cat('list',0));

% initialise sub_cat depending on main_cat
main_cat_Callback(hObject, eventdata, handles);

% set default value of "Per" (freq) dropdown box
set(handles.freq,'value',3);

% enable/disable sub category as appropriate
sub_tick_Callback(handles.sub_tick, eventdata, handles);

% calculate and display user requested spending
recalc(hObject, handles);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes spending wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = spending_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% function: sub_cat_Callback
% last modified: 17/08/13
% description: Executes on selection change in sub_cat
% inputs: hObject - handle to sub_cat (see GCBO)
%         eventdata - to be defined in a future version of MATLAB
%         handles - structure with handles and user data (see GUIDATA)
function sub_cat_Callback(hObject, eventdata, handles)

recalc(hObject, handles);


% --- Executes during object creation, after setting all properties.
function sub_cat_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sub_cat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% function: main_cat_Callback
% last modified: 17/08/13
% description: Executes on selection change in main_cat
% inputs: hObject - handle to main_cat (see GCBO)
%         eventdata - to be defined in a future version of MATLAB
%         handles - structure with handles and user data (see GUIDATA)
function main_cat_Callback(hObject, eventdata, handles)

main_cat_list = get(handles.main_cat,'string');
cat = main_cat_list{get(handles.main_cat,'value')}; % selected category string
struct = get_sub_cat('list', cat, 0);
set(handles.sub_cat,'value',1);
set(handles.sub_cat,'string',struct);

% calculate and display user requested spending
recalc(hObject, handles);

% function: recalc
% last modified: 17/08/13
% description: calculates the weekly spending according to GUI selection
% inputs: hObject - handle 
%         handles - struct holding GUIdata
function recalc(hObject, handles)

% get main and sub categories
main_cat_list = get(handles.main_cat,'string');
main_cat_str = main_cat_list{get(handles.main_cat,'value')}; % selected category string
main_cat_idx = get_main_cat('index',main_cat_str); %selected main cat as index

if ( get(handles.sub_tick,'Value') ) %sub category is activated
    sub_cat_list = get(handles.sub_cat,'string');
    sub_cat_str = sub_cat_list{get(handles.sub_cat,'value')}; % selected category string
    sub_cat_idx = get_sub_cat('index',main_cat_idx,sub_cat_str); %selected sub cat as index
else
    sub_cat_idx = 0;
end

% category matrix that we are interested in 
cats = [main_cat_idx, sub_cat_idx];

% load data
if (get(handles.use_inc,'value'))
    cashflow = [load_data('exp'); load_data('inc')];
else
    cashflow = load_data('exp');
end

% extract cashflow of relevant categories
cf_cats = pick_cats(cats, cashflow, true);

% calculate days_past and reduce cashflow by origin date if necessary
origin_list = get(handles.origin,'string');
origin_str = origin_list{get(handles.origin,'value')};
switch origin_str
    case 'First Record - All'
        days_past = datenum(date) - min(cashflow(:,data_num('date'))) + 1;
    case 'First Record - Category'
        days_past = datenum(date) - min(cf_cats(:,data_num('date'))) + 1;
    case 'Last Week'
        first_day = addtodate(datenum(date), -7, 'day') + 1;
        days_past = datenum(date) - first_day + 1;
        valid_rows = cf_cats(:,data_num('date')) >= first_day;
        cf_cats = cf_cats(valid_rows,:);
    case 'Last Fortnight'
        first_day = addtodate(datenum(date), -14, 'day') + 1;
        days_past = datenum(date) - first_day + 1;
        valid_rows = cf_cats(:,data_num('date')) >= first_day;
        cf_cats = cf_cats(valid_rows,:);
    case 'Last Month'
        first_day = addtodate(datenum(date), -1, 'month') + 1;
        days_past = datenum(date) - first_day + 1;
        valid_rows = cf_cats(:,data_num('date')) >= first_day;
        cf_cats = cf_cats(valid_rows,:);
    case 'Last Quarter'
        first_day = addtodate(datenum(date), -3, 'month') + 1;
        days_past = datenum(date) - first_day + 1;
        valid_rows = cf_cats(:,data_num('date')) >= first_day;
        cf_cats = cf_cats(valid_rows,:);
    case 'Last 6 Months'
        first_day = addtodate(datenum(date), -6, 'month') + 1;
        days_past = datenum(date) - first_day + 1;
        valid_rows = cf_cats(:,data_num('date')) >= first_day;
        cf_cats = cf_cats(valid_rows,:);
    case 'Last 9 Months'
        first_day = addtodate(datenum(date), -9, 'month') + 1;
        days_past = datenum(date) - first_day + 1;
        valid_rows = cf_cats(:,data_num('date')) >= first_day;
        cf_cats = cf_cats(valid_rows,:);        
    case 'Last Year'
        first_day = addtodate(datenum(date), -1, 'year') + 1;
        days_past = datenum(date) - first_day + 1;
        valid_rows = cf_cats(:,data_num('date')) >= first_day;
        cf_cats = cf_cats(valid_rows,:);
end

% WARNING BELOW IS AN APPROXIMATION!!!
% extract user selected definition of a period
freq_list = get(handles.freq,'string');
freq_str = freq_list{get(handles.freq,'value')}; 
switch freq_str
    case 'Day'
        period = 1;
    case 'Week'
        period = 7;
    case 'Fortnight'
        period = 14;
    case 'Month'
        period = 30.42;
    case 'Quarter'
        period = 91.25;
    case 'Year'
        period = 365;
end

% calculate number of periods past
periods = days_past/period;

% divide sum of amounts / number of periods
cat_spend = sum(cf_cats(:,data_num('amount'))) / periods;

%check for empty
if (size(cat_spend,2) == 0)
    cat_spend = 0;
end

% display cat_spend
cat_spend = cur2str(cat_spend); %convert answer to money formatted string
out_str = sprintf('Average spend: %s', cat_spend);
set(handles.result, 'String', out_str);





% --- Executes during object creation, after setting all properties.
function main_cat_CreateFcn(hObject, eventdata, handles)
% hObject    handle to main_cat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% function: sub_tick_Callback
% last modified: 17/08/13
% description: Executes on button press in sub_tick
% inputs: hObject - handle to sub_tick (see GCBO)
%         eventdata - to be defined in a future version of MATLAB
%         handles - structure with handles and user data (see GUIDATA)
function sub_tick_Callback(hObject, eventdata, handles)

if get(hObject,'Value') %sub category box is ticked
    set(handles.sub_cat,'Enable','On');
else
    set(handles.sub_cat,'Enable','Off');
end

% calculate and display user requested spending
recalc(hObject, handles);

function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% function: use_inc_Callback
% last modified: 17/08/13
% description: Executes on button press in use_inc
% inputs: hObject - handle to use_inc (see GCBO)
%         eventdata - to be defined in a future version of MATLAB
%         handles - structure with handles and user data (see GUIDATA)
function use_inc_Callback(hObject, eventdata, handles)

% calculate and display user requested spending
recalc(hObject, handles);

% function: origin_Callback
% last modified: 18/08/13
% description: Executes on selection change in origin
% inputs: hObject - handle to origin (see GCBO)
%         eventdata - to be defined in a future version of MATLAB
%         handles - structure with handles and user data (see GUIDATA)
function origin_Callback(hObject, eventdata, handles)

% calculate and display user requested spending
recalc(hObject, handles);


% --- Executes during object creation, after setting all properties.
function origin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to origin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% function: freq_Callback
% last modified: 18/08/13
% description: Executes on selection change in freq
% inputs: hObject - handle to freq (see GCBO)
%         eventdata - to be defined in a future version of MATLAB
%         handles - structure with handles and user data (see GUIDATA)
function freq_Callback(hObject, eventdata, handles)

% calculate and display user requested spending
recalc(hObject, handles);


% --- Executes during object creation, after setting all properties.
function freq_CreateFcn(hObject, eventdata, handles)
% hObject    handle to freq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
