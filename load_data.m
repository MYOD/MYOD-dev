% function: load_data
% last modified: 24/02/13
% description: universal load function for MYOD data. Does error checks.
% inputs: descriptor - 'inc': returns income data
%                    - 'exp': returns expense data
%                    - 'sched': returns schedule data
%                    - 'exc': returns categories excluded from summarise.m
%                    - 'id': returns the next unique transaction id
%                    - 'true_inc': returns the true income categories excluded
%                      from summarise.m
% outputs: data - MYOD formatted data according to descriptor
function data = load_data(descriptor)

logic_error = false; %precaution in case of invalid parameter

% decode input parameter
switch descriptor
    case 'inc'
        data_var = 'income';
        data_file = 'income.mat';                
    case 'exp'
        data_var = 'expense';
        data_file = 'expense.mat';                
    case 'sched'
        data_var = 'scheduled';
        data_file = 'scheduled.mat';                
    case 'exc'
        data_var = 'exclusions';
        data_file = 'internals.mat';                
    case 'id'
        data_var = 'next_id';
        data_file = 'internals.mat';                
        % potentially may wish to check for existence of data
        % if non-existent may wish to flag error
    case 'true_inc'
        data_var = 'true_inc';
        data_file = 'internals.mat';                        
    otherwise
        logic_error = true;
        errordlg('Invalid Load Descriptor. PLEASE TELL PETER');
end

% load requested data
if ~logic_error    
    if exist(fullfile(data_num('path'), data_file),'file')
        load(fullfile(data_num('path'), data_file));
        if exist(data_var,'var')
            eval(['data = ' data_var ';']);
        else
            warndlg(['The variable ' data_var ' does not exist'],...
            ['Variable ' upper(data_var(1)) data_var(2:end) ...
            ' Does Not Exist']);
            data = [];
        end
    else
        warndlg(['File: ' fullfile(data_num('path'), data_file) ...
            ' was not found. This is needed for the ' data_var ...
            ' data.'],...
            ['No ' upper(data_var(1)) data_var(2:end) ' Data']);
        data = [];
    end
else
    data = [];
end





