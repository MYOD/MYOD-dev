% function: save_data
% last modified: 24/02/13
% description: utility to save MYOD data
% inputs: data  - data to be saved
%         descriptor - 'inc': save income data
%                    - 'exp': save expense data
%                    - 'sched': save schedule data
%                    - 'exc': save categories excluded from summarise.m
%                    - 'id': save the next id in MYOD internals.mat
%                    - 'true_inc': save true income categories excluded
%                      from summarise.m
% NOTE: Please note that save_data is not general as  behaviour is unique 
%       to my requirements and based on windows
% NOTE: save_data has a dependency on git being installed on the machine
%       and in the path.
function save_data(data,descriptor)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   WARNING CODE IN HERE IS NOT GENERAL AND INTENDED FOR MY PC ONLY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
curr_dir = pwd();
if strcmp(curr_dir,data_num('rel_path'))
    use_git = true; % boolean true if automatically update stuff in git
else
    use_git = false;
end

%for the silencing of system commands
if ispc
    oblivion = 'NUL';
else
    oblivion = '/dev/null';
end
data_path = fullfile(data_num('rel_path'),data_num('path'));

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
    case 'last_arg'
        data_var = 'last_arg'; %date of last argument
        data_file = 'internals.mat';
    otherwise
        logic_error = true;
        errordlg('Invalid Save Descriptor. PLEASE TELL PETER');
end
% save data
if ~logic_error
    eval([data_var ' = data;']); %make an appropriately named variable
    % save it in the right file
    if exist(fullfile(data_num('path'),data_file),'file')
        save(fullfile(data_num('path'),data_file),data_var,...
            '-append');
    else
        save(fullfile(data_num('path'),data_file),data_var);
    end
    
    % automatically commit to git
    if use_git
        r = cd(data_path);
        system(['git add ' data_file ' > ' oblivion]);
        system(['git commit -m "MYOD auto ' data_var ' update" > ' ...
            oblivion]);
        cd(r);
    end
    
end













































