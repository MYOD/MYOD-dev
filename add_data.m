function varargout = add_data(varargin)
% ADD_DATA M-file for add_data.fig
%      ADD_DATA, by itself, creates a new ADD_DATA or raises the existing
%      singleton*.
%
%      H = ADD_DATA returns the handle to a new ADD_DATA or the handle to
%      the existing singleton*.
%
%      ADD_DATA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ADD_DATA.M with the given input arguments.
%
%      ADD_DATA('Property','Value',...) creates a new ADD_DATA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before add_data_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to add_data_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help add_data

% Last Modified by GUIDE v2.5 08-Jan-2013 22:36:06

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @add_data_OpeningFcn, ...
                   'gui_OutputFcn',  @add_data_OutputFcn, ...
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

% function: add_data_OpeningFcn
% last modified: 06/01/13
% description: Executes just before add_data is made visible
% inputs: hObject - handle to figure
%         eventdata - to be defined in a future version of MATLAB
%         handles - structure with handles and user data (see GUIDATA)
%         varargin - command line arguments to add_data (see VARARGIN)
% NOTE: This function has no output args, see OutputFcn.
function add_data_OpeningFcn(hObject, eventdata, handles, varargin)

handles.main_hObject = get(hObject,'UserData'); %retrieve a handle to mummy

% initialise gui dates with todays date
set(handles.date,'string',datestr(date,'dd/mm/yy'))

% initialise fund
set(handles.fund,'value',1);
set(handles.fund,'string',get_fund('list',0));

%initialise main_cat
set(handles.main_cat,'value',1)
set(handles.main_cat,'string',get_main_cat('list',0));

% initialise sub_cat depending on main_cat
main_cat_Callback(hObject, eventdata, handles);

% Choose default command line output for add_data
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes add_data wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% function: add_data_OuputFcn
% last modified: 19/10/12
% description: Outputs from this function are returned to the command line
% inputs: varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
function varargout = add_data_OutputFcn(hObject, eventdata, handles) 

% Get default command line output from handles structure
varargout{1} = handles.output;


function amount_Callback(hObject, eventdata, handles)
% hObject    handle to amount (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of amount as text
%        str2double(get(hObject,'String')) returns contents of amount as a double


% --- Executes during object creation, after setting all properties.
function amount_CreateFcn(hObject, eventdata, handles)
% hObject    handle to amount (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function date_Callback(hObject, eventdata, handles)
% hObject    handle to date (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of date as text
%        str2double(get(hObject,'String')) returns contents of date as a double



% --- Executes during object creation, after setting all properties.
function date_CreateFcn(hObject, eventdata, handles)
% hObject    handle to date (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% function: main_cat_Callback
% last modified: 06/01/13
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


% --- Executes on selection change in sub_cat.
function sub_cat_Callback(hObject, eventdata, handles)
% hObject    handle to sub_cat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns sub_cat contents as cell array
%        contents{get(hObject,'Value')} returns selected item from sub_cat


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


% author: Peter Aquilina
% last modified: 4/12/12
% description: Executes on button press in scheduled
% inputs: hObject - handle to scheduled (see GCBO)
%         eventdata - to be defined in a future version of MATLAB
%         handles - structure with handles and user data (see GUIDATA)
function scheduled_Callback(hObject, eventdata, handles)
%
% Hint: get(hObject,'Value') returns toggle state of scheduled
% Toggle visibility of scheduled options
if get(handles.scheduled,'value')
    set(handles.freq_text,'visible','on');
    set(handles.freq,'visible','on');
else
    set(handles.freq_text,'visible','off');
    set(handles.freq,'visible','off');
end


% function: done_Callback
% last modified: 03/02/13
% description: Executes on button press in done
% inputs: hObject - handle to done (see GCBO)
%         eventdata - to be defined in a future version of MATLAB
%         handles - structure with handles and user data (see GUIDATA)
function done_Callback(hObject, eventdata, handles)

newEntry = zeros(1,data_num('columns')); %will hold users new value
void = false; %assume everything is entered correctly

d = get(handles.date,'string'); 
try
    newEntry(data_num('date')) = datenum(d,'dd/mm/yy'); %date
catch
    errordlg('Date format should be DD/MM/YY','Wrong Date Format');
    void = true;
end

a = get(handles.amount,'string');
a = str2double(a);  
newEntry(data_num('amount')) = round(a*100)/100; %amount; only retain 2 decimals
if isnan(newEntry(data_num('amount'))) %user didn't enter a proper number
    errordlg('Amount entered needs to be a valid number!',...
        'Amount Must Be A Number');
    void = true;
elseif newEntry(data_num('amount')) == 0
    errordlg('Amount entered cannot be zero',...
        'Amount Must Be Non-Zero');
    void = true;
end

fund_list = get(handles.fund,'string');
i = get(handles.fund, 'value');
str = fund_list{i}; %selected fund as String
newEntry(data_num('fund')) = get_fund('index',str); %fund as index

main_cat_list = get(handles.main_cat,'string');
i = get(handles.main_cat, 'value');
main_str = main_cat_list{i}; %selected main_cat as String
newEntry(data_num('main_cat')) = get_main_cat('index',main_str); %main_cat as index

sub_cat_list = get(handles.sub_cat,'string');
i = get(handles.sub_cat, 'value');
sub_str = sub_cat_list{i}; %selected sub_cat as String
newEntry(data_num('sub_cat')) = get_sub_cat('index',main_str,sub_str); %sub_cat as index

% add transaction ID
id = load_data('id');
save_data(id+1,'id'); %update id
newEntry(data_num('id')) = id;

if get(handles.scheduled,'value') %scheduled payment was ticked
    contents = get(handles.freq,'String');
    freq = contents{get(handles.freq,'Value')}; %user selected freq
    
    if strcmp(freq, 'Custom') %make sure custom_edit is of right format
        period = str2double(get(handles.custom_edit,'String'));
        if period ~= floor(period) || period <= 0 || isnan(period)
            errordlg(['Scheduled payment''s custom period needs to be '...
                'a positive integer'],'Custom Period Not An Integer');
            void = true;
        end
    end
    
    % user entered a valid new scheduled payment
    if  ~void
        
        % make new Entry for scheduled payments matrix
        new_sched = zeros(1, data_num('s_columns'));
        new_sched(1:data_num('columns')) = newEntry; %copy over data
        new_sched(data_num('s_quantity')) = 0; % not yet been scheduled
        switch freq
            case 'Weekly'
                new_sched(data_num('s_field')) = 1; %day
                new_sched(data_num('s_increment')) = 7;
            case 'Fortnightly'
                new_sched(data_num('s_field')) = 1; %day
                new_sched(data_num('s_increment')) = 14;
            case 'Monthly'
                new_sched(data_num('s_field')) = 2; %month
                new_sched(data_num('s_increment')) = 1;
            case 'Quarterly'
                new_sched(data_num('s_field')) = 2; %month
                new_sched(data_num('s_increment')) = 3;
            case 'Annually'
                new_sched(data_num('s_field')) = 3; %year
                new_sched(data_num('s_increment')) = 1;
            case 'Custom'
                contents = get(handles.custom_list,'String');
                ufreq = contents{get(handles.custom_list,'Value')};
                switch ufreq
                    case 'Day(s)'
                        new_sched(data_num('s_field')) = 1; %day
                        new_sched(data_num('s_increment')) = period;
                    case 'Week(s)'
                        new_sched(data_num('s_field')) = 1; %day
                        new_sched(data_num('s_increment')) = period*7;
                    case 'Month(s)'
                        new_sched(data_num('s_field')) = 2; %month
                        new_sched(data_num('s_increment')) = period;
                    case 'Year(s)'
                        new_sched(data_num('s_field')) = 3; %year
                        new_sched(data_num('s_increment')) = period;                        
                end
        end
        % don't let add_data just willy-nilly add this entry
        void = true; % scheduled payments handled differently
        
        % save new_sched in the MYOD_data
        scheduled = load_data('sched');
        
        scheduled = [scheduled; new_sched];
        save_data(scheduled,'sched');
        
        % update schedule data if need be
        reschedule();
        main_handles = guidata(handles.main_hObject);
        summarise(main_handles);
        delete(handles.figure1);
    end
end


if ~void && newEntry(data_num('amount')) > 0 %save expense

    expense = load_data('exp');
    if expense % there is existing expense data
        t_expense = expense; 
        t_new = newEntry; % temp variables: null fields not interested in
        t_expense(:,data_num('id')) = 0;
        t_new(data_num('id')) = 0;        
    
        % check if transaction already exists
        existing_row = ismember(t_expense,t_new,'rows');
        if existing_row %user entered same transaction
            user = questdlg(['Transaction has previously been entered into '...
                'MYOD. If you unintentionally entered the data twice hit '...
                'cancel, otherwise hit confirm and the amount will be '...
                'added to the existing entry.'],...
                'Duplicate Entry Detected','Confirm','Cancel','Cancel');
            
            if strcmp(user,'Confirm') % add to existing entry
                expense(existing_row,data_num('amount')) = ...
                    expense(existing_row,data_num('amount')) + ...
                    newEntry(data_num('amount'));
            end
        else %not duplicate entry but check if only amount changed
            t_expense(:,data_num('amount')) = 0;
            t_new(data_num('amount')) = 0;
            existing_row = ismember(t_expense,t_new,'rows');
            if existing_row %add amount to existing entry
                expense(existing_row,data_num('amount')) = ...
                    expense(existing_row,data_num('amount')) + ...
                    newEntry(data_num('amount'));
            else % unique entry simple add to existing
                expense = reverse_sort(expense,newEntry); %add newentry
            end
        end
    else % newEntry is the very first expense to be recorded
        expense = newEntry;
    end
            
    save_data(expense,'exp');
    main_handles = guidata(handles.main_hObject);
    summarise(main_handles);
    delete(handles.figure1);
    
elseif ~void && newEntry(data_num('amount')) < 0 % save income
    
    income = load_data('inc');
    if income % there is existing income data
        t_income = income;
        t_new = newEntry; % temp variables: null fields not interested in
        t_income(:,data_num('id')) = 0;
        t_new(data_num('id')) = 0;
        
        % check if transaction already exists
        existing_row = ismember(t_income,t_new,'rows');
        if existing_row %user entered same transaction
            user = questdlg(['Transaction has previously been entered into '...
                'MYOD. If you unintentionally entered the data twice hit '...
                'cancel, otherwise hit confirm and the amount will be '...
                'added to the existing entry.'],...
                'Duplicate Entry Detected','Confirm','Cancel','Cancel');
            
            if strcmp(user,'Confirm') % add to existing entry
                income(existing_row,data_num('amount')) = ...
                    income(existing_row,data_num('amount')) + ...
                    newEntry(data_num('amount'));
            end
        else %not duplicate entry but check if only amount changed
            t_income(:,data_num('amount')) = 0;
            t_new(data_num('amount')) = 0;
            existing_row = ismember(t_income,t_new,'rows');
            if existing_row %add amount to existing entry
                income(existing_row,data_num('amount')) = ...
                    income(existing_row,data_num('amount')) + ...
                    newEntry(data_num('amount'));
            else % unique entry simple add to existing
                income = reverse_sort(income,newEntry); %add newentry
            end
        end
    else % newEntry is the very first income to be recorded
        income = newEntry;
    end
    
    save_data(income,'inc');
    main_handles = guidata(handles.main_hObject);
    summarise(main_handles);
    delete(handles.figure1);
    
end



    
    
% --- Executes on selection change in freq.
function freq_Callback(hObject, eventdata, handles)
% hObject    handle to freq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns freq contents as cell array
%        contents{get(hObject,'Value')} returns selected item from freq
contents = get(handles.freq,'String');
if strcmp(contents{get(handles.freq,'Value')},'Custom')
    set(handles.custom_text,'Visible','On');
    set(handles.custom_edit,'Visible','On');
    set(handles.custom_list,'Visible','On');
else
    set(handles.custom_text,'Visible','Off');
    set(handles.custom_edit,'Visible','Off');
    set(handles.custom_list,'Visible','Off');
end

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


% --- Executes on selection change in fund.
function fund_Callback(hObject, eventdata, handles)
% hObject    handle to fund (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns fund contents as cell array
%        contents{get(hObject,'Value')} returns selected item from fund


% --- Executes during object creation, after setting all properties.
function fund_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fund (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% function: reverse_sort
% last modified: 10/9/12
% description: adds a row to a matrix sorted by its first column. 
%              The algorithm searches backwards to find where to 
%              add the new row
% inputs: mat - sorted matrix by first column
%         row - new row to add
% outputs: mat - updated matrix
function mat = reverse_sort(mat, row)

i = size(mat,1); %index beginning at last row

while i >= 1 && mat(i,1) > row(1)
   i = i-1;    
end

mat = [mat(1:i,:); row; mat(i+1:end,:)];






function custom_edit_Callback(hObject, eventdata, handles)
% hObject    handle to custom_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of custom_edit as text
%        str2double(get(hObject,'String')) returns contents of custom_edit as a double


% --- Executes during object creation, after setting all properties.
function custom_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to custom_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in custom_list.
function custom_list_Callback(hObject, eventdata, handles)
% hObject    handle to custom_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns custom_list contents as cell array
%        contents{get(hObject,'Value')} returns selected item from custom_list


% --- Executes during object creation, after setting all properties.
function custom_list_CreateFcn(hObject, eventdata, handles)
% hObject    handle to custom_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
