% function: save_data
% last modified: 13/01/13
% description: utility to save MYOD data
% inputs: data  - data to be saved
%         descriptor - 'inc': save income data
%                    - 'exp': save expense data
%                    - 'sched': save schedule data
%                    - 'exc': save categories excluded from summarise.m
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

switch descriptor
    case 'inc'
        save(fullfile(data_num('path'),'income.mat'),'data');
        if use_git
            system(data_num('rel_drive'));
            system(['cd ' data_path]);
            system(['git add income.mat > ' oblivion]);
            system(['git commit -m "MYOD auto income update" > ' oblivion]);
        end
    case 'exp'
        save(fullfile(data_num('path'),'expense.mat'),'data');
        if use_git
            system(data_num('rel_drive'));
            system(['cd ' data_path]);
            system(['git add expense.mat > ' oblivion]);
            system(['git commit -m "MYOD auto expense update" > ' oblivion]);
        end
    case 'sched'
        save(fullfile(data_num('path'),'scheduled.mat'),'data');
        if use_git
            system(data_num('rel_drive'));
            system(['cd ' data_path]);
            system(['git add scheduled.mat > ' oblivion]);
            system(['git commit -m "MYOD auto scheduled update" > ' oblivion]);
        end
    case 'exc'
        save(fullfile(data_num('path'),'exclusions.mat'),'data');
        if use_git
            system('D:');
            system(data_num('rel_drive'));
            system(['cd ' data_path]);
            system(['git commit -m "MYOD auto exclusions update" > ' oblivion]);            
        end
    otherwise
        errordlg('Invalid Save Descriptor. PLEASE TELL PETER');
end