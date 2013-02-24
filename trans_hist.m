function varargout = trans_hist(varargin)
% TRANS_HIST M-file for trans_hist.fig
%      TRANS_HIST, by itself, creates a new TRANS_HIST or raises the existing
%      singleton*.
%
%      H = TRANS_HIST returns the handle to a new TRANS_HIST or the handle to
%      the existing singleton*.
%
%      TRANS_HIST('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TRANS_HIST.M with the given input arguments.
%
%      TRANS_HIST('Property','Value',...) creates a new TRANS_HIST or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before trans_hist_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to trans_hist_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help trans_hist

% Last Modified by GUIDE v2.5 18-Sep-2012 21:51:22

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @trans_hist_OpeningFcn, ...
                   'gui_OutputFcn',  @trans_hist_OutputFcn, ...
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

% function: trans_hist_OpeningFcn
% last modified: 24/02/13
% description: Executes just before trans_hist is made visible
% inputs: hObject - handle to figure
%         eventdata - to be defined in a future version of MATLAB
%         handles - structure with handles and user data (see GUIDATA)
%         varargin - command line arguments to trans_hist (see VARARGIN)
% NOTE: This function has no output args, see OutputFcn
% NOTE: modifies handles
function trans_hist_OpeningFcn(hObject, eventdata, handles, varargin) 

% Choose default command line output for trans_hist
handles.output = hObject;

handles.main_hObject = get(hObject,'UserData'); %retrieve a handle to mummy

% initialise pop-up menus
cat_menu = get_main_cat('list',0); %initialise category filter menu
cat_menu = [{'All'} cat_menu];
set(handles.cat_filt,'value',1)
set(handles.cat_filt,'String',cat_menu);
fund_menu = get_fund('list',0); %initialise fund filter menu
fund_menu = [{'All'} fund_menu];
set(handles.fund_filt,'value',1)
set(handles.fund_filt,'String',fund_menu);

% constants used for MYOD info cells
handles.info.tick = 1;
handles.info.columns = 7;
handles.info.date = 2;
handles.info.main_cat = 3;
handles.info.sub_cat = 4;
handles.info.out = 5; 
handles.info.in = 6;
handles.info.fund = 7;

% prepare the table
handles.small_pos = [55 50 608.5 350];
handles.big_pos = [55 50 608.5 520];
handles.table = uitable('Parent', handles.figure1, 'Position', ...
    handles.big_pos);
initialise_table(handles); %display table

% prepare the data
handles.data = [load_data('exp'); load_data('inc')];
if size(handles.data,1) > 0
    sort_data(hObject, handles); %sort it
    handles = guidata(hObject); %reload updated handles
    update_table(handles); % display data
end

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes trans_hist wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = trans_hist_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


function to_date_Callback(hObject, eventdata, handles)
% hObject    handle to to_date (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of to_date as text
%        str2double(get(hObject,'String')) returns contents of to_date as a double


% --- Executes during object creation, after setting all properties.
function to_date_CreateFcn(hObject, eventdata, handles)
% hObject    handle to to_date (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function from_date_Callback(hObject, eventdata, handles)
% hObject    handle to from_date (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of from_date as text
%        str2double(get(hObject,'String')) returns contents of from_date as a double



% --- Executes during object creation, after setting all properties.
function from_date_CreateFcn(hObject, eventdata, handles)
% hObject    handle to from_date (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% function: initialise_table
% last modified: 20/10/12
% description: sets up the table
% inputs: handles - gui data
function initialise_table(handles)

% set up table
set(handles.table, 'ColumnName', {'','Date','Main Category', ...
    'Sub Category', 'Money Out', 'Money In', 'Fund'}); %headings
set(handles.table,'ColumnWidth',{40,80,130,100,80,80,80}); %force widths
set(handles.table, 'RowName', []); % don't need row labels

% alternate row colours
foregroundColor = [0.3 0.3 0.3]; % 0 is white, 1 is black
set(handles.table, 'ForegroundColor', foregroundColor);
% backgroundColor = [.4 .1 .1; .1 .1 .4]; % dark 
backgroundColor = [0.53 0.81 0.92; .63 .91 1]; %blue
set(handles.table, 'BackgroundColor', backgroundColor);

% allow user to tick first column
set(handles.table, 'ColumnEditable', ...
    [true false false false false false false]);



% function: update_table
% last modified: 20/10/12
% description: updates contents of table in axes
% inputs: handles - gui data
function update_table(handles)

%put data in table
set(handles.table, 'Data', extract_info(handles, handles.data)); 



% function: invert_info
% last modified: 19/10/12
% description: reads the display formatted 'info' cell and returns 
%              matrix formatted according to MYOD data. 
%              Essentially the inverse of extract_info
% inputs: handles - gui data
%         info - display formatted cell based on MYOD data
% NOTE: it isn't possible to get the original id, as such this will be 0
function data = invert_info(handles, info)

data = zeros(size(info,1),data_num('columns'));

% date
data(:,data_num('date')) = datenum(info(:,handles.info.date),'dd/mm/yy');

% amount
for i = 1:size(info,1)
   amount = info{i,handles.info.out}; %assume its an expense
   if size(amount,2) <= 1 %wrong, its income
       amount = info{i,handles.info.in}; 
       amount(1) = ''; %remove dollar symbols
       amount = - str2double(amount);
   else
       amount(1) = ''; %remove dollar symbols
       amount = str2double(amount);
   end

   data(i,data_num('amount')) = amount;

end

% fund
funds = info(:,handles.info.fund);
data(:,data_num('fund')) = get_fund('array',funds);

% main_cat
main_cats = info(:,handles.info.main_cat);
data(:,data_num('main_cat')) = get_main_cat('array',main_cats);

% sub_cat
for i = 1:size(info,1)
    data(i,data_num('sub_cat')) = get_sub_cat('index',...
        data(i,data_num('main_cat')),info{i,handles.info.sub_cat});    
end

% function: extract_info
% last modified: 18/10/12
% description: reads in MYOD formatted expense/income data and converts it
%              to a struct that can be displayed in an meaningful sense to
%              the user
% inputs: handles - gui data
%         data - MYOD formatted expense/income data to be displayed
function info = extract_info(handles, data)

% initialise info 
r = size(data,1); %will have same # of rows as data
if r > 0
    info = cell(r, handles.info.columns);
    
    % first column will all be false (makes rows selectable)
    info(:,handles.info.tick) = {false};
    
    % second column will have the dates as strings
    dates = datestr(data(:,data_num('date')), 'dd/mm/yy');
    info(:,handles.info.date) = cellstr(dates);
    
    % third column is the main category
    info(:,handles.info.main_cat) = get_main_cat('cell',...
        data(:,data_num('main_cat')));
    
    % fourth column is the sub categories
    info(:,handles.info.sub_cat) = get_sub_cat('cell',...
        data(:,data_num('main_cat')),data(:,data_num('sub_cat')));
    
    % fifth column is the money out (expenses)
    exp = data(:,data_num('amount')); %exp short for expense
    exp_rows = exp > 0; %interested only in positive amounts
    exp = num2str(exp,'%-0.2f'); %convert to a string with 2 decimal places
    exp = strcat('$',exp); %prefix $
    exp(~exp_rows,:) = ' '; %hide items not interested in
    info(:,handles.info.out) = cellstr(exp);
    
    % sixth column is for the money in (income)
    inc = - data(:,data_num('amount')); %inc short for income
    inc = num2str(inc,'%-0.2f'); %convert to a string with 2 decimal places
    inc = strcat('$',inc); %prefix $
    inc(exp_rows,:) = ' '; %hide items not interested in
    info(:,handles.info.in) = cellstr(inc);
    
    % seventh column is for the fund
    info(:,handles.info.fund) = get_fund('cell',data(:,data_num('fund')));
else
    info = {};
end


% function: dates_filt_Callback
% last modified: 18/10/12
% description: Executes on selection change in dates_filt
% inputs: hObject - handle to dates_filt (see GCBO)
%         eventdata - to be defined in a future version of MATLAB
%         handles - structure with handles and user data (see GUIDATA)
function dates_filt_Callback(hObject, eventdata, handles)

% if selected item = 'Specific Period' show date inputs
contents = get(handles.dates_filt,'String');
selected = contents{get(handles.dates_filt,'Value')};

if strcmp(selected, 'Specific Period')
    state = 'on';
else
    state = 'off';
end

set(handles.text11,'Visible',state);
set(handles.text2,'Visible',state);
set(handles.from_date,'Visible',state);
set(handles.to_date,'Visible',state);

% --- Executes during object creation, after setting all properties.
function dates_filt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dates_filt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% function: cat_filt_Callback
% last modified: 06/01/13
% description: callback when main_filt menu is changed
% inputs: hObject - handle to cat_filt (see GCBO)
%         eventdata - to be defined in a future version of MATLAB
%         handles - structure with handles and user data (see GUIDATA)
function cat_filt_Callback(hObject, eventdata, handles)

% if 'All' not selected show sub category

contents = get(handles.cat_filt,'String');
selected = contents{get(handles.cat_filt,'Value')};

if strcmp(selected, 'All')
    state = 'off';
else %show sub category
    state = 'on';
    sub_menu = get_sub_cat('list',selected,0);
    sub_menu = [{'All'} sub_menu];
    set(handles.sub_filt,'value',1)
    set(handles.sub_filt,'String', sub_menu);
end

set(handles.text14,'Visible',state);
set(handles.sub_filt,'Visible',state);




% --- Executes during object creation, after setting all properties.
function cat_filt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cat_filt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% function: amount_filt_Callback
% last modified: 18/10/12
% description: Executes on selection change in amount_filt
% inputs: hObject - handle to amount_filt (see GCBO)
%         eventdata - to be defined in a future version of MATLAB
%         handles - structure with handles and user data (see GUIDATA)
function amount_filt_Callback(hObject, eventdata, handles)

% if selected item is 'Specific Range' show range inputs

contents = get(handles.amount_filt,'String');
selected = contents{get(handles.amount_filt,'Value')};

if strcmp(selected, 'Specific Range')
    state = 'on';
else
    state = 'off';
end

set(handles.text12,'Visible',state);
set(handles.text13,'Visible',state);
set(handles.from_amount,'Visible',state);
set(handles.to_amount,'Visible',state);


% --- Executes during object creation, after setting all properties.
function amount_filt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to amount_filt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in cashflow_filt.
function cashflow_filt_Callback(hObject, eventdata, handles)
% hObject    handle to cashflow_filt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns cashflow_filt contents as cell array
%        contents{get(hObject,'Value')} returns selected item from cashflow_filt


% --- Executes during object creation, after setting all properties.
function cashflow_filt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cashflow_filt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in fund_filt.
function fund_filt_Callback(hObject, eventdata, handles)
% hObject    handle to fund_filt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns fund_filt contents as cell array
%        contents{get(hObject,'Value')} returns selected item from fund_filt


% --- Executes during object creation, after setting all properties.
function fund_filt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fund_filt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function to_amount_Callback(hObject, eventdata, handles)
% hObject    handle to to_amount (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of to_amount as text
%        str2double(get(hObject,'String')) returns contents of to_amount as a double


% --- Executes during object creation, after setting all properties.
function to_amount_CreateFcn(hObject, eventdata, handles)
% hObject    handle to to_amount (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function from_amount_Callback(hObject, eventdata, handles)
% hObject    handle to from_amount (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of from_amount as text
%        str2double(get(hObject,'String')) returns contents of from_amount as a double


% --- Executes during object creation, after setting all properties.
function from_amount_CreateFcn(hObject, eventdata, handles)
% hObject    handle to from_amount (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% function: sub_filt_Callback
% last modified: 18/10/12
% description: callback for when sub_filt menu changed
% inputs: hObject - handle to sub_filt (see GCBO)
%         eventdata - to be defined in a future version of MATLAB
%         handles - structure with handles and user data (see GUIDATA) 
function sub_filt_Callback(hObject, eventdata, handles)



% --- Executes during object creation, after setting all properties.
function sub_filt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sub_filt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% function: descriptor_Callback
% last modified: 20/10/12
% description: Executes on selection change in descriptor popup menu
% inputs: hObject - handle to descriptor (see GCBO)
%         eventdata - to be defined in a future version of MATLAB
%         handles - structure with handles and user data (see GUIDATA)
function descriptor_Callback(hObject, eventdata, handles)

sort_data(hObject, handles);
handles = guidata(hObject); %reload updated handles
update_table(handles);


% function: sort_data
% last modified: 18/10/12
% description: sort the entries based on the 'data' matrix according to 
%              popup menu options
% inputs: hObject - handle to gui
%         handles - gui data
% NOTE: modifies handles
function sort_data(hObject, handles)

% find the selected descriptor and if user wishes output to be ascending
contents = get(handles.descriptor,'String');
selected_des = contents{get(handles.descriptor,'Value')}; 
contents = get(handles.order,'String');
if strcmp('Ascending',contents{get(handles.order,'Value')});
    asc = 1;
else 
    asc = -1; 
end

switch selected_des
    case 'Date'
        handles.data = sortrows(handles.data, asc * data_num('date'));
    case 'Category'
        sort_category(hObject, handles, asc);
        handles = guidata(hObject);        
    case 'Amount'
        handles.data = sortrows(handles.data, asc * data_num('amount'));                
    case 'Fund'
        sort_fund(hObject, handles, asc);
        handles = guidata(hObject);
end



guidata(hObject,handles); % update handles

% function: sort_fund
% last modified: 19/10/12
% description: sort handles.data by fund
% inputs: hObject - gui handle
%         handles - gui data
%         asc - +1 = ascending, -1 = descending
% NOTE: modifies handles
function sort_fund(hObject, handles, asc)

% first make a reference table to sort fund data
fund_table = get_fund('list',0);
fund_table = sort(fund_table); %alphabetise
fund_table = get_fund('array',fund_table); %convert to sorted indices
reference = sort(fund_table); %have the indices in ascending order
%1st column sorted alphabetically, 2nd sorted numerically
fund_table = [fund_table reference];

% next add a column to the data using fund table
handles.data = [handles.data zeros(size(handles.data,1),1)];
for i = 1:size(fund_table,1)
    handles.data(:,end) = handles.data(:,end) + ...
        fund_table(i,2) .* (fund_table(i,1) == ...
        handles.data(:,data_num('fund')));
end

%sort by this column and then discard
handles.data = sortrows(handles.data, asc * size(handles.data,2));
handles.data = handles.data(:,1:end-1);

guidata(hObject, handles);


% function: sort_category
% last modified: 19/10/12
% description: sort handles.data by category
% inputs: hObject - gui handle
%         handles - gui data
%         asc - +1 = ascending, -1 = descending
% NOTE: modifies handles
function sort_category(hObject, handles, asc)

% first make a reference table to sort fund data
main_table = get_main_cat('list',0);
main_table = sort(main_table); %alphabetise
main_table = get_main_cat('array',main_table); %convert to sorted indices
reference = sort(main_table); %have the indices in ascending order
%1st column sorted alphabetically, 2nd sorted numerically
main_table = [main_table reference];

% next add a column to the data using main_table
handles.data = [handles.data zeros(size(handles.data,1),1)];
for i = 1:size(main_table,1)
    handles.data(:,end) = handles.data(:,end) + ...
        main_table(i,2) .* (main_table(i,1) == ...
        handles.data(:,data_num('main_cat')));
end

%sort by this column and then discard
handles.data = sortrows(handles.data, asc * size(handles.data,2));
handles.data = handles.data(:,1:end-1);

% repeat this process for each sub category
for i = 1:size(main_table,1) %for each main category
    % extract sub data
    main_key = main_table(i,1);
    test = handles.data(:,data_num('main_cat')) == main_key;
    alpha = find(test,1,'first');
    omega = find(test,1,'last');
    data = handles.data(alpha:omega,:);
    data = sort_sub_cat(asc, data, main_key); %sort it in isolation
    handles.data(alpha:omega,:) = data; %put it back in
end

guidata(hObject, handles);



% function: sort_sub_cat
% last modified: 19/10/12
% description: sort input data by sub_cat
% inputs: asc - +1 = ascending, -1 = descending
%         data - a subset of handles.data
%         main_key - the key for the main category
% outputs: data - sorted input data
function data = sort_sub_cat(asc, data, main_key)

% first make a reference table to sort sub_cat data
sub_cat_table = get_sub_cat('list',main_key,0);
sub_cat_table = sort(sub_cat_table); %alphabetise
%convert to sorted indices
sub_cat_table = get_sub_cat('array',main_key,sub_cat_table); 
reference = sort(sub_cat_table); %have the indices in ascending order
%1st column sorted alphabetically, 2nd sorted numerically
sub_cat_table = [sub_cat_table reference];

% next add a column to the data using fund table
data = [data zeros(size(data,1),1)];
for i = 1:size(sub_cat_table,1)
    data(:,end) = data(:,end) + ...
        sub_cat_table(i,2) .* (sub_cat_table(i,1) == ...
        data(:,data_num('sub_cat')));
end

%sort by this column and then discard
data = sortrows(data, asc * size(data,2));
data = data(:,1:end-1);


% --- Executes during object creation, after setting all properties.
function descriptor_CreateFcn(hObject, eventdata, handles)
% hObject    handle to descriptor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% function: order_Callback
% last modified: 18/10/12
% description: Executes on selection change in order
% inputs: hObject - handle to order (see GCBO)
%         eventdata - to be defined in a future version of MATLAB
%         handles - structure with handles and user data (see GUIDATA)
function order_Callback(hObject, eventdata, handles)

descriptor_Callback(hObject, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function order_CreateFcn(hObject, eventdata, handles)
% hObject    handle to order (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in test.
function test_Callback(hObject, eventdata, handles)
% hObject    handle to test (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% make all visible
set(handles.text2,'Visible','on');
set(handles.text11,'Visible','on');
set(handles.text14,'Visible','on');
set(handles.text13,'Visible','on');
set(handles.text12,'Visible','on');
set(handles.from_amount,'Visible','on');
set(handles.to_amount,'Visible','on');
set(handles.from_date,'Visible','on');
set(handles.to_date,'Visible','on');
set(handles.sub_filt,'Visible','on');

% function: show_filt_Callback
% last modified: 18/10/12
% description: Executes on button press in show_filt
% inputs: hObject - handle to show_filt (see GCBO)
%         eventdata - to be defined in a future version of MATLAB
%         handles - structure with handles and user data (see GUIDATA)
function show_filt_Callback(hObject, eventdata, handles)

if get(hObject,'Value')
   set(hObject,'Value',false);
   msgbox('This exciting new feature is not yet ready for release'...
       ,'Coming Soon');
end

% if get(hObject,'Value')
%     state = 'on';
%     % call callbacks
%     dates_filt_Callback(hObject,eventdata,handles);
%     cat_filt_Callback(hObject,eventdata,handles);
%     amount_filt_Callback(hObject,eventdata,handles);
%     
%     pos = handles.small_pos; % new dimensions of table
%     
% else
%     state = 'off';
%     % ensure optional menus are hidden
%     set(handles.text2,'Visible','off');
%     set(handles.text11,'Visible','off');
%     set(handles.text12,'Visible','off');
%     set(handles.text13,'Visible','off');
%     set(handles.text14,'Visible','off');
%     set(handles.from_date,'Visible','off');
%     set(handles.to_date,'Visible','off');
%     set(handles.sub_filt,'Visible','off');
%     set(handles.from_amount,'Visible','off');
%     set(handles.to_amount,'Visible','off');
%     
%     pos = handles.big_pos; %new dimensions of table
% end
% 
% % display/hide filter options
% set(handles.dates_filt,'Visible',state);
% set(handles.cat_filt,'Visible',state);
% set(handles.amount_filt,'Visible',state);
% set(handles.cashflow_filt,'Visible',state);
% set(handles.fund_filt,'Visible',state);
% set(handles.reset,'Visible',state);
% set(handles.show_all,'Visible',state);
% set(handles.apply,'Visible',state);
% set(handles.text5,'Visible',state);
% set(handles.text6,'Visible',state);
% set(handles.text7,'Visible',state);
% set(handles.text8,'Visible',state);
% set(handles.text9,'Visible',state);
% 
% %resize table
% set(handles.table,'Position',pos);


% --- Executes on button press in reset.
function reset_Callback(hObject, eventdata, handles)
% hObject    handle to reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in apply.
function apply_Callback(hObject, eventdata, handles)
% hObject    handle to apply (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in show_all.
function show_all_Callback(hObject, eventdata, handles)
% hObject    handle to show_all (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% function: delete_Callback
% last modified: 03/02/13
% description: Executes on button press in delete
% inputs: hObject - handle to delete (see GCBO)
%         eventdata - to be defined in a future version of MATLAB
%         handles - structure with handles and user data (see GUIDATA)
% NOTE: updates handles and can modify MYOD data
function delete_Callback(hObject, eventdata, handles) 

% retrieve the data from the table
info = get(handles.table,'data');
ticks = cell2mat(info(:,1)); %as a logical array
num_selected = sum(ticks);

% provide user with a warning
if num_selected == 0
   errordlg('You need to select at least 1 item to delete',...
       'No Items Selected'); 
else
    button = questdlg(['Are you sure you want to permanently remove '...
        num2str(num_selected) ' items from MYOD''s history?'],...
        'Confirm Intention To Delete','Yes', 'No', 'No');
    
    
    % remove selected items from handles.data
    if strcmp(button,'Yes')
        bad_rows = info(ticks,:); % rows to delete (as formatted cells)
        bad_rows = invert_info(handles,bad_rows); %(as MYOD data)
        t_data = handles.data; 
        t_data(:,data_num('id')) = 0; %temp copy to null id
        bad_idx = ismember(t_data, bad_rows, 'rows'); %(as logical indices)
        if sum(bad_idx) ~= num_selected %error check
           errordlg('Selected rows not found in data. PLEASE TELL PETER',...
               'CAUTION'); 
        end
        handles.data(bad_idx,:) = []; % delete them
        guidata(hObject, handles); %update handles
        
        % update the table
        update_table(handles)
        
        % remove selected items from saved MYOD data
        % separate bad_rows for income and expense bad_inc & bad_exp
        %income rows logical idx        
        bad_idx_inc = bad_rows(:,data_num('amount')) < 0; 
        
        % delete income elements
        if sum(bad_idx_inc) ~= 0% must delete income data
            income = load_data('inc');
            t_inc = income; 
            t_inc(:,data_num('id')) = 0; %temp copy to nullify id
            bad_inc = bad_rows(bad_idx_inc,:); %income rows (as data)
            bad_idx = ismember(t_inc, bad_inc, 'rows');
            if sum(bad_idx) == 0 %error check
                errordlg(['Selected rows not found in MYOD income ' ...
                    'data. PLEASE TELL PETER'], 'CAUTION');
            end
            income(bad_idx,:) = []; % delete
            save_data(income,'inc');
        end
        
        % delete expense elements
        if sum(~bad_idx_inc) ~= 0 % must delete expense data
            expense = load_data('exp');
            t_exp = expense; 
            t_exp(:,data_num('id')) = 0; %temp copy to nullify id            
            bad_exp = bad_rows(~bad_idx_inc,:); %expense rows (as data)
            bad_idx = ismember(t_exp, bad_exp, 'rows');
            if sum(bad_idx) == 0 %error check
                errordlg(['Selected rows not found in MYOD expense ' ...
                    'data. PLEASE TELL PETER'], 'CAUTION');
            end
            expense(bad_idx,:) = []; % delete
            save_data(expense,'exp');
        end
        
        % update summary
        main_handles = guidata(handles.main_hObject);
        summarise(main_handles);
        
    end
end














% 






