% function: save_data
% last modified: 03/02/13
% description: utility to save MYOD data
% inputs: data  - data to be saved
%         descriptor - 'inc': save income data
%                    - 'exp': save expense data
%                    - 'sched': save schedule data
%                    - 'exc': save categories excluded from summarise.m
%                    - 'id': save the next id in MYOD internals.mat
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
        income = data;
        save(fullfile(data_num('path'),'income.mat'),'income');
        if use_git
            r = cd(data_path);
            system(['git add income.mat > ' oblivion]);
            system(['git commit -m "MYOD auto income update" > ' oblivion]);
            cd(r);
        end
    case 'exp'
        expense = data;
        save(fullfile(data_num('path'),'expense.mat'),'expense');
        if use_git
            r = cd(data_path);
            system(['git add expense.mat > ' oblivion]);
            system(['git commit -m "MYOD auto expense update" > ' oblivion]);
            cd(r);
        end
    case 'sched'
        scheduled = data;
        save(fullfile(data_num('path'),'scheduled.mat'),'scheduled');
        if use_git
            r = cd(data_path);
            system(['git add scheduled.mat > ' oblivion]);
            system(['git commit -m "MYOD auto scheduled update" > ' oblivion]);
            cd(r);
        end
    case 'exc'
        exclusions = data;
        save(fullfile(data_num('path'),'exclusions.mat'),'exclusions');
        if use_git
            r = cd(data_path);
            system(['git add exclusions.mat > ' oblivion]);
            system(['git commit -m "MYOD auto exclusions update" > ' oblivion]);            
            cd(r);
        end
    case 'id'
        next_id = data;
        save(fullfile(data_num('path'),'internals.mat'),'next_id');
        if use_git
            r = cd(data_path);
            system(['git add internals.mat > ' oblivion]);
            system(['git commit -m "MYOD auto internals update" > ' oblivion]);
            cd(r);
        end
    otherwise
        errordlg('Invalid Save Descriptor. PLEASE TELL PETER');
end