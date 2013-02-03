% function: load_data
% last modified: 03/02/13
% description: universal load function for MYOD data. Does error checks.
% inputs: descriptor - 'all': returns expense and income data concatenated
%                    - 'inc': returns income data
%                    - 'exp': returns expense data
%                    - 'sched': returns schedule data
%                    - 'exc': returns categories excluded from summarise.m
%                    - 'id': returns the next unique transaction id
% outputs: data - MYOD formatted data according to descriptor
function data = load_data(descriptor)

switch descriptor
    case 'all'
        data = load_all();
    case 'inc'
        data = load_inc();
    case 'exp'
        data = load_exp();
    case 'sched'
        data = load_sched();
    case 'exc'
        data = load_exc();
    case 'id'
        data = load_id();
end



% function: load_all
% last modified: 20/10/12
% description: loads expense data and income data and concatenates the two
%              a warning will be issued if no prior data for either
% outputs: data
function data = load_all()

exp = load_exp();
inc = load_inc();

data = [exp; inc];



% function load_exp
% last modified: 20/11/12
% description: loads the expense data, returns it as a matrix, plus does a
%              little error checking. If no data exists, a empty matrix is
%              returned, and a warning dialog will be displayed.
% outputs: exp - expense matrix
function exp = load_exp()

if exist(fullfile(data_num('path'), 'expense.mat'),'file')
    load(fullfile(data_num('path'), 'expense.mat'));
    exp = expense;
else
    warndlg('No expense data was found', 'No Expense Records');
    exp = [];
end

% function load_id
% last modified: 03/02/13
% description: loads the next id as a double outputs 
% outputs: id - unique int corresponding to the transaction
function id = load_id()

if exist(fullfile(data_num('path'), 'internals.mat'),'file')
    load(fullfile(data_num('path'), 'internals.mat'));
    id = next_id;
else
    errordlg('MYOD system data not found! Let Peter Know!!', ...
        'MYOD System Data Missing');
    id = 0;
end


% function load_inc
% last modified: 20/11/12
% description: loads the income data, returns it as a matrix, plus does a
%              little error checking. If no data exists, a empty matrix is
%              returned, and a warning dialog will be displayed.
% outputs: inc - income matrix
function inc = load_inc()

if exist(fullfile(data_num('path'), 'income.mat'),'file')
    load(fullfile(data_num('path'), 'income.mat'));
    inc = income;
else
    warndlg('No income data was found', 'No Income Records');
    inc = [];
end


% function load_sched
% last modified: 20/11/12
% description: loads the schedule data, returns it as a matrix, plus does a
%              little error checking. If no data exists, a empty matrix is
%              returned, and a warning dialog will be displayed.
% outputs: sched - income matrix
function sched = load_sched()

if exist(fullfile(data_num('path'), 'scheduled.mat'),'file')
    load(fullfile(data_num('path'), 'scheduled.mat'));
    sched = scheduled;
else
    warndlg('No scheduled data was found', 'No Scheduled Records');
    sched = [];
end


% function load_exc
% last modified: 06/01/13
% description: loads the exclusions data, returns it as a 2 column matrix,
%              plus does a little error checking. These are the categories
%              that do not contribute to expenses average
%              If no data exists, a empty matrix is
%              returned, and a warning dialog will be displayed.
% outputs: exc - income matrix
function exc = load_exc()

if exist(fullfile(data_num('path'), 'exclusions.mat'),'file')
    load(fullfile(data_num('path'), 'exclusions.mat'));
    exc = exclusions;
else
    warndlg('No exclusions data was found', 'No Exclusions Records');
    exc = [];
end




































